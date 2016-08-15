<cfscript>
	/*
	*  PUBLIC MODEL CLASS METHODS
	*/

	public any function findAll(
		string where="",
		string order,
		string group,
		string select="",
		boolean distinct="false",
		string include="",
		numeric maxRows="-1",
		numeric page="0",
		numeric perPage,
		numeric count="0",
		string handle="query",
		any cache="",
		boolean reload,
		any parameterize,
		string returnAs,
		boolean returnIncluded,
		boolean callbacks="true",
		boolean includeSoftDeletes="false",
		numeric $limit="0",
		numeric $offset="0"
	) {
		$args(name="findAll", args=arguments);
		arguments.include = $listClean(arguments.include);
		arguments.where = $cleanInList(arguments.where);

		// we only allow direct associations to be loaded when returning objects
		if (application.wheels.showErrorInformation && Len(arguments.returnAs) && arguments.returnAs != "query" && Find("(", arguments.include) && arguments.returnIncluded)
		{
			$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="You may only include direct associations to this object when returning an array of objects.");
		}

		// count records and get primary keys for pagination
		if (arguments.page)
		{
			if (application.wheels.showErrorInformation && arguments.perPage <= 0)
			{
				$throw(type="Wheels", message="Incorrect Argument", extendedInfo="The `perPage` argument should be a positive numeric value.");
			}
			if (Len(arguments.order))
			{
				// insert primary keys to order clause unless they are already there, this guarantees that the ordering is unique which is required to make pagination work properly
				local.compareList = $listClean(ReplaceNoCase(ReplaceNoCase(arguments.order, " ASC", "", "all"), " DESC", "", "all"));
				local.iEnd = ListLen(primaryKeys());
				for (local.i=1; local.i <= local.iEnd; local.i++)
				{
					local.item = primaryKeys(local.i);
					if (!ListFindNoCase(local.compareList, local.item) && !ListFindNoCase(local.compareList, tableName() & "." & local.item))
					{
						arguments.order = ListAppend(arguments.order, local.item);
					}
				}
			}
			else
			{
				// we can't paginate without any order so we default to ascending ordering by the primary key column(s)
				arguments.order = primaryKey();
			}
			if (Len(arguments.include))
			{
				local.distinct = true;
			}
			else
			{
				local.distinct = false;
			}
			if (arguments.count > 0)
			{
				local.totalRecords = arguments.count;
			}
			else
			{
				local.totalRecords = this.count(where=arguments.where, include=arguments.include, reload=arguments.reload, cache=arguments.cache, distinct=local.distinct, parameterize=arguments.parameterize, includeSoftDeletes=arguments.includeSoftDeletes);
			}
			local.currentPage = arguments.page;
			if (local.totalRecords == 0)
			{
				local.totalPages = 0;
				local.rv = "";
			}
			else
			{
				local.totalPages = Ceiling(local.totalRecords/arguments.perPage);
				local.limit = arguments.perPage;
				local.offset = (arguments.perPage * arguments.page) - arguments.perPage;

				// if the full range of records is not requested we correct the limit to get the exact amount instead
				// for example if totalRecords is 57, limit is 10 and offset 50 (i.e. requesting records 51-60) we change the limit to 7
				if ((local.limit + local.offset) > local.totalRecords)
				{
					local.limit = local.totalRecords - local.offset;
				}

				if (local.limit < 1)
				{
					// if limit is 0 or less it means that a page that has no records was asked for so we return an empty query
					local.rv = "";
				}
				else
				{
					local.values = findAll($limit=local.limit, $offset=local.offset, select=primaryKeys(), where=arguments.where, order=arguments.order, include=arguments.include, reload=arguments.reload, cache=arguments.cache, distinct=local.distinct, parameterize=arguments.parameterize, includeSoftDeletes=arguments.includeSoftDeletes, callbacks=false);
					if (local.values.RecordCount)
					{
						local.paginationWhere = "";
						local.iEnd = local.values.recordCount;
						for (local.i=1; local.i <= local.iEnd; local.i++)
						{
							local.keyComboValues = [];
							local.jEnd = ListLen(primaryKeys());
							for (local.j=1; local.j <= local.jEnd; local.j++)
							{
								local.property = primaryKeys(local.j);
								ArrayAppend(local.keyComboValues, "#tableName()#.#local.property# = #variables.wheels.class.adapter.$quoteValue(str=local.values[local.property][local.i], type=validationTypeForProperty(local.property))#");
							}
							local.paginationWhere = ListAppend(local.paginationWhere, "(" & ArrayToList(local.keyComboValues, " AND ") & ")", Chr(7));
 						}
						local.paginationWhere = Replace(local.paginationWhere, Chr(7), " OR ", "all");

 						// this can be improved to also check if the where clause checks on a joined table, if not we can use the simple where clause with just the ids
 						if (Len(arguments.where) && Len(arguments.include))
 						{
 							arguments.where = "(#arguments.where#) AND (#local.paginationWhere#)";
 						}
 						else
						{
							arguments.where = local.paginationWhere;
						}
					}
				}
			}
			// store pagination info in the request scope so all pagination methods can access it
			setPagination(local.totalRecords, local.currentPage, arguments.perPage, arguments.handle);
		}

		if (StructKeyExists(local, "rv") && !Len(local.rv))
		{
			if (arguments.returnAs == "query")
			{
				local.rv = QueryNew("");
			}
			else if (singularize(arguments.returnAs) == arguments.returnAs)
			{
				local.rv = false;
			}
			else
			{
				local.rv = ArrayNew(1);
			}
		}
		else if (!StructKeyExists(local, "rv"))
		{
			// make the where clause generic for use in caching
			local.originalWhere = arguments.where;
			arguments.where = REReplace(arguments.where, variables.wheels.class.RESQLWhere, "\1?\8" , "all");

			// get info from cache when available, otherwise create the generic select, from, where and order by clause
			local.queryShellKey = $hashedKey(variables.wheels.class.modelName, arguments);
			local.sql = $getFromCache(local.queryShellKey, "sql");
			if (!IsArray(local.sql))
			{
				local.sql = [];
				ArrayAppend(local.sql, $selectClause(select=arguments.select, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes, returnAs=arguments.returnAs));
				ArrayAppend(local.sql, $fromClause(include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes));
				local.sql = $addWhereClause(sql=local.sql, where=local.originalWhere, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes);
				local.groupBy = $groupByClause(select=arguments.select, group=arguments.group, include=arguments.include, distinct=arguments.distinct, returnAs=arguments.returnAs);
				if (Len(local.groupBy))
				{
					ArrayAppend(local.sql, local.groupBy);
				}
				local.orderBy = $orderByClause(order=arguments.order, include=arguments.include);
				if (Len(local.orderBy))
				{
					ArrayAppend(local.sql, local.orderBy);
				}
				$addToCache(key=local.queryShellKey, value=local.sql, category="sql");
			}

			// add where clause parameters to the generic sql info
			local.sql = $addWhereClauseParameters(sql=local.sql, where=local.originalWhere);

			// return existing query result if it has been run already in current request, otherwise pass off the sql array to the query
			local.queryKey = $hashedKey(variables.wheels.class.modelName, arguments, local.originalWhere);
			if (application.wheels.cacheQueriesDuringRequest && !arguments.reload && StructKeyExists(request.wheels, local.queryKey))
			{
				local.findAll = request.wheels[local.queryKey];
			}
			else
			{
				local.finderArgs = {};
				local.finderArgs.sql = local.sql;
				local.finderArgs.maxRows = arguments.maxRows;
				local.finderArgs.parameterize = arguments.parameterize;
				local.finderArgs.limit = arguments.$limit;
				local.finderArgs.offset = arguments.$offset;
				local.finderArgs.$primaryKey = primaryKeys();
				if (application.wheels.cacheQueries && (IsNumeric(arguments.cache) || (IsBoolean(arguments.cache) && arguments.cache)))
				{
					local.finderArgs.cachedWithin = $timeSpanForCache(arguments.cache);
				}
				local.findAll = variables.wheels.class.adapter.$query(argumentCollection=local.finderArgs);
				request.wheels[local.queryKey] = local.findAll; // <- store in request cache so we never run the exact same query twice in the same request
			}
			request.wheels[$hashedKey(local.findAll.query)] = variables.wheels.class.modelName; // place an identifer in request scope so we can reference this query when passed in to view functions

			switch (arguments.returnAs)
			{
				case "query":
					local.rv = local.findAll.query;

					// execute callbacks unless we're currently running the count or primary key pagination queries (we only want the callback to run when we have the actual data)
					if (local.rv.columnList != "wheelsqueryresult" && !arguments.$limit && !arguments.$offset)
					{
						$callback("afterFind", arguments.callbacks, local.rv);
					}
					break;
				case "struct": case "structs":
					local.rv = $serializeQueryToStructs(query=local.findAll.query, argumentCollection=arguments);
					break;
				case "object": case "objects":
					local.rv = $serializeQueryToObjects(query=local.findAll.query, argumentCollection=arguments);
					break;
				default:
					if (application.wheels.showErrorInformation)
					{
						$throw(type="Wheels.IncorrectArgumentValue", message="Incorrect Arguments", extendedInfo="The `returnAs` may be either `query`, `struct(s)` or `object(s)`");
					}
			}
		}
		return local.rv;
	}

	public any function findByKey(
		required any key,
		string select="",
		string include="",
		any cache="",
		boolean reload,
		any parameterize,
		string returnAs,
		boolean callbacks="true",
		boolean includeSoftDeletes="false"
	) {
		$args(name="findByKey", args=arguments);
		arguments.include = $listClean(arguments.include);
		if (Len(arguments.key))
		{
			$keyLengthCheck(arguments.key);
		}

		// convert primary key column name(s) / value(s) to a WHERE clause that is then used in the findOne call
		arguments.where = $keyWhereString(values=arguments.key);
		StructDelete(arguments, "key");
		local.rv = findOne(argumentCollection=arguments);
		return local.rv;
	}

	public any function findOne(
		string where="",
		string order="",
		string select="",
		string include="",
		any cache="",
		boolean reload,
		any parameterize,
		string returnAs,
		boolean includeSoftDeletes="false"
	) {
		$args(name="findOne", args=arguments);
		arguments.include = $listClean(arguments.include);
		if (!Len(arguments.include) || (StructKeyExists(variables.wheels.class.associations, arguments.include) && variables.wheels.class.associations[arguments.include].type != "hasMany"))
		{
			// no joins will be done or the join will be done to a single record so we can safely get just one record from the database
			// note that the check above can be improved to go through the entire include string and check if all associations are "single" (i.e. hasOne or belongsTo)
			arguments.maxRows = 1;
		}
		else
		{
			// since we're joining with associated tables (and not to just one record) we could potentially get duplicate records for one object and we work around this by using the pagination code which has this functionality built in
			arguments.page = 1;
			arguments.perPage = 1;
			arguments.count = 1;
		}
		local.rv = findAll(argumentCollection=arguments);
		if (IsArray(local.rv))
		{
			if (ArrayLen(local.rv))
			{
				local.rv = local.rv[1];
			}
			else
			{
				local.rv = false;
			}
		}
		return local.rv;
	}

	public any function findFirst(string property="#primaryKey()#", string $sort="ASC") {
		$args(args=arguments, name="findFirst", combine="property/properties");
		arguments.order = "";
		local.iEnd = ListLen(arguments.property);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			local.item = ListGetAt(arguments.property, local.i);
			arguments.order = ListAppend(arguments.order, local.item & " " & arguments.$sort);
		}
		StructDelete(arguments, "property");
		StructDelete(arguments, "$sort");
		local.rv = findOne(argumentCollection=arguments);
		return local.rv;
	}

	public any function findLast(string property) {
		arguments.$sort = "DESC";
		local.rv = findFirst(argumentCollection=arguments);
		return local.rv;
	}

	public string function findAllKeys(boolean quoted="false", string delimiter=",") {
		local.quoted = arguments.quoted;
		StructDelete(arguments, "quoted");
		local.delimiter = arguments.delimiter;
		StructDelete(arguments, "delimiter");
		arguments.select = primaryKey();
		arguments.callbacks = false;
		local.query = findAll(argumentCollection=arguments);
		if (local.quoted)
		{
			local.functionName = "QuotedValueList";
		}
		else
		{
			local.functionName = "ValueList";
		}
		local.rv = Evaluate("#local.functionName#(local.query.#arguments.select#, '#local.delimiter#')");
		return local.rv;
	}

	/*
	* PUBLIC MODEL OBJECT METHODS
	*/
	public void function reload() {
		local.query = findByKey(key=key(), reload=true, returnAs="query");
		local.properties = propertyNames();
		local.iEnd = ListLen(local.properties);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			try
			{
				// coldfusion has a problem with blank boolean values in the query
				local.property = ListGetAt(local.properties, local.i);
				this[local.property] = local.query[local.property][1];
			}
			catch (any e)
			{
				this[local.property] = "";
			}
		}
	}
</cfscript>
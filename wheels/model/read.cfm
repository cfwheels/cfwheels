<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="findAll" returntype="any" access="public" output="false">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="order" type="string" required="false">
	<cfargument name="group" type="string" required="false">
	<cfargument name="select" type="string" required="false" default="">
	<cfargument name="distinct" type="boolean" required="false" default="false">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="maxRows" type="numeric" required="false" default="-1">
	<cfargument name="page" type="numeric" required="false" default="0">
	<cfargument name="perPage" type="numeric" required="false">
	<cfargument name="count" type="numeric" required="false" default="0">
	<cfargument name="handle" type="string" required="false" default="query">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="returnAs" type="string" required="false">
	<cfargument name="returnIncluded" type="boolean" required="false">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfargument name="$limit" type="numeric" required="false" default="0">
	<cfargument name="$offset" type="numeric" required="false" default="0">
	<cfscript>
		var loc = {};
		$args(name="findAll", args=arguments);
		arguments.include = $listClean(arguments.include);

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
				loc.compareList = $listClean(ReplaceNoCase(ReplaceNoCase(arguments.order, " ASC", "", "all"), " DESC", "", "all"));
				loc.iEnd = ListLen(primaryKeys());
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.item = primaryKeys(loc.i);
					if (!ListFindNoCase(loc.compareList, loc.item) && !ListFindNoCase(loc.compareList, tableName() & "." & loc.item))
					{
						arguments.order = ListAppend(arguments.order, loc.item);
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
				loc.distinct = true;
			}
			else
			{
				loc.distinct = false;
			}
			if (arguments.count > 0)
			{
				loc.totalRecords = arguments.count;
			}
			else
			{
				loc.totalRecords = this.count(where=arguments.where, include=arguments.include, reload=arguments.reload, cache=arguments.cache, distinct=loc.distinct, parameterize=arguments.parameterize, includeSoftDeletes=arguments.includeSoftDeletes);
			}
			loc.currentPage = arguments.page;
			if (loc.totalRecords == 0)
			{
				loc.totalPages = 0;
				loc.rv = "";
			}
			else
			{
				loc.totalPages = Ceiling(loc.totalRecords/arguments.perPage);
				loc.limit = arguments.perPage;
				loc.offset = (arguments.perPage * arguments.page) - arguments.perPage;

				// if the full range of records is not requested we correct the limit to get the exact amount instead
				// for example if totalRecords is 57, limit is 10 and offset 50 (i.e. requesting records 51-60) we change the limit to 7
				if ((loc.limit + loc.offset) > loc.totalRecords)
				{
					loc.limit = loc.totalRecords - loc.offset;
				}

				if (loc.limit < 1)
				{
					// if limit is 0 or less it means that a page that has no records was asked for so we return an empty query
					loc.rv = "";
				}
				else
				{
					loc.values = findAll($limit=loc.limit, $offset=loc.offset, select=primaryKeys(), where=arguments.where, order=arguments.order, include=arguments.include, reload=arguments.reload, cache=arguments.cache, distinct=loc.distinct, parameterize=arguments.parameterize, includeSoftDeletes=arguments.includeSoftDeletes);
					if (loc.values.RecordCount)
					{
						loc.paginationWhere = "";
						loc.iEnd = loc.values.recordCount;
						for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
						{
							loc.keyComboValues = [];
							loc.jEnd = ListLen(primaryKeys());
							for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
							{
								loc.property = primaryKeys(loc.j);
								ArrayAppend(loc.keyComboValues, "#tableName()#.#loc.property# = #variables.wheels.class.adapter.$quoteValue(str=loc.values[loc.property][loc.i], type=validationTypeForProperty(loc.property))#");
							}
							loc.paginationWhere = ListAppend(loc.paginationWhere, "(" & ArrayToList(loc.keyComboValues, " AND ") & ")", Chr(7));
 						}
						loc.paginationWhere = Replace(loc.paginationWhere, Chr(7), " OR ", "all");

 						// this can be improved to also check if the where clause checks on a joined table, if not we can use the simple where clause with just the ids
 						if (Len(arguments.where) && Len(arguments.include))
 						{
 							arguments.where = "(#arguments.where#) AND (#loc.paginationWhere#)";
 						}
 						else
						{
							arguments.where = loc.paginationWhere;
						}
					}
				}
			}
			// store pagination info in the request scope so all pagination methods can access it
			setPagination(loc.totalRecords, loc.currentPage, arguments.perPage, arguments.handle);
		}

		if (StructKeyExists(loc, "rv") && !Len(loc.rv))
		{
			if (arguments.returnAs == "query")
			{
				loc.rv = QueryNew("");
			}
			else if (singularize(arguments.returnAs) == arguments.returnAs)
			{
				loc.rv = false;
			}
			else
			{
				loc.rv = ArrayNew(1);
			}
		}
		else if (!StructKeyExists(loc, "rv"))
		{
			// make the where clause generic for use in caching
			loc.originalWhere = arguments.where;
			arguments.where = REReplace(arguments.where, variables.wheels.class.RESQLWhere, "\1?\8" , "all");

			// get info from cache when available, otherwise create the generic select, from, where and order by clause
			loc.queryShellKey = $hashedKey(variables.wheels.class.modelName, arguments);
			loc.sql = $getFromCache(loc.queryShellKey, "sql");
			if (!IsArray(loc.sql))
			{
				loc.sql = [];
				ArrayAppend(loc.sql, $selectClause(select=arguments.select, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes, returnAs=arguments.returnAs));
				ArrayAppend(loc.sql, $fromClause(include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes));
				loc.sql = $addWhereClause(sql=loc.sql, where=loc.originalWhere, include=arguments.include, includeSoftDeletes=arguments.includeSoftDeletes);
				loc.groupBy = $groupByClause(select=arguments.select, group=arguments.group, include=arguments.include, distinct=arguments.distinct, returnAs=arguments.returnAs);
				if (Len(loc.groupBy))
				{
					ArrayAppend(loc.sql, loc.groupBy);
				}
				loc.orderBy = $orderByClause(order=arguments.order, include=arguments.include);
				if (Len(loc.orderBy))
				{
					ArrayAppend(loc.sql, loc.orderBy);
				}
				$addToCache(key=loc.queryShellKey, value=loc.sql, category="sql");
			}

			// add where clause parameters to the generic sql info
			loc.sql = $addWhereClauseParameters(sql=loc.sql, where=loc.originalWhere);

			// return existing query result if it has been run already in current request, otherwise pass off the sql array to the query
			loc.queryKey = $hashedKey(variables.wheels.class.modelName, arguments, loc.originalWhere);
			if (application.wheels.cacheQueriesDuringRequest && !arguments.reload && StructKeyExists(request.wheels, loc.queryKey))
			{
				loc.findAll = request.wheels[loc.queryKey];
			}
			else
			{
				loc.finderArgs = {};
				loc.finderArgs.sql = loc.sql;
				loc.finderArgs.maxRows = arguments.maxRows;
				loc.finderArgs.parameterize = arguments.parameterize;
				loc.finderArgs.limit = arguments.$limit;
				loc.finderArgs.offset = arguments.$offset;
				loc.finderArgs.$primaryKey = primaryKeys();
				if (application.wheels.cacheQueries && (IsNumeric(arguments.cache) || (IsBoolean(arguments.cache) && arguments.cache)))
				{
					loc.finderArgs.cachedWithin = $timeSpanForCache(arguments.cache);
				}
				loc.findAll = variables.wheels.class.adapter.$query(argumentCollection=loc.finderArgs);
				request.wheels[loc.queryKey] = loc.findAll; // <- store in request cache so we never run the exact same query twice in the same request
			}
			request.wheels[$hashedKey(loc.findAll.query)] = variables.wheels.class.modelName; // place an identifer in request scope so we can reference this query when passed in to view functions

			switch (arguments.returnAs)
			{
				case "query":
					loc.rv = loc.findAll.query;

					// execute callbacks unless we're currently running the count or primary key pagination queries (we only want the callback to run when we have the actual data)
					if (loc.rv.columnList != "wheelsqueryresult" && !arguments.$limit && !arguments.$offset)
					{
						$callback("afterFind", arguments.callbacks, loc.rv);
					}
					break;
				case "struct": case "structs":
					loc.rv = $serializeQueryToStructs(query=loc.findAll.query, argumentCollection=arguments);
					break;
				case "object": case "objects":
					loc.rv = $serializeQueryToObjects(query=loc.findAll.query, argumentCollection=arguments);
					break;
				default:
					if (application.wheels.showErrorInformation)
					{
						$throw(type="Wheels.IncorrectArgumentValue", message="Incorrect Arguments", extendedInfo="The `returnAs` may be either `query`, `struct(s)` or `object(s)`");
					}
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="findByKey" returntype="any" access="public" output="false">
	<cfargument name="key" type="any" required="true">
	<cfargument name="select" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="returnAs" type="string" required="false">
	<cfargument name="callbacks" type="boolean" required="false" default="true">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		$args(name="findByKey", args=arguments);
		arguments.include = $listClean(arguments.include);
		if (Len(arguments.key))
		{
			$keyLengthCheck(arguments.key);
		}

		// convert primary key column name(s) / value(s) to a WHERE clause that is then used in the findOne call
		arguments.where = $keyWhereString(values=arguments.key);
		StructDelete(arguments, "key");
		loc.rv = findOne(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="findOne" returntype="any" access="public" output="false">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="order" type="string" required="false" default="">
	<cfargument name="select" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="reload" type="boolean" required="false">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="returnAs" type="string" required="false">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
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
		loc.rv = findAll(argumentCollection=arguments);
		if (IsArray(loc.rv))
		{
			if (ArrayLen(loc.rv))
			{
				loc.rv = loc.rv[1];
			}
			else
			{
				loc.rv = false;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="findFirst" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="false" default="#primaryKey()#">
	<cfargument name="$sort" type="string" required="false" default="ASC">
	<cfscript>
		var loc = {};
		$args(args=arguments, name="findFirst", combine="property/properties");
		arguments.order = "";
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.property, loc.i);
			arguments.order = ListAppend(arguments.order, loc.item & " " & arguments.$sort);
		}
		StructDelete(arguments, "property");
		StructDelete(arguments, "$sort");
		loc.rv = findOne(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="findLast" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="false">
	<cfscript>
		var loc = {};
		arguments.$sort = "DESC";
		loc.rv = findFirst(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="findAllKeys" returntype="string" access="public" output="false">
	<cfargument name="quoted" type="boolean" required="false" default="false">
	<cfargument name="delimiter" type="string" required="false" default=",">
	<cfscript>
		var loc = {};
		loc.quoted = arguments.quoted;
		StructDelete(arguments, "quoted");
		loc.delimiter = arguments.delimiter;
		StructDelete(arguments, "delimiter");
		arguments.select = primaryKey();
		loc.query = findAll(argumentCollection=arguments);
		if (loc.quoted)
		{
			loc.functionName = "QuotedValueList";
		}
		else
		{
			loc.functionName = "ValueList";
		}
		loc.rv = Evaluate("#loc.functionName#(loc.query.#arguments.select#, '#loc.delimiter#')");
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="reload" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.query = findByKey(key=key(), reload=true, returnAs="query");
		loc.properties = propertyNames();
		loc.iEnd = ListLen(loc.properties);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			try
			{
				// coldfusion has a problem with blank boolean values in the query
				loc.property = ListGetAt(loc.properties, loc.i);
				this[loc.property] = loc.query[loc.property][1];
			}
			catch (any e)
			{
				this[loc.property] = "";
			}
		}
	</cfscript>
</cffunction>
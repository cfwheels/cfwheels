<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="findAll" returntype="any" access="public" output="false" hint="Returns records from the database table mapped to this model according to the arguments passed in. (Use the `where` argument to decide which records to get, use the `order` argument to set in what order those records should be returned, and so on). The records will be returned as either a `cfquery` result set or an array of objects (depending on what the `returnAs` argument is set to). Instead of using the `where` argument, you can create cleaner code by making use of a concept called dynamic finders."
	examples=
	'
		<!--- Getting only 5 users and ordering them randomly --->
		<cfset fiveRandomUsers = model("user").findAll(maxRows=5, order="random")>

		<!--- Including an association (which in this case needs to be setup as a `belongsTo` association to `author` on the `article` model first)  --->
		<cfset articles = model("article").findAll(where="published=1", order="createdAt DESC", include="author")>

		<!--- Similar to the above but using the association in the opposite direction (which needs to be setup as a `hasMany` association to `article` on the `author` model) --->
		<cfset bobsArticles = model("author").findAll(where="firstName=''Bob''", include="articles")>

		<!--- Using pagination (getting records 26-50 in this case) and a more complex way to include associations (a song `belongsTo` an album, which in turn `belongsTo` an artist) --->
		<cfset songs = model("song").findAll(include="album(artist)", page=2, perPage=25)>

		<!--- Using a dynamic finder to get all books released a certain year. Same as calling model("book").findOne(where="releaseYear=##params.year##") --->
		<cfset books = model("book").findAllByReleaseYear(params.year)>

		<!--- Getting all books of a certain type from a specific year by using a dynamic finder. Same as calling model("book").findAll(where="releaseYear=##params.year## AND type=''##params.type##''") --->
		<cfset books = model("book").findAllByReleaseYearAndType("##params.year##,##params.type##")>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `comments` method below will call `model("comment").findAll(where="postId=##post.id##")` internally) --->
		<cfset post = model("post").findByKey(params.postId)>
		<cfset comments = post.comments()>
	'
	categories="model-class,read" chapters="reading-records,associations" functions="findByKey,findOne,hasMany">
	<cfargument name="where" type="string" required="false" default="" hint="This argument maps to the `WHERE` clause of the query. The following operators are supported: `=`, `!=`, `<>`, `<`, `<=`, `>`, `>=`, `LIKE`, `NOT LIKE`, `IN`, `NOT IN`, `IS NULL`, `IS NOT NULL`, `AND`, and `OR`. (Note that the key words need to be written in upper case.) You can also use parentheses to group statements. You do not need to specify the table name(s); CFWheels will do that for you.">
	<cfargument name="order" type="string" required="false" hint="Maps to the `ORDER BY` clause of the query. You do not need to specify the table name(s); CFWheels will do that for you.">
	<cfargument name="group" type="string" required="false" hint="Maps to the `GROUP BY` clause of the query. You do not need to specify the table name(s); CFWheels will do that for you.">
	<cfargument name="select" type="string" required="false" default="" hint="Determines how the `SELECT` clause for the query used to return data will look.	You can pass in a list of the properties (which map to columns) that you want returned from your table(s). If you don't set this argument at all, CFWheels will select all properties from your table(s). If you specify a table name (e.g. `users.email`) or alias a column (e.g. `fn AS firstName`) in the list, then the entire list will be passed through unchanged and used in the `SELECT` clause of the query. By default, all column names in tables `JOIN`ed via the `include` argument will be prepended with the singular version of the included table name.">
	<cfargument name="distinct" type="boolean" required="false" default="false" hint="Whether to add the `DISTINCT` keyword to your `SELECT` clause. CFWheels will, when necessary, add this automatically (when using pagination and a `hasMany` association is used in the `include` argument, to name one example).">
	<cfargument name="include" type="string" required="false" default="" hint="Associations that should be included in the query using `INNER` or `LEFT OUTER` joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model, you can specify them in a list (e.g. `department,addresses,emails`). You can build more complex `include` strings by using parentheses when the association is set on an included model, like `album(artist(genre))`, for example. These complex `include` strings only work when `returnAs` is set to `query` though.">
	<cfargument name="maxRows" type="numeric" required="false" default="-1" hint="Maximum number of records to retrieve. Passed on to the `maxRows` `cfquery` attribute. The default, `-1`, means that all records will be retrieved.">
	<cfargument name="page" type="numeric" required="false" default=0 hint="If you want to paginate records, you can do so by specifying a page number here. For example, getting records 11-20 would be page number 2 when `perPage` is kept at the default setting (10 records per page). The default, `0`, means that records won't be paginated and that the `perPage`, `count`, and `handle` arguments will be ignored.">
	<cfargument name="perPage" type="numeric" required="false" hint="When using pagination, you can specify how many records you want to fetch per page here. This argument is only used when the `page` argument has been passed in.">
	<cfargument name="count" type="numeric" required="false" default=0 hint="When using pagination and you know in advance how many records you want to paginate through, you can pass in that value here. Doing so will prevent CFWheels from running a `COUNT` query to get this value. This argument is only used when the `page` argument has been passed in.">
	<cfargument name="handle" type="string" required="false" default="query" hint="Handle to use for the query in pagination. This is useful when you're paginating multiple queries and need to reference them in the @paginationLinks function, for example. This argument is only used when the `page` argument has been passed in.">
	<cfargument name="cache" type="any" required="false" default="" hint="If you want to cache the query, you can do so by specifying the number of minutes you want to cache the query for here. If you set it to `true`, the default cache time will be used (60 minutes).">
	<cfargument name="reload" type="boolean" required="false" hint="Set to `true` to force CFWheels to query the database even though an identical query may have been run in the same request. (The default in CFWheels is to get the second query from the request-level cache.)">
	<cfargument name="parameterize" type="any" required="false" hint="Set to `true` to use `cfqueryparam` on all columns, or pass in a list of property names to use `cfqueryparam` on those only.">
	<cfargument name="returnAs" type="string" required="false" hint="Set this to `objects` to return an array of objects. Set this to `query` to return a query result set.">
	<cfargument name="returnIncluded" type="boolean" required="false" hint="When `returnAs` is set to `objects`, you can set this argument to `false` to prevent returning objects fetched from associations specified in the `include` argument. This is useful when you only need to include associations for use in the `WHERE` clause only and want to avoid the performance hit that comes with object creation.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="You can set this argument to `false` to prevent running the execution of callbacks for a method call.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false" hint="You can set this argument to `true` to include soft-deleted records in the results.">
	<cfargument name="$limit" type="numeric" required="false" default=0>
	<cfargument name="$offset" type="numeric" required="false" default=0>
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

<cffunction name="findByKey" returntype="any" access="public" output="false" hint="Fetches the requested record by primary key and returns it as an object. Returns `false` if no record is found. You can override this behavior to return a `cfquery` result set instead, similar to what's described in the documentation for @findOne."
	examples=
	'
		<!--- Getting the author with the primary key value `99` as an object --->
		<cfset auth = model("author").findByKey(99)>

		<!--- Getting an author based on a form/URL value and then checking if it was found --->
		<cfset auth = model("author").findByKey(params.key)>
		<cfif NOT IsObject(auth)>
			<cfset flashInsert(message="Author ##params.key## was not found")>
			<cfset redirectTo(back=true)>
		</cfif>

		<!--- If you have a `belongsTo` association setup from `comment` to `post`, you can do a scoped call. (The `post` method below will call `model("post").findByKey(comment.postId)` internally) --->
		<cfset comment = model("comment").findByKey(params.commentId)>
		<cfset post = comment.post()>
	'
	categories="model-class,read" chapters="reading-records,associations" functions="belongsTo,findAll,findOne">
	<cfargument name="key" type="any" required="true" hint="Primary key value(s) of the record to fetch. Separate with comma if passing in multiple primary key values. Accepts a string, list, or a numeric value.">
	<cfargument name="select" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="cache" type="any" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="returnAs" type="string" required="false" hint="See documentation for @findOne.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false" hint="See documentation for @findAll.">
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

<cffunction name="findOne" returntype="any" access="public" output="false" hint="Fetches the first record found based on the `WHERE` and `ORDER BY` clauses. With the default settings (i.e. the `returnAs` argument set to `object`), a model object will be returned if the record is found and the boolean value `false` if not. Instead of using the `where` argument, you can create cleaner code by making use of a concept called dynamic finders."
	examples=
	'
		<!--- Getting the most recent order as an object from the database --->
		<cfset order = model("order").findOne(order="datePurchased DESC")>

		<!--- Using a dynamic finder to get the first person with the last name `Smith`. Same as calling `model("user").findOne(where"lastName=''Smith''")` --->
		<cfset person = model("user").findOneByLastName("Smith")>

		<!--- Getting a specific user using a dynamic finder. Same as calling `model("user").findOne(where"email=''someone@somewhere.com'' AND password=''mypass''")` --->
		<cfset user = model("user").findOneByEmailAndPassword("someone@somewhere.com,mypass")>

		<!--- If you have a `hasOne` association setup from `user` to `profile`, you can do a scoped call. (The `profile` method below will call `model("profile").findOne(where="userId=##user.id##")` internally) --->
		<cfset user = model("user").findByKey(params.userId)>
		<cfset profile = user.profile()>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `findOneComment` method below will call `model("comment").findOne(where="postId=##post.id##")` internally) --->
		<cfset post = model("post").findByKey(params.postId)>
		<cfset comment = post.findOneComment(where="text=''I Love Wheels!''")>
	'
	categories="model-class,read" chapters="reading-records,associations" functions="findAll,findByKey,hasMany,hasOne">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="order" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="select" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="cache" type="any" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="returnAs" type="string" required="false" hint="Set this to `query` to return as a single-row query result set. Set this to `object` to return as an object.">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false" hint="See documentation for @findAll.">
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

<cffunction name="findFirst" returntype="any" access="public" output="false" hint="Fetches the first record ordered by primary key value. Use the `property` argument to order by something else.">
	<cfargument name="property" type="string" required="false" default="#primaryKey()#" hint="Name of the property to order by. This argument is also aliased as `properties`.">
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

<cffunction name="findLast" returntype="any" access="public" output="false" hint="Fetches the last record ordered by primary key value.">
	<cfargument name="property" type="string" required="false" hint="See documentation for @findFirst.">
	<cfscript>
		var loc = {};
		arguments.$sort = "DESC";
		loc.rv = findFirst(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<cffunction name="reload" returntype="void" access="public" output="false" hint="Reloads the property values of this object from the database."
	examples=
	'
		<!--- Get an object, call a method on it that could potentially change values, and then reload the values from the database --->
		<cfset employee = model("employee").findByKey(params.key)>
		<cfset employee.someCallThatChangesValuesInTheDatabase()>
		<cfset employee.reload()>
	'
	categories="model-object,miscellaneous" chapters="reading-records" functions="">
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
<!--- PUBLIC MODEL CLASS METHODS --->

<!--- create --->

<cffunction name="create" returntype="any" access="public" output="false" hint="Creates a new object, saves it to the database (if the validation permits it) and returns it. If the validation fails, the unsaved object (with errors added to it) is still returned. Property names and values can be passed in either using named arguments or as a struct to the `properties` argument."
	examples=
	'
		<!--- Create a new author and save it to the database --->
		<cfset newAuthor = model("author").create(params.author)>

		<!--- Same as above using named arguments --->
		<cfset newAuthor = model("author").create(firstName="John", lastName="Doe")>

		<!--- Same as above using both named arguments and a struct --->
		<cfset newAuthor = model("author").create(active=1, properties=params.author)>

		<!--- If you have a `hasOne` or `hasMany` association setup from `customer` to `order` you can do a scoped call (the `createOrder` method below will call `model("order").create(customerId=aCustomer.id, shipping=params.shipping)` internally) --->
		<cfset aCustomer = model("customer").findByKey(params.customerId)>
		<cfset anOrder = aCustomer.createOrder(shipping=params.shipping)>
	'
	categories="model-class,create" chapters="creating-records,associations" functions="hasOne,hasMany,new">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfargument name="defaults" type="boolean" required="false" hint="See documentation for @save.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @save.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		$insertDefaults(name="create", input=arguments);
		loc.parameterize = arguments.parameterize;
		StructDelete(arguments, "parameterize");
		loc.returnValue = new(argumentCollection=arguments);
		loc.returnValue.save(parameterize=loc.parameterize, defaults=arguments.defaults, transaction=arguments.transaction, callbacks=arguments.callbacks);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="new" returntype="any" access="public" output="false" hint="Creates a new object based on supplied properties and returns it. The object is not saved to the database, it only exists in memory. Property names and values can be passed in either using named arguments or as a struct to the `properties` argument."
	examples=
	'
		<!--- Create a new author in memory (not saved to the database) --->
		<cfset newAuthor = model("author").new()>

		<!--- Create a new author based on properties in a struct --->
		<cfset newAuthor = model("author").new(params.authorStruct)>

		<!--- Create a new author by passing in named arguments --->
		<cfset newAuthor = model("author").new(firstName="John", lastName="Doe")>

		<!--- If you have a `hasOne` or `hasMany` association setup from `customer` to `order` you can do a scoped call (the `newOrder` method below will call `model("order").new(customerId=aCustomer.id)` internally) --->
		<cfset aCustomer = model("customer").findByKey(params.customerId)>
		<cfset anOrder = aCustomer.newOrder(shipping=params.shipping)>
	'
	categories="model-class,create" chapters="creating-records,associations" functions="create,hasMany,hasOne">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="The properties you want to set on the object (can also be passed in as named arguments).">
	<cfargument name="defaults" type="boolean" required="false" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		$insertDefaults(name="new", input=arguments);
		arguments.properties = $setProperties(argumentCollection=arguments, filterList="properties,defaults,transaction,callbacks", setOnModel=false);
		loc.returnValue = $createInstance(properties=arguments.properties, persisted=false, callbacks=arguments.callbacks);
		if (arguments.defaults)
			loc.returnValue.$setDefaultValues();
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!--- read --->

<cffunction name="findAll" returntype="any" access="public" output="false" hint="Returns records from the database table mapped to this model according to the arguments passed in (use the `where` argument to decide which records to get, use the `order` argument to set in what order those records should be returned and so on). The records will be returned as either a `cfquery` result set or an array of objects (depending on what the `returnAs` argument is set to). Instead of using the `where` argument you can create cleaner code by making use of a concept called dynamic finders."
	examples=
	'
		<!--- Getting only 5 users and ordering them randomly --->
		<cfset fiveRandomUsers = model("user").findAll(maxRows=5, order="random")>

		<!--- Including an association (which in this case has to be setup as a `belongsTo` association to `author` on the `article` model first)  --->
		<cfset articles = model("article").findAll(where="published=1", order="createdAt DESC", include="author")>

		<!--- Similar to the above but using the association in the opposite direction (has to be setup as a `hasMany` association to `article` on the `author` model) --->
		<cfset bobsArticles = model("author").findAll(where="firstName=''Bob''", include="articles")>

		<!--- Using pagination (getting records 26-50 in this case) and a more complex way to include associations (a song `belongsTo` an album which in turn `belongsTo` an artist) --->
		<cfset songs = model("song").findAll(include="album(artist)", page=2, perPage=25)>

		<!--- Using a dynamic finder to get all books released a certain year. Same as calling model("book").findOne(where="releaseYear=##params.year##") --->
		<cfset books = model("book").findOneByReleaseYear(params.year)>

		<!--- Getting all books of a certain type from a specific year by using a dynamic finder. Same as calling model("book").findAll(where="releaseYear=##params.year## AND type=''##params.type##''") --->
		<cfset books = model("book").findAllByReleaseYearAndType("##params.year##,##params.type##")>

		<!--- If you have a `hasMany` association setup from `post` to `comment` you can do a scoped call (the `comments` method below will call `model("comment").findAll(where="postId=##post.id##")` internally) --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset comments = aPost.comments()>
	'
	categories="model-class,read" chapters="reading-records,associations" functions="findByKey,findOne,hasMany">
	<cfargument name="where" type="string" required="false" default="" hint="This argument maps to the `WHERE` clause of the query. The following operators are supported: `=`, `<>`, `<`, `<=`, `>`, `>=`, `LIKE`, `AND`, and `OR` (note that the key words have to be written in upper case). You can also use parentheses to group statements. You do not have to specify the table name(s), Wheels will do that for you.">
	<cfargument name="order" type="string" required="false" hint="This argument maps to the `ORDER BY` clause of the query. You do not have to specify the table name(s), Wheels will do that for you.">
	<cfargument name="group" type="string" required="false" hint="This argument maps to the `GROUP BY` clause of the query. You do not have to specify the table name(s), Wheels will do that for you.">
	<cfargument name="select" type="string" required="false" default="" hint="This argument determines how the `SELECT` clause for the query used to return data will look.	You can pass in a list of the properties (which maps to columns) that you want returned from your table(s). If you don't set this argument at all, Wheels will select all properties from your table(s). If you specify a table name (e.g. `users.email`) or alias a column (e.g. `fn AS firstName`) in the list then the entire list will be passed through unchanged and used in the `SELECT` clause of the query. If not, Wheels will prepend the table name and resolve any naming collisions (which could happen when using the `include` argument) automatically for you. The naming collisions are resolved by prepending the model name to the property name so `users.firstName` could become `userFirstName` for example.">
	<cfargument name="distinct" type="boolean" required="false" default="false" hint="Boolean value to decide whether to add the `DISTINCT` keyword to your `SELECT` clause. Wheels will, when necessary, add this automatically (when using pagination and a `hasMany` association is used in the `include` argument to name one example).">
	<cfargument name="include" type="string" required="false" default="" hint="Associations that should be included in the query using `INNER` or `LEFT OUTER` joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model you can specify them in a list, e.g. `department,addresses,emails`. You can build more complex `include` strings by using parentheses when the association is set on an included model, like `album(artist(genre))` for example.">
	<cfargument name="maxRows" type="numeric" required="false" default="-1" hint="Maximum number of records to retrieve. Passed on to the `maxRows` `cfquery` attribute. The default `-1` means that all records will be retrieved.">
	<cfargument name="page" type="numeric" required="false" default=0 hint="If you want to paginate records (i.e. get records 11-20 for example) you can do so by specifying a page number here. For example, getting records 11-20 would be page number 2 when `perPage` is kept at the default setting (10 records per page). The default, `0`, means that records won't be paginated and that the `perPage`, `count` and `handle` arguments will be ignored.">
	<cfargument name="perPage" type="numeric" required="false" hint="When using pagination you can specify how many records you want to fetch per page here. This argument is only used when the `page` argument has been passed in.">
	<cfargument name="count" type="numeric" required="false" default=0 hint="When using pagination and you know in advance how many records you want to paginate through you can pass in that value here. Doing so will prevent Wheels from running a `COUNT` query to get this value. This argument is only used when the `page` argument has been passed in.">
	<cfargument name="handle" type="string" required="false" default="query" hint="Handle to use for the query in pagination. This is useful when you're paginating multiple queries and need to reference them in the @paginationLinks function for example. This argument is only used when the `page` argument has been passed in.">
	<cfargument name="cache" type="any" required="false" default="" hint="Accepts a boolean or numeric value. If you want to cache the query you can do so by specifying the number of minutes you want to cache the query for here. If you set it to `true` the default cache time will be used (60 minutes).">
	<cfargument name="reload" type="boolean" required="false" hint="Set to `true` to force Wheels to query the database even though an identical query has been run in the same request (the default in Wheels is to get the second query from the cache).">
	<cfargument name="parameterize" type="any" required="false" hint="Accepts a boolean value or a string. Set to `true` to use `cfqueryparam` on all columns or pass in a list of property names to use `cfqueryparam` on those only.">
	<cfargument name="returnAs" type="string" required="false" hint="Set this to `objects` to return an array of objects instead of a query result set which is the default return type.">
	<cfargument name="returnIncluded" type="boolean" required="false" hint="When `returnAs` is set to `objects` you can set this argument to `false` to prevent returning objects fetched from associations specified in the `include` argument. This is useful when you only need to include associations for use in the `WHERE` clause only and want to avoid the performance hit that comes with object creation.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="You can set this argument to `false` to prevent running the execution of callbacks for this method.">
	<cfargument name="$limit" type="numeric" required="false" default=0>
	<cfargument name="$offset" type="numeric" required="false" default=0>
	<cfargument name="$softDeleteCheck" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$insertDefaults(name="findAll", input=arguments);
		// we only allow direct associations to be loaded when returning objects
		if (application.wheels.showErrorInformation && Len(arguments.returnAs) && arguments.returnAs != "query" && Find("(", arguments.include) && arguments.returnIncluded)
			$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="You may only include direct associations to this object when returning an array of objects.");

		// count records and get primary keys for pagination
		if (arguments.page)
		{
			if (Len(arguments.order))
			{
				// insert primary keys to order clause unless they are already there, this guarantees that the ordering is unique which is required to make pagination work properly
				loc.compareList = $listClean(ReplaceNoCase(ReplaceNoCase(arguments.order, " ASC", "", "all"), " DESC", "", "all"));
				loc.iEnd = ListLen(variables.wheels.class.keys);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.iItem = ListGetAt(variables.wheels.class.keys, loc.i);
					if (!ListFindNoCase(loc.compareList, loc.iItem) && !ListFindNoCase(loc.compareList, tableName() & "." & loc.iItem))
						arguments.order = ListAppend(arguments.order, loc.iItem);
				}
			}
			else
			{
				// we can't paginate without any order so we default to ascending ordering by the primary key column(s)
				arguments.order = primaryKey();
			}
			if (Len(arguments.include))
				loc.distinct = true;
			else
				loc.distinct = false;
			if (arguments.count gt 0)
				loc.totalRecords = arguments.count;
			else
				loc.totalRecords = this.count(where=arguments.where, include=arguments.include, reload=arguments.reload, cache=arguments.cache, distinct=loc.distinct, parameterize=arguments.parameterize);
			loc.currentPage = arguments.page;
			if (loc.totalRecords == 0)
			{
				loc.totalPages = 0;
				loc.returnValue = "";
			}
			else
			{
				loc.totalPages = Ceiling(loc.totalRecords/arguments.perPage);
				loc.limit = arguments.perPage;
				loc.offset = (arguments.perPage * arguments.page) - arguments.perPage;

				// if the full range of records is not requested we correct the limit to get the exact amount instead
				// for example if totalRecords is 57, limit is 10 and offset 50 (i.e. requesting records 51-60) we change the limit to 7
				if ((loc.limit + loc.offset) gt loc.totalRecords)
					loc.limit = loc.totalRecords - loc.offset;

				if (loc.limit < 1)
				{
					// if limit is 0 or less it means that a page that has no records was asked for so we return an empty query
					loc.returnValue = "";
				}
				else
				{
					loc.values = findAll($limit=loc.limit, $offset=loc.offset, select=variables.wheels.class.keys, where=arguments.where, order=arguments.order, include=arguments.include, reload=arguments.reload, cache=arguments.cache, distinct=loc.distinct, parameterize=arguments.parameterize);
					if (loc.values.RecordCount) {
						loc.paginationWhere = "";
						loc.iEnd = ListLen(variables.wheels.class.keys);
						for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
						{
							loc.property = ListGetAt(variables.wheels.class.keys, loc.i);
							loc.list = Evaluate("QuotedValueList(loc.values.#loc.property#)");
							loc.paginationWhere = ListAppend(loc.paginationWhere, "#variables.wheels.class.tableName#.#variables.wheels.class.properties[loc.property].column# IN (#loc.list#)", Chr(7));
						}
						loc.paginationWhere = Replace(loc.paginationWhere, Chr(7), " AND ", "all");
						if (Len(arguments.where) && Len(arguments.include)) // this can be improved to also check if the where clause checks on a joined table, if not we can use the simple where clause with just the ids
							arguments.where = "(" & arguments.where & ")" & " AND " & loc.paginationWhere;
						else
							arguments.where = loc.paginationWhere;
						arguments.$softDeleteCheck = false;
					}
				}
			}
			// store pagination info in the request scope so all pagination methods can access it
			request.wheels[arguments.handle] = {};
			request.wheels[arguments.handle].currentPage = loc.currentPage;
			request.wheels[arguments.handle].totalPages = loc.totalPages;
			request.wheels[arguments.handle].totalRecords = loc.totalRecords;
		}

		if (StructKeyExists(loc, "returnValue") && !Len(loc.returnValue))
		{
			if (arguments.returnAs == "query")
				loc.returnValue = QueryNew("");
			else if (arguments.returnAs == "object")
				loc.returnValue = false;
			else if (arguments.returnAs == "objects")
				loc.returnValue = ArrayNew(1);
		}
		else if (!StructKeyExists(loc, "returnValue"))
		{
			// make the where clause generic for use in caching
			loc.originalWhere = arguments.where;
			arguments.where = REReplace(arguments.where, variables.wheels.class.RESQLWhere, "\1?\8" , "all");

			// get info from cache when available, otherwise create the generic select, from, where and order by clause
			loc.queryShellKey = variables.wheels.class.modelName & $hashStruct(arguments);
			loc.sql = $getFromCache(loc.queryShellKey, "sql");
			if (!IsArray(loc.sql))
			{
				loc.sql = [];
				loc.sql = $addSelectClause(sql=loc.sql, select=arguments.select, include=arguments.include);
				ArrayAppend(loc.sql, $fromClause(include=arguments.include));
				loc.sql = $addWhereClause(sql=loc.sql, where=loc.originalWhere, include=arguments.include, $softDeleteCheck=arguments.$softDeleteCheck);
				loc.sql = $addGroupByClause(sql=loc.sql, select=arguments.select, group=arguments.group, include=arguments.include, distinct=arguments.distinct);
				loc.sql = $addOrderByClause(sql=loc.sql, order=arguments.order, include=arguments.include);
				$addToCache(key=loc.queryShellKey, value=loc.sql, category="sql");
			}

			// add where clause parameters to the generic sql info
			loc.sql = $addWhereClauseParameters(sql=loc.sql, where=loc.originalWhere);

			// return existing query result if it has been run already in current request, otherwise pass off the sql array to the query
			loc.queryKey = "wheels" & variables.wheels.class.modelName & $hashStruct(arguments) & loc.originalWhere;
			if (!arguments.reload && StructKeyExists(request, loc.queryKey))
			{
				loc.findAll = request[loc.queryKey];
			}
			else
			{
				loc.finderArgs = {};
				loc.finderArgs.sql = loc.sql;
				loc.finderArgs.maxRows = arguments.maxRows;
				loc.finderArgs.parameterize = arguments.parameterize;
				loc.finderArgs.limit = arguments.$limit;
				loc.finderArgs.offset = arguments.$offset;
				if (application.wheels.cacheQueries && Len(arguments.cache))
				{
					if (IsBoolean(arguments.cache) && arguments.cache)
						loc.finderArgs.cachedWithin = CreateTimeSpan(0,0,application.wheels.defaultCacheTime,0);
					else if (IsNumeric(arguments.cache))
						loc.finderArgs.cachedWithin = CreateTimeSpan(0,0,arguments.cache,0);
				}
				loc.findAll = variables.wheels.class.adapter.$query(argumentCollection=loc.finderArgs);
				request[loc.queryKey] = loc.findAll; // <- store in request cache so we never run the exact same query twice in the same request
			}
			request.wheels[Hash(SerializeJSON(loc.findAll.query))] = variables.wheels.class.modelName; // place an identifer in request scope so we can reference this query when passed in to view functions
			if (arguments.returnAs == "query")
			{
				loc.returnValue = loc.findAll.query;
				// execute callbacks unless we're currently running the count or primary key pagination queries (we only want the callback to run when we have the actual data)
				if (loc.returnValue.columnList != "wheelsqueryresult" && !arguments.$limit && !arguments.$offset)
					$callback("afterFind", arguments.callbacks, loc.returnValue);
			}
			else if (Len(arguments.returnAs))
			{
				loc.returnValue = [];
				loc.doneObjects = "";
				for (loc.i=1; loc.i <= loc.findAll.query.recordCount; loc.i++)
				{
					loc.object = $createInstance(properties=loc.findAll.query, persisted=true, row=loc.i, callbacks=arguments.callbacks);
					if (!ListFind(loc.doneObjects, loc.object.key(), Chr(7)))
					{
						if (Len(arguments.include) && arguments.returnIncluded)
						{
							loc.xEnd = ListLen(arguments.include);
							for (loc.x = 1; loc.x lte loc.xEnd; loc.x++) {
								loc.include = ListGetAt(arguments.include, loc.x);
								if (variables.wheels.class.associations[loc.include].type == "hasMany")
								{
									loc.object[loc.include] = [];
									loc.hasManyDoneObjects = "";
									for (loc.j=1; loc.j <= loc.findAll.query.recordCount; loc.j++)
									{
										loc.hasManyObject = model(variables.wheels.class.associations[loc.include].modelName).$createInstance(properties=loc.findAll.query, persisted=true, row=loc.j, base=false, callbacks=arguments.callbacks);
										if (!ListFind(loc.hasManyDoneObjects, loc.hasManyObject.key(), Chr(7)))
										{
											// create object instance from values in current query row if it belongs to the current object
											loc.primaryKeyColumnValues = "";
											loc.kEnd = ListLen(variables.wheels.class.keys);
											for (loc.k=1; loc.k <= loc.kEnd; loc.k++)
											{
												loc.primaryKeyColumnValues = ListAppend(loc.primaryKeyColumnValues, loc.findAll.query[ListGetAt(variables.wheels.class.keys, loc.k)][loc.j]);
											}
											if (Len(loc.hasManyObject.key()) && loc.object.key() == loc.primaryKeyColumnValues)
												ArrayAppend(loc.object[loc.include], loc.hasManyObject);

											loc.hasManyDoneObjects = ListAppend(loc.hasManyDoneObjects, loc.hasManyObject.key(), Chr(7));
										}
									}

									if (ArrayIsEmpty(loc.object[loc.include]))
										StructDelete(loc.object, loc.include, false);
								}
								else
								{
									loc.object[loc.include] = model(variables.wheels.class.associations[loc.include].modelName).$createInstance(properties=loc.findAll.query, persisted=true, row=loc.i, base=false, callbacks=arguments.callbacks);
								}
							}
						}
						ArrayAppend(loc.returnValue, loc.object);
						loc.doneObjects = ListAppend(loc.doneObjects, loc.object.key(), Chr(7));
					}
				}
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="findByKey" returntype="any" access="public" output="false" hint="Fetches the requested record and returns it as an object. Returns `false` if no record is found. You can override this behavior to return a `cfquery` result set instead, similar to what's described in the documentation for @findOne."
	examples=
	'
		<!--- Getting the author with the primary key vale 99 as an object --->
		<cfset auth = model("author").findByKey(99)>

		<!--- Getting an author based on a form/URL value and then checking if it was found --->
		<cfset auth = model("author").findByKey(params.key)>
		<cfif NOT IsObject(auth)>
			<cfset flashInsert(message="Author ##params.key## was not found")>
			<cfset redirectTo(back=true)>
		</cfif>

		<!--- If you have a `belongsTo` association setup from `comment` to `post` you can do a scoped call (the `post` method below will call `model("post").findByKey(comment.postId)` internally) --->
		<cfset aComment = model("comment").findByKey(params.commentId)>
		<cfset aPost = aComment.post()>
	'
	categories="model-class,read" chapters="reading-records,associations" functions="belongsTo,findAll,findOne">
	<cfargument name="key" type="any" required="true" hint="Primary key value(s) of the record to fetch. Separate with comma if passing in multiple primary key values. Accepts a string, list or a numeric value.">
	<cfargument name="select" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="cache" type="any" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="returnAs" type="string" required="false" hint="Can be set to either `object` or `query`. See documentation for @findAll for more info.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="$softDeleteCheck" type="boolean" required="false" default="true">
	<cfscript>
		var returnValue = "";
		$insertDefaults(name="findByKey", input=arguments);
		// convert primary key column name(s) / value(s) to a WHERE clause that is then used in the findOne call
		arguments.where = $keyWhereString(values=arguments.key);
		StructDelete(arguments, "key");
		returnValue = findOne(argumentCollection=arguments);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="findOne" returntype="any" access="public" output="false" hint="Fetches the first record found based on the `WHERE` and `ORDER BY` clauses. With the default settings (i.e. the `returnAs` argument set to `object`) a model object will be returned if the record is found and the boolean value `false` if not. Instead of using the `where` argument you can create cleaner code by making use of a concept called dynamic finders."
	examples=
	'
		<!--- Getting the most recent order as an object from the database --->
		<cfset anOrder = model("order").findOne(order="datePurchased DESC")>

		<!--- Using a dynamic finder to get the first person with the last name `Smith`. Same as calling model("user").findOne(where"lastName=''Smith''") --->
		<cfset person = model("user").findOneByLastName("Smith")>

		<!--- Getting a specific user using a dynamic finder. Same as calling model("user").findOne(where"email=''someone@somewhere.com'' AND password=''mypass''") --->
		<cfset user = model("user").findOneByEmailAndPassword("someone@somewhere.com,mypass")>

		<!--- If you have a `hasOne` association setup from `user` to `profile` you can do a scoped call (the `profile` method below will call `model("profile").findOne(where="userId=##user.id##")` internally) --->
		<cfset aUser = model("user").findByKey(params.userId)>
		<cfset aProfile = aUser.profile()>

		<!--- If you have a `hasMany` association setup from `post` to `comment` you can do a scoped call (the `findOneComment` method below will call `model("comment").findOne(where="postId=##post.id##")` internally) --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset aComment = aPost.findOneComment(where="text=''I Love Wheels!''")>
	'
	categories="model-class,read" chapters="reading-records,associations" functions="findAll,findByKey,hasMany,hasOne">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="order" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="select" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="cache" type="any" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="returnAs" type="string" required="false" hint="Can be set to either `object` or `query`. See documentation for @findAll for more info.">
	<cfargument name="$softDeleteCheck" type="boolean" required="false" default="true">
	<cfscript>
		var returnValue = "";
		$insertDefaults(name="findOne", input=arguments);
		returnValue = findAll(argumentCollection=arguments);
		if (IsArray(returnValue))
		{
			if (ArrayLen(returnValue))
				returnValue = returnValue[1];
			else
				returnValue = false;
		}
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<!--- update --->

<cffunction name="updateAll" returntype="numeric" access="public" output="false" hint="Updates all properties for the records that match the where argument. Property names and values can be passed in either using named arguments or as a struct to the `properties` argument. By default objects will not be instantiated and therefore callbacks and validations are not invoked. You can change this behavior by passing in `instantiate=true`. This method returns the number of records that were updated."
	examples=
	'
		<!--- Update the `published` and `publishedAt` properties for all records that have `published=0` --->
		<cfset recordsUpdated = model("post").updateAll(published=1, publishedAt=Now(), where="published=0")>

		<!--- If you have a `hasMany` association setup from `post` to `comment` you can do a scoped call (the `removeAllComments` method below will call `model("comment").updateAll(postid="", where="postId=##post.id##")` internally) --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset removedSuccessfully = aPost.removeAllComments()>
	'
	categories="model-class,update" chapters="updating-records,associations" functions="hasMany,update,updateByKey,updateOne">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="instantiate" type="boolean" required="false" hint="Whether or not to instantiate the object(s) first. When objects are not instantiated any callbacks and validations set on them will be skipped.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="$softDeleteCheck" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$insertDefaults(name="updateAll", input=arguments);
		arguments.properties = $setProperties(argumentCollection=arguments, filterList="where,include,properties,parameterize,instantiate,transaction,callbacks,$softDeleteCheck", setOnModel=false);
		
		if (arguments.instantiate) // find and instantiate each object and call its update function
		{
			loc.returnValue = 0;
			loc.records = findAll(select=propertyNames(), where=arguments.where, include=arguments.include, parameterize=arguments.parameterize, callbacks=arguments.callbacks, $softDeleteCheck=arguments.$softDeleteCheck);
			for (loc.i=1; loc.i lte loc.records.recordCount; loc.i++)
			{
				loc.object = $createInstance(properties=loc.records, row=loc.i, persisted=true);
				if (loc.object.update(properties=arguments.properties, parameterize=arguments.parameterize, transaction=arguments.transaction, callbacks=arguments.callbacks))
					loc.returnValue = loc.returnValue + 1;
			}
		}
		else
		{
			arguments.sql = [];
			ArrayAppend(arguments.sql, "UPDATE #variables.wheels.class.tableName# SET");
			loc.pos = 0;
			for (loc.key in arguments.properties)
			{
				loc.pos = loc.pos + 1;
				ArrayAppend(arguments.sql, "#variables.wheels.class.properties[loc.key].column# = ");

				loc.param = {value=arguments.properties[loc.key], type=variables.wheels.class.properties[loc.key].type, scale=variables.wheels.class.properties[loc.key].scale, null=arguments.properties[loc.key] == ""};
				ArrayAppend(arguments.sql, loc.param);
				if (StructCount(arguments.properties) gt loc.pos)
					ArrayAppend(arguments.sql, ",");
			}
			arguments.sql = $addWhereClause(sql=arguments.sql, where=arguments.where, include=arguments.include, $softDeleteCheck=arguments.$softDeleteCheck);
			arguments.sql = $addWhereClauseParameters(sql=arguments.sql, where=arguments.where);
			
			loc.returnValue = $runTransaction(method="$updateAll", argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$updateAll" returntype="numeric" access="public" output="false">
	<cfset var update = variables.wheels.class.adapter.$query(sql=arguments.sql, parameterize=arguments.parameterize)>
	<cfreturn update.result.recordCount>
</cffunction>

<cffunction name="updateByKey" returntype="boolean" access="public" output="false" hint="Finds the object with the supplied key and saves it (if validation permits it) with the supplied properties and/or named arguments. Property names and values can be passed in either using named arguments or as a struct to the `properties` argument. Returns `true` if the object was found and updated successfully, `false` otherwise."
	examples=
	'
		<!--- Updates the object with `33` as the primary key value with values passed in through the URL/form --->
		<cfset result = model("post").updateByKey(33, params.post)>

		<!--- Updates the object with `33` using named arguments --->
		<cfset result = model("post").updateByKey(key=33, title="New version of Wheels just released", published=1)>
	'
	categories="model-class,update" chapters="updating-records,associations" functions="hasOne,hasMany,update,updateAll,updateOne">
	<cfargument name="key" type="any" required="true" hint="See documentation for @findByKey.">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var returnValue = "";
		arguments.where = $keyWhereString(values=arguments.key);
		StructDelete(arguments, "key");
		returnValue = updateOne(argumentCollection=arguments);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="updateOne" returntype="boolean" access="public" output="false" hint="Gets an object based on the arguments used and updates it with the supplied properties. Returns `true` if an object was found and updated successfully, `false` otherwise."
	examples=
	'
		<!--- Sets the `new` property to `1` on the most recently released product --->
		<cfset result = model("product").updateOne(order="releaseDate DESC", new=1)>

		<!--- If you have a `hasOne` association setup from `user` to `profile` you can do a scoped call (the `removeProfile` method below will call `model("profile").updateOne(where="userId=##aUser.id##", userId="")` internally) --->
		<cfset aUser = model("user").findByKey(params.userId)>
		<cfset aUser.removeProfile()>
	'
	categories="model-class,update" chapters="updating-records,associations" functions="hasOne,update,updateAll,updateByKey">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="order" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		loc.object = findOne(where=arguments.where, order=arguments.order);
		StructDelete(arguments, "where");
		StructDelete(arguments, "order");
		if (IsObject(loc.object))
			loc.returnValue = loc.object.update(argumentCollection=arguments);
		else
			loc.returnValue = false;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!--- delete --->

<cffunction name="deleteAll" returntype="numeric" access="public" output="false" hint="Deletes all records that match the where argument. By default objects will not be instantiated and therefore callbacks and validations are not invoked. You can change this behavior by passing in `instantiate=true`. Returns the number of records that were deleted."
	examples=
	'
		<!--- Delete all inactive users without instantiating them (will skip validation and callbacks) --->
		<cfset recordsDeleted = model("user").deleteAll(where="inactive=1", instantiate=false)>

		<!--- If you have a `hasMany` association setup from `post` to `comment` you can do a scoped call (the `deleteAllComments` method below will call `model("comment").deleteAll(where="postId=##post.id##")` internally) --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset howManyDeleted = aPost.deleteAllComments()>
	'
	categories="model-class,delete" chapters="deleting-records,associations" functions="delete,deleteByKey,deleteOne,hasMany">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="instantiate" type="boolean" required="false" hint="See documentation for @updateAll.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfargument name="$softDeleteCheck" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		$insertDefaults(name="deleteAll", input=arguments);
		
		if (arguments.instantiate)
		{
			loc.records = findAll(select=propertyNames(), where=arguments.where, include=arguments.include, parameterize=arguments.parameterize, $softDeleteCheck=arguments.$softDeleteCheck);
			loc.returnValue = 0;
			for (loc.i=1; loc.i lte loc.records.recordCount; loc.i++)
			{
				loc.object = $createInstance(properties=loc.records, row=loc.i, persisted=true);
				if (loc.object.delete(parameterize=arguments.parameterize, transaction=arguments.transaction, callbacks=arguments.callbacks))
					loc.returnValue++;
			}
		}
		else
		{
			arguments.sql = [];
			arguments.sql = $addDeleteClause(sql=arguments.sql);
			arguments.sql = $addWhereClause(sql=arguments.sql, where=arguments.where, include=arguments.include, $softDeleteCheck=arguments.$softDeleteCheck);
			arguments.sql = $addWhereClauseParameters(sql=arguments.sql, where=arguments.where);
			
			loc.returnValue = $runTransaction(method="$deleteAll", argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$deleteAll" returntype="numeric" access="public" output="false">
	<cfset var delete = variables.wheels.class.adapter.$query(sql=arguments.sql, parameterize=arguments.parameterize)>
	<cfreturn delete.result.recordCount>
</cffunction>

<cffunction name="deleteByKey" returntype="boolean" access="public" output="false" hint="Finds the record with the supplied key and deletes it. Returns `true` on successful deletion of the row, `false` otherwise."
	examples=
	'
		<!--- Delete the user with the primary key value of `1` --->
		<cfset result = model("user").deleteByKey(1)>
	'
	categories="model-class,delete" chapters="deleting-records" functions="delete,deleteAll,deleteOne">
	<cfargument name="key" type="any" required="true" hint="See documentation for @findByKey.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		loc.where = $keyWhereString(values=arguments.key);
		loc.returnValue = deleteOne(where=loc.where, transaction=arguments.transaction, callbacks=arguments.callbacks);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="deleteOne" returntype="boolean" access="public" output="false" hint="Gets an object based on conditions and deletes it."
	examples=
	'
		<!--- Delete the user that signed up last --->
		<cfset result = model("user").deleteOne(order="signupDate DESC")>

		<!--- If you have a `hasOne` association setup from `user` to `profile` you can do a scoped call (the `deleteProfile` method below will call `model("profile").deleteOne(where="userId=##aUser.id##")` internally) --->
		<cfset aUser = model("user").findByKey(params.userId)>
		<cfset aUser.deleteProfile()>
	'
	categories="model-class,delete" chapters="deleting-records,associations" functions="delete,deleteAll,deleteOne,hasOne">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="order" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		loc.object = findOne(where=arguments.where, order=arguments.order);
		if (IsObject(loc.object))
			loc.returnValue = loc.object.delete(transaction=arguments.transaction, callbacks=arguments.callbacks);
		else
			loc.returnValue = false;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!--- other --->

<cffunction name="exists" returntype="boolean" access="public" output="false" hint="Checks if a record exists in the table. You can pass in either a primary key value to the `key` argument or a string to the `where` argument."
	examples=
	'
		<!--- Checking if Joe exists in the database --->
		<cfset result = model("user").exists(where="firstName=''Joe''")>

		<!--- Checking if a specific user exists based on a primary key valued passed in through the URL/form in an if statement --->
		<cfif model("user").exists(keyparams.key)>
			<!--- Do something... --->
		</cfif>

		<!--- If you have a `belongsTo` association setup from `comment` to `post` you can do a scoped call (the `hasPost` method below will call `model("post").exists(comment.postId)` internally) --->
		<cfset aComment = model("comment").findByKey(params.commentId)>
		<cfset commentHasAPost = aComment.hasPost()>

		<!--- If you have a `hasOne` association setup from `user` to `profile` you can do a scoped call (the `hasProfile` method below will call `model("profile").exists(where="userId=##user.id##")` internally) --->
		<cfset aUser = model("user").findByKey(params.userId)>
		<cfset userHasProfile = aUser.hasProfile()>

		<!--- If you have a `hasMany` association setup from `post` to `comment` you can do a scoped call (the `hasComments` method below will call `model("comment").exists(where="postid=##post.id##")` internally) --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset postHasComments = aPost.hasComments()>
	'
	categories="model-class,miscellaneous" chapters="reading-records,associations" functions="belongsTo,hasMany,hasOne">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for @findByKey.">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @findAll.">
	<cfargument name="reload" type="boolean" required="false" hint="See documentation for @findAll.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfscript>
		var loc = {};
		$insertDefaults(name="exists", input=arguments);
		if (application.wheels.showErrorInformation)
			if (Len(arguments.key) && Len(arguments.where))
				$throw(type="Wheels.IncorrectArguments", message="You cannot pass in both `key` and `where`.");
		if (Len(arguments.where))
			loc.returnValue = findOne(where=arguments.where, reload=arguments.reload, returnAs="query").recordCount gte 1;
		else if (Len(arguments.key))
			loc.returnValue = findByKey(key=arguments.key, reload=arguments.reload, returnAs="query").recordCount == 1;
		else
			loc.returnValue = false;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!--- PUBLIC MODEL OBJECT METHODS --->

<!--- crud --->

<cffunction name="delete" returntype="boolean" access="public" output="false" hint="Deletes the object, which means the row is deleted from the database (unless prevented by a `beforeDelete` callback). Returns `true` on successful deletion of the row, `false` otherwise."
	examples=
	'
		<!--- Get a post object and then delete it from the database --->
		<cfset aPost = model("post").findByKey(33)>
		<cfset aPost.delete()>

		<!--- If you have a `hasMany` association setup from `post` to `comment` you can do a scoped call (the `deleteComment` method below will call `aComment.delete()` internally) --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset aComment = model("comment").findByKey(params.commentId)>
		<cfset aPost.deleteComment(aComment)>
	'
	categories="model-object,crud" chapters="deleting-records,associations" functions="deleteAll,deleteByKey,deleteOne,hasMany">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		$insertDefaults(name="delete", input=arguments);
		
		arguments.sql = [];
		arguments.sql = $addDeleteClause(sql=arguments.sql);
		arguments.sql = $addKeyWhereClause(sql=arguments.sql);
	</cfscript>
	<cfreturn $runTransaction(method="$delete", argumentCollection=arguments)>
</cffunction>

<cffunction name="$delete" returntype="boolean" access="public" output="false">
	<cfscript>
		var loc = {};
		if ($callback("beforeDelete", arguments.callbacks))
		{
			loc.del = variables.wheels.class.adapter.$query(sql=arguments.sql, parameterize=arguments.parameterize);
			if (loc.del.result.recordCount eq 1 and $callback("afterDelete", arguments.callbacks))
				return true;
		}
		return false;
	</cfscript>
</cffunction>

<cffunction name="reload" returntype="void" access="public" output="false" hint="Reloads the property values of this object from the database."
	examples=
	'
		<!--- Get an object, call a method on it that could potentially change values and then reload the values from the database --->
		<cfset anEmployee = model("employee").findByKey(params.key)>
		<cfset anEmployee.someCallThatChangesValuesInTheDatabase()>
		<cfset anEmployee.reload()>
	'
	categories="model-object,miscellaneous" chapters="reading-records" functions="">
	<cfscript>
		var loc = {};
		loc.query = findByKey(key=key(), reload=true, returnAs="query");
		loc.properties = propertyNames();
		loc.iEnd = ListLen(loc.properties);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.property = ListGetAt(loc.properties, loc.i);
			this[loc.property] = loc.query[loc.property][1];
		}
	</cfscript>
</cffunction>

<cffunction name="save" returntype="boolean" access="public" output="false" hint="Saves the object if it passes validation and callbacks. Returns `true` if the object was saved successfully to the database, `false` if not."
	examples=
	'
		<!--- Save the user object to the database (will automatically do an `INSERT` or `UPDATE` statement depending on if the record is new or already exists --->
		<cfset user.save()>

		<!--- Save the user object directly in an if statement without using `cfqueryparam` and take appropriate action based on the result --->
		<cfif user.save(parameterize=false)>
			<cfset flashInsert(notice="The user was saved!")>
			<cfset redirectTo(action="userEdit")>
		<cfelse>
			<cfset flashInsert(alert="Error, please correct!")>
			<cfset renderPage(action="userEdit")
		</cfif>
	'
	categories="model-object,crud" chapters="creating-records" functions="">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="defaults" type="boolean" required="false" hint="Whether or not to set default values for properties.">
	<cfargument name="validate" type="boolean" required="false" default="true" hint="Whether or not to run validations when saving">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="Use `commit` to update the database when the save has completed, `rollback` to run all the database queries but not commit them, or `none` to skip transaction handling altogether.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfset $insertDefaults(name="save", input=arguments)>
	<cfset clearErrors()>
	<cfreturn $runTransaction(method="$save", argumentCollection=arguments)>
</cffunction>

<cffunction name="$save" returntype="boolean" access="public" output="false">
	<cfscript>
		if ($callback("beforeValidation", arguments.callbacks))
		{
			if (isNew())
			{
				if ($callback("beforeValidationOnCreate", arguments.callbacks) && $validate("onSave", arguments.validate) && $validate("onCreate", arguments.validate) && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnCreate", arguments.callbacks) && $callback("beforeSave", arguments.callbacks) && $callback("beforeCreate", arguments.callbacks))
				{
					$create(parameterize=arguments.parameterize);
					if (arguments.defaults)
					{
						$setDefaultValues();
					}
					if ($callback("afterCreate", arguments.callbacks) and $callback("afterSave", arguments.callbacks))
					{
						$updatePersistedProperties();
						return true;
					}
				}
			}
			else
			{
				if ($callback("beforeValidationOnUpdate", arguments.callbacks) && $validate("onSave", arguments.validate) && $validate("onUpdate", arguments.validate) && $callback("afterValidation", arguments.callbacks) && $callback("afterValidationOnUpdate", arguments.callbacks) && $callback("beforeSave", arguments.callbacks) && $callback("beforeUpdate", arguments.callbacks))
				{
					$update(parameterize=arguments.parameterize);
					if ($callback("afterUpdate", arguments.callbacks) and $callback("afterSave", arguments.callbacks))
					{
						$updatePersistedProperties();
						return true;
					}
				}
			}
		}
		return false;
	</cfscript>
</cffunction>

<cffunction name="update" returntype="boolean" access="public" output="false" hint="Updates the object with the supplied properties and saves it to the database. Returns `true` if the object was saved successfully to the database and `false` otherwise."
	examples=
	'
		<!--- Get a post object and then update its title in the database --->
		<cfset post = model("post").findByKey(33)>
		<cfset post.update(title="New version of Wheels just released")>

		<!--- Get a post object and then update its title and other properties as decided by what is pased in from the URL/form --->
		<cfset post = model("post").findByKey(params.key)>
		<cfset post.update(title="New version of Wheels just released", properties=params.post)>

		<!--- If you have a `hasOne` association setup from `author` to `bio` you can do a scoped call (the `setBio` method below will call `aBio.update(authorId=anAuthor.id)` internally) --->
		<cfset anAuthor = model("author").findByKey(params.authorId)>
		<cfset aBio = model("bio").findByKey(params.bioId)>
		<cfset anAuthor.setBio(aBio)>

		<!--- If you have a `hasMany` association setup from `owner` to `car` you can do a scoped call (the `addCar` method below will call `aCar.update(ownerId=anOwner.id)` internally) --->
		<cfset anOwner = model("owner").findByKey(params.ownerId)>
		<cfset aCar = model("car").findByKey(params.carId)>
		<cfset anOwner.addCar(aCar)>

		<!--- If you have a `hasMany` association setup from `post` to `comment` you can do a scoped call (the `removeComment` method below will call `aComment.update(postId="")` internally) --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset aComment = model("comment").findByKey(params.commentId)>
		<cfset aPost.removeComment(aComment)>
	'
	categories="model-object,crud" chapters="updating-records,associations" functions="hasMany,hasOne,updateAll,updateByKey,updateOne">
	<cfargument name="properties" type="struct" required="false" default="#StructNew()#" hint="See documentation for @new.">
	<cfargument name="parameterize" type="any" required="false" hint="See documentation for @findAll.">
	<cfargument name="transaction" type="string" required="false" default="#application.wheels.transactionMode#" hint="See documentation for @save.">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfset $insertDefaults(name="update", input=arguments)>
	<cfset $setProperties(argumentCollection=arguments, filterList="parameterize,properties,transaction,callbacks") />
	<cfreturn save(parameterize=arguments.parameterize, transaction=arguments.transaction)>
</cffunction>

<!--- other --->

<cffunction name="isNew" returntype="boolean" access="public" output="false" hint="Returns `true` if this object hasn't been saved yet (in other words no record exists in the database yet). Returns `false` if a record exists."
	examples=
	'
		<!--- Create a new object and then check if it is new (yes, this example is ridiculous. It makes more sense in the context of callbacks for example) --->
		<cfset anEmployee = model("employee").new()>
		<cfif anEmployee.isNew()>
			<!--- Do something... --->
		</cfif>
	'
	categories="model-object,miscellaneous" chapters="" functions="">
	<cfscript>
		// if no values have ever been saved to the database this object is new
		if (!StructKeyExists(variables, "$persistedProperties"))
		{
			return true;
		}
		return false;
	</cfscript>
</cffunction>

<!--- PRIVATE MODEL CLASS METHODS --->

<!--- sql builders --->

<cffunction name="$addDeleteClause" returntype="array" access="public" output="false">
	<cfargument name="sql" type="array" required="true">
	<cfscript>
		var loc = {};
		if (variables.wheels.class.softDeletion)
		{
			ArrayAppend(arguments.sql, "UPDATE #variables.wheels.class.tableName# SET #variables.wheels.class.softDeleteColumn# = ");
			loc.param = {value=Now(), type="cf_sql_timestamp"};
			ArrayAppend(arguments.sql, loc.param);
		}
		else
		{
			ArrayAppend(arguments.sql, "DELETE FROM #variables.wheels.class.tableName#");
		}
	</cfscript>
	<cfreturn arguments.sql>
</cffunction>

<cffunction name="$fromClause" returntype="string" access="public" output="false">
	<cfargument name="include" type="string" required="false" default="">
	<cfscript>
		var loc = {};

		// start the from statement with the SQL keyword and the table name for the current model
		loc.returnValue = "FROM " & tableName();

		// add join statements if associations have been specified through the include argument
		if (Len(arguments.include))
		{
			// get info for all associations
			loc.associations = $expandedAssociations(include=arguments.include);

			// add join statement for each include separated by space
			loc.iEnd = ArrayLen(loc.associations);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				loc.returnValue = ListAppend(loc.returnValue, loc.associations[loc.i].join, " ");
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$addKeyWhereClause" returntype="array" access="public" output="false">
	<cfargument name="sql" type="array" required="true">
	<cfscript>
		var loc = {};
		ArrayAppend(arguments.sql, " WHERE ");
		loc.iEnd = ListLen(variables.wheels.class.keys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.key = ListGetAt(variables.wheels.class.keys, loc.i);
			ArrayAppend(arguments.sql, "#variables.wheels.class.properties[loc.key].column# = ");
			if (hasChanged(loc.key))
				loc.value = changedFrom(loc.key);
			else
				loc.value = this[loc.key];
			if (Len(loc.value))
				loc.null = false;
			else
				loc.null = true;
			loc.param = {value=loc.value, type=variables.wheels.class.properties[loc.key].type, scale=variables.wheels.class.properties[loc.key].scale, null=loc.null};
			ArrayAppend(arguments.sql, loc.param);
			if (loc.i < loc.iEnd)
				ArrayAppend(arguments.sql, " AND ");
		}
	</cfscript>
	<cfreturn arguments.sql>
</cffunction>

<cffunction name="$addOrderByClause" returntype="array" access="public" output="false">
	<cfargument name="sql" type="array" required="true">
	<cfargument name="order" type="string" required="true">
	<cfargument name="include" type="string" required="true">
	<cfscript>
		var loc = {};
		if (Len(arguments.order))
		{
			if (arguments.order == "random")
			{
				loc.order = variables.wheels.class.adapter.$randomOrder();
			}
			else if (arguments.order Contains "(")
			{
				loc.order = arguments.order;
			}
			else
			{
				// setup an array containing class info for current class and all the ones that should be included
				loc.classes = [];
				if (Len(arguments.include))
					loc.classes = $expandedAssociations(include=arguments.include);
				ArrayPrepend(loc.classes, variables.wheels.class);

				loc.order = "";
				loc.iEnd = ListLen(arguments.order);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.iItem = Trim(ListGetAt(arguments.order, loc.i));
					if (!FindNoCase(" ASC", loc.iItem) && !FindNoCase(" DESC", loc.iItem))
						loc.iItem = loc.iItem & " ASC";
					if (loc.iItem Contains ".")
					{
						loc.order = ListAppend(loc.order, loc.iItem);
					}
					else
					{
						loc.property = ListLast(SpanExcluding(loc.iItem, " "), ".");
						loc.jEnd = ArrayLen(loc.classes);
						for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
						{
							loc.toAdd = "";
							loc.classData = loc.classes[loc.j];
							if (ListFindNoCase(loc.classData.propertyList, loc.property))
								loc.toAdd = loc.classData.tableName & "." & loc.classData.properties[loc.property].column;
							else if (ListFindNoCase(loc.classData.calculatedPropertyList, loc.property))
								loc.toAdd = Replace(loc.classData.calculatedProperties[loc.property].sql, ",", "[[comma]]", "all");
							if (Len(loc.toAdd))
							{
								if (!ListFindNoCase(loc.classData.columnList, loc.property))
									loc.toAdd = loc.toAdd & " AS " & loc.property;
								loc.toAdd = loc.toAdd & " " & UCase(ListLast(loc.iItem, " "));
								if (!ListFindNoCase(loc.order, loc.toAdd))
								{
									loc.order = ListAppend(loc.order, loc.toAdd);
									break;
								}
							}
						}
						if (application.wheels.showErrorInformation && !Len(loc.toAdd))
							$throw(type="Wheels.ColumnNotFound", message="Wheels looked for the column mapped to the `#loc.property#` property but couldn't find it in the database table.", extendedInfo="Verify the `order` argument and/or your property to column mappings done with the `property` method inside the model's `init` method to make sure everything is correct.");
					}
				}
			}
			loc.order = "ORDER BY " & loc.order;
			ArrayAppend(arguments.sql, loc.order);
		}
	</cfscript>
	<cfreturn arguments.sql>
</cffunction>

<cffunction name="$addGroupByClause" returntype="array" access="public" output="false">
	<cfargument name="sql" type="array" required="true">
	<cfargument name="select" type="string" required="true">
	<cfargument name="include" type="string" required="true">
	<cfargument name="group" type="string" required="true">
	<cfargument name="distinct" type="boolean" required="true">
	<cfscript>
		var loc = { group = "" };
		// if we want a distinct statement, we can do it grouping every field in the select
		if (arguments.distinct)
		{
			loc.group = $createSQLFieldList(list=arguments.select, include=arguments.include, renameFields=false, addCalculatedProperties=false);
		}
		else if (Len(arguments.group))
		{
			loc.group = $createSQLFieldList(list=arguments.group, include=arguments.include, renameFields=false, addCalculatedProperties=false);
		}
		if (Len(loc.group))
		{
			loc.group = "GROUP BY " & loc.group;
			ArrayAppend(arguments.sql, loc.group);
		}
	</cfscript>
	<cfreturn arguments.sql>
</cffunction>

<cffunction name="$addSelectClause" returntype="array" access="public" output="false">
	<cfargument name="sql" type="array" required="true">
	<cfargument name="select" type="string" required="true">
	<cfargument name="include" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.select = $createSQLFieldList(list=arguments.select, include=arguments.include);
		loc.select = "SELECT " & loc.select;
		ArrayAppend(arguments.sql, loc.select);
	</cfscript>
	<cfreturn arguments.sql>
</cffunction>

<cffunction name="$createSQLFieldList" returntype="string" access="public" output="false">
	<cfargument name="list" type="string" required="true">
	<cfargument name="include" type="string" required="true">
	<cfargument name="renameFields" type="boolean" required="false" default="true">
	<cfargument name="addCalculatedProperties" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		// setup an array containing class info for current class and all the ones that should be included
		loc.classes = [];
		if (Len(arguments.include))
			loc.classes = $expandedAssociations(include=arguments.include);
		ArrayPrepend(loc.classes, variables.wheels.class);

		// if the develop passes in tablename.*, translate it into the list of fields for the developer
		// this is so we don't get *'s in the group by
		if (Find(".*", arguments.list))
			arguments.list = $expandProperties(list=arguments.list, classes=loc.classes);

		// add properties to select if the developer did not specify any
		if (!Len(arguments.list))
		{
			loc.iEnd = ArrayLen(loc.classes);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.classData = loc.classes[loc.i];
				arguments.list = ListAppend(arguments.list, loc.classData.propertyList);
				if (Len(loc.classData.calculatedPropertyList))
					arguments.list = ListAppend(arguments.list, loc.classData.calculatedPropertyList);
			}
		}

		// go through the properties and map them to the database unless the developer passed in a table name or an alias in which case we assume they know what they're doing and leave the select clause as is
		if (arguments.list Does Not Contain "." AND arguments.list Does Not Contain " AS ")
		{
			loc.list = "";
			loc.addedProperties = "";
			loc.addedPropertiesByModel = {};
			loc.iEnd = ListLen(arguments.list);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = Trim(ListGetAt(arguments.list, loc.i));

				// look for duplicates
				loc.duplicateCount = ListValueCountNoCase(loc.addedProperties, loc.iItem);
				loc.addedProperties = ListAppend(loc.addedProperties, loc.iItem);

				// loop through all classes (current and all included ones)
				loc.jEnd = ArrayLen(loc.classes);
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					loc.toAppend = "";
					loc.classData = loc.classes[loc.j];

					// create a struct for this model unless it already exists
					if (!StructKeyExists(loc.addedPropertiesByModel, loc.classData.modelName))
						loc.addedPropertiesByModel[loc.classData.modelName] = "";

					// if we find the property in this model and it's not already added we go ahead and add it to the select clause
					if ((ListFindNoCase(loc.classData.propertyList, loc.iItem) || ListFindNoCase(loc.classData.calculatedPropertyList, loc.iItem)) && !ListFindNoCase(loc.addedPropertiesByModel[loc.classData.modelName], loc.iItem))
					{
						// if expanded column aliases is enabled then mark all columns from included classes as duplicates in order to prepend them with their class name
						if (application.wheels.useExpandedColumnAliases && loc.j gt 1 && loc.duplicateCount && arguments.renameFields)
							loc.toAppend = loc.toAppend & "[[duplicate]]" & loc.j;
						if (ListFindNoCase(loc.classData.propertyList, loc.iItem))
						{
							loc.toAppend = loc.toAppend & loc.classData.tableName & ".";
							if (ListFindNoCase(loc.classData.columnList, loc.iItem))
							{
								loc.toAppend = loc.toAppend & loc.iItem;
							}
							else
							{
								loc.toAppend = loc.toAppend & loc.classData.properties[loc.iItem].column;
								if (arguments.renameFields)
									loc.toAppend = loc.toAppend & " AS " & loc.iItem;
							}
						}
						else if (ListFindNoCase(loc.classData.calculatedPropertyList, loc.iItem) && arguments.addCalculatedProperties)
						{
							loc.toAppend = loc.toAppend & "(" & Replace(loc.classData.calculatedProperties[loc.iItem].sql, ",", "[[comma]]", "all") & ") AS " & loc.iItem;
						}
						loc.addedPropertiesByModel[loc.classData.modelName] = ListAppend(loc.addedPropertiesByModel[loc.classData.modelName], loc.iItem);
						break;
					}
				}
				if (Len(loc.toAppend))
					loc.list = ListAppend(loc.list, loc.toAppend);
				else if (application.wheels.showErrorInformation && (not arguments.addCalculatedProperties && not ListFindNoCase(loc.classData.calculatedPropertyList, loc.iItem)))
					$throw(type="Wheels.ColumnNotFound", message="Wheels looked for the column mapped to the `#loc.iItem#` property but couldn't find it in the database table.", extendedInfo="Verify the `select` argument and/or your property to column mappings done with the `property` method inside the model's `init` method to make sure everything is correct.");
			}

			// let's replace eventual duplicates in the clause by prepending the class name
			if (Len(arguments.include) && arguments.renameFields)
			{
				loc.newSelect = "";
				loc.addedProperties = "";
				loc.iEnd = ListLen(loc.list);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.iItem = ListGetAt(loc.list, loc.i);

					// get the property part, done by taking everytyhing from the end of the string to a . or a space (which would be found when using " AS ")
					loc.property = Reverse(SpanExcluding(Reverse(loc.iItem), ". "));

					// check if this one has been flagged as a duplicate, we get the number of classes to skip and also remove the flagged info from the item
					loc.duplicateCount = 0;
					loc.matches = REFind("^\[\[duplicate\]\](\d+)(.+)$", loc.iItem, 1, true);
					if (loc.matches.pos[1] > 0)
					{
						loc.duplicateCount = Mid(loc.iItem, loc.matches.pos[2], loc.matches.len[2]);
						loc.iItem = Mid(loc.iItem, loc.matches.pos[3], loc.matches.len[3]);
					}

					if (!loc.duplicateCount)
					{
						// this is not a duplicate so we can just insert it as is
						loc.newItem = loc.iItem;
						loc.newProperty = loc.property;
					}
					else
					{
						// this is a duplicate so we prepend the class name and then insert it unless a property with the resulting name already exist
						loc.classData = loc.classes[loc.duplicateCount];

						// prepend class name to the property
						loc.newProperty = loc.classData.modelName & loc.property;

						if (loc.iItem Contains " AS ")
							loc.newItem = ReplaceNoCase(loc.iItem, " AS " & loc.property, " AS " & loc.newProperty);
						else
							loc.newItem = loc.iItem & " AS " & loc.newProperty;
					}
					if (!ListFindNoCase(loc.addedProperties, loc.newProperty))
					{
						loc.newSelect = ListAppend(loc.newSelect, loc.newItem);
						loc.addedProperties = ListAppend(loc.addedProperties, loc.newProperty);
					}
				}
				loc.list = loc.newSelect;
			}
		}
		else
		{
			loc.list = arguments.list;
			if (!arguments.renameFields && Find(" AS ", loc.list))
				loc.list = REReplace(loc.list, variables.wheels.class.RESQLAs, "", "all");
		}
	</cfscript>
	<cfreturn loc.list />
</cffunction>

<cffunction name="$addWhereClause" returntype="array" access="public" output="false">
	<cfargument name="sql" type="array" required="true">
	<cfargument name="where" type="string" required="true">
	<cfargument name="include" type="string" required="true">
	<cfargument name="$softDeleteCheck" type="boolean" required="true">
	<cfscript>
		var loc = {};
		if (Len(arguments.where))
		{
			// setup an array containing class info for current class and all the ones that should be included
			loc.classes = [];
			if (Len(arguments.include))
				loc.classes = $expandedAssociations(include=arguments.include);
			ArrayPrepend(loc.classes, variables.wheels.class);
			ArrayAppend(arguments.sql, "WHERE");
			loc.wherePos = ArrayLen(arguments.sql) + 1;
			loc.params = ArrayNew(1);
			loc.where = ReplaceList(REReplace(arguments.where, variables.wheels.class.RESQLWhere, "\1?\8" , "all"), "AND,OR", "#chr(7)#AND,#chr(7)#OR");
			for (loc.i=1; loc.i <= ListLen(loc.where, Chr(7)); loc.i++)
			{
				loc.param = {};
				loc.element = Replace(ListGetAt(loc.where, loc.i, Chr(7)), Chr(7), "", "one");
				if (Find("(", loc.element) && Find(")", loc.element))
					loc.elementDataPart = SpanExcluding(Reverse(SpanExcluding(Reverse(loc.element), "(")), ")");
				else if (Find("(", loc.element))
					loc.elementDataPart = Reverse(SpanExcluding(Reverse(loc.element), "("));
				else if (Find(")", loc.element))
					loc.elementDataPart = SpanExcluding(loc.element, ")");
				else
					loc.elementDataPart = loc.element;
				loc.elementDataPart = Trim(ReplaceList(loc.elementDataPart, "AND,OR", ""));
				loc.temp = REFind("^([a-zA-Z0-9-_\.]*)#variables.wheels.class.RESQLOperators#", loc.elementDataPart, 1, true);
				if (ArrayLen(loc.temp.len) gt 1)
				{
					loc.where = Replace(loc.where, loc.element, Replace(loc.element, loc.elementDataPart, "?", "one"));
					loc.param.property = Mid(loc.elementDataPart, loc.temp.pos[2], loc.temp.len[2]);
					loc.jEnd = ArrayLen(loc.classes);
					for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
					{
						loc.classData = loc.classes[loc.j];
						if (loc.param.property Does Not Contain "." || ListFirst(loc.param.property, ".") == loc.classData.tableName)
						{
							if (ListFindNoCase(loc.classData.propertyList, ListLast(loc.param.property, ".")))
							{
								loc.param.type = loc.classData.properties[ListLast(loc.param.property, ".")].type;
								loc.param.scale = loc.classData.properties[ListLast(loc.param.property, ".")].scale;
								loc.param.column = loc.classData.tableName & "." & loc.classData.properties[ListLast(loc.param.property, ".")].column;
								break;
							}
							else if (ListFindNoCase(loc.classData.calculatedPropertyList, ListLast(loc.param.property, ".")))
							{
								loc.param.type = "CF_SQL_CHAR";
								loc.param.scale = 0;
								loc.param.column = loc.classData.calculatedProperties[ListLast(loc.param.property, ".")].sql;
								break;
							}
						}
					}
					if (application.wheels.showErrorInformation && !StructKeyExists(loc.param, "column"))
						$throw(type="Wheels.ColumnNotFound", message="Wheels looked for the column mapped to the `#loc.param.property#` property but couldn't find it in the database table.", extendedInfo="Verify the `where` argument and/or your property to column mappings done with the `property` method inside the model's `init` method to make sure everything is correct.");
					loc.temp = REFind("^[a-zA-Z0-9-_\.]*#variables.wheels.class.RESQLOperators#", loc.elementDataPart, 1, true);
					loc.param.operator = Trim(Mid(loc.elementDataPart, loc.temp.pos[2], loc.temp.len[2]));
					ArrayAppend(loc.params, loc.param);
				}
			}
			loc.where = ReplaceList(loc.where, "#Chr(7)#AND,#Chr(7)#OR", "AND,OR");

			// add to sql array
			loc.where = " #loc.where# ";
			loc.iEnd = ListLen(loc.where, "?");
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(loc.where, loc.i, "?");
				if (Len(Trim(loc.item)))
					ArrayAppend(arguments.sql, loc.item);
				if (loc.i < ListLen(loc.where, "?"))
				{
					loc.column = loc.params[loc.i].column;
					ArrayAppend(arguments.sql, "#loc.column# #loc.params[loc.i].operator#");
					loc.param = {type=loc.params[loc.i].type, scale=loc.params[loc.i].scale};
					ArrayAppend(arguments.sql, loc.param);
				}
			}
		}

		if (arguments.$softDeleteCheck)
		{
			/// add soft delete sql
			loc.classes = [];
			if (Len(arguments.include))
				loc.classes = $expandedAssociations(include=arguments.include);
			ArrayPrepend(loc.classes, variables.wheels.class);
			loc.models = "";
			loc.iEnd = ArrayLen(loc.classes);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				loc.models = ListAppend(loc.models, loc.classes[loc.i].modelName);
			loc.addToWhere = "";
			loc.iEnd = ListLen(loc.models);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.model = ListGetAt(loc.models, loc.i);
				if (model(loc.model).$softDeletion())
					loc.addToWhere = ListAppend(loc.addToWhere, model(loc.model).tableName() & "." & model(loc.model).$softDeleteColumn() & " IS NULL");
			}
			loc.addToWhere = Replace(loc.addToWhere, ",", " AND ", "all");
			if (Len(loc.addToWhere))
			{
				if (Len(arguments.where))
				{
					ArrayInsertAt(arguments.sql, loc.wherePos, " (");
					ArrayAppend(arguments.sql, ") AND (");
					ArrayAppend(arguments.sql, loc.addToWhere);
					ArrayAppend(arguments.sql, ")");
				}
				else
				{
					ArrayAppend(arguments.sql, "WHERE ");
					ArrayAppend(arguments.sql, loc.addToWhere);
				}
			}
		}
	</cfscript>
	<cfreturn arguments.sql>
</cffunction>

<cffunction name="$addWhereClauseParameters" returntype="array" access="public" output="false">
	<cfargument name="sql" type="array" required="true">
	<cfargument name="where" type="string" required="true">
	<cfscript>
		var loc = {};
		if (Len(arguments.where))
		{
			loc.start = 1;
			loc.originalValues = [];
			while (!StructKeyExists(loc, "temp") || ArrayLen(loc.temp.len) gt 1)
			{
				loc.temp = REFind(variables.wheels.class.RESQLWhere, arguments.where, loc.start, true);
				if (ArrayLen(loc.temp.len) gt 1)
				{
					loc.start = loc.temp.pos[4] + loc.temp.len[4];
					ArrayAppend(loc.originalValues, ReplaceList(Chr(7) & Mid(arguments.where, loc.temp.pos[4], loc.temp.len[4]) & Chr(7), "#Chr(7)#(,)#Chr(7)#,#Chr(7)#','#Chr(7)#,#Chr(7)#"",""#Chr(7)#,#Chr(7)#", ",,,,,,"));
				}
			}

			loc.pos = ArrayLen(loc.originalValues);
			loc.iEnd = ArrayLen(arguments.sql);
			for (loc.i=loc.iEnd; loc.i gt 0; loc.i--)
			{
				if (IsStruct(arguments.sql[loc.i]) && loc.pos gt 0)
				{
					arguments.sql[loc.i].value = loc.originalValues[loc.pos];
					if (loc.originalValues[loc.pos] == "")
						arguments.sql[loc.i].null = true;
					loc.pos--;
				}
			}
		}
	</cfscript>
	<cfreturn arguments.sql>
</cffunction>

<cffunction name="$expandProperties" returntype="string" access="public" output="false">
	<cfargument name="list" type="string" required="true">
	<cfargument name="classes" type="array" required="true">
	<cfscript>
		var loc = {};
		loc.matches = REMatch("[A-Za-z1-9]+\.\*", arguments.list);
		loc.iEnd = ArrayLen(loc.matches);
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
		{
			loc.match = loc.matches[loc.i];
			loc.fields = "";
			loc.tableName = ListGetAt(loc.match, 1, ".");
			loc.jEnd = ArrayLen(arguments.classes);
			for (loc.j = 1; loc.j lte loc.jEnd; loc.j++)
			{
				loc.class = arguments.classes[loc.j];
				if (loc.class.tableName == loc.tableName)
				{
					for (loc.item in loc.class.properties)
						loc.fields = ListAppend(loc.fields, "#loc.class.tableName#.#loc.item#");
					break;
				}
			}

			if (Len(loc.fields))
				arguments.list = Replace(arguments.list, loc.match, loc.fields, "all");
			else if (application.wheels.showErrorInformation)
				$throw(type="Wheels.ModelNotFound", message="Wheels looked for the model mapped to table name `#loc.tableName#` but couldn't find it.", extendedInfo="Verify the `select` argument and/or your model association mappings are correct.");
		}
	</cfscript>
	<cfreturn arguments.list />
</cffunction>

<cffunction name="$expandedAssociations" returntype="array" access="public" output="false">
	<cfargument name="include" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = [];

		// add the current class name so that the levels list start at the lowest level
		loc.levels = variables.wheels.class.modelName;

		// count the included associations
		loc.iEnd = ListLen(Replace(arguments.include, "(", ",", "all"));

		// clean up spaces in list and add a comma at the end to indicate end of string
		loc.include = Replace(arguments.include, " ", "", "all") & ",";

		loc.pos = 1;
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			// look for the next delimiter in the string and set it
			loc.delimPos = FindOneOf("(),", loc.include, loc.pos);
			loc.delimChar = Mid(loc.include, loc.delimPos, 1);

			// set current association name and set new position to start search in the next loop
			loc.name = Mid(loc.include, loc.pos, loc.delimPos-loc.pos);
			loc.pos = REFindNoCase("[a-z]", loc.include, loc.delimPos);

			// create a reference to current class in include string and get its association info
			loc.class = model(ListLast(loc.levels));
			loc.classAssociations = loc.class.$classData().associations;

			// throw an error if the association was not found
			if (application.wheels.showErrorInformation && !StructKeyExists(loc.classAssociations, loc.name))
				$throw(type="Wheels.AssociationNotFound", message="An association named `#loc.name#` could not be found on the `#ListLast(loc.levels)#` model.", extendedInfo="Setup an association in the `init` method of the `models/#capitalize(ListLast(loc.levels))#.cfc` file and name it `#loc.name#`. You can use the `belongsTo`, `hasOne` or `hasMany` method to set it up.");

			// create a reference to the associated class
			loc.associatedClass = model(loc.classAssociations[loc.name].modelName);

			if (!Len(loc.classAssociations[loc.name].foreignKey))
			{
				if (loc.classAssociations[loc.name].type == "belongsTo")
				{
					loc.classAssociations[loc.name].foreignKey = loc.associatedClass.$classData().modelName & Replace(loc.associatedClass.$classData().keys, ",", ",#loc.associatedClass.$classData().modelName#", "all");
				}
				else
				{
					loc.classAssociations[loc.name].foreignKey = loc.class.$classData().modelName & Replace(loc.class.$classData().keys, ",", ",#loc.class.$classData().modelName#", "all");
				}
			}

			loc.classAssociations[loc.name].tableName = loc.associatedClass.$classData().tableName;
			loc.classAssociations[loc.name].columnList = loc.associatedClass.$classData().columnList;
			loc.classAssociations[loc.name].properties = loc.associatedClass.$classData().properties;
			loc.classAssociations[loc.name].propertyList = loc.associatedClass.$classData().propertyList;
			loc.classAssociations[loc.name].calculatedProperties = loc.associatedClass.$classData().calculatedProperties;
			loc.classAssociations[loc.name].calculatedPropertyList = loc.associatedClass.$classData().calculatedPropertyList;

			// create the join string if it hasn't already been done (no need to lock this code since when multiple requests process it they will end up setting the same value (no intermediate value is ever set on the join variable in the application scoped model object)
			if (!StructKeyExists(loc.classAssociations[loc.name], "join"))
			{
				loc.joinType = ReplaceNoCase(loc.classAssociations[loc.name].joinType, "outer", "left outer", "one");
				loc.join = UCase(loc.joinType) & " JOIN #loc.classAssociations[loc.name].tableName# ON ";
				loc.toAppend = "";
				loc.jEnd = ListLen(loc.classAssociations[loc.name].foreignKey);
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					loc.key1 = ListGetAt(loc.classAssociations[loc.name].foreignKey, loc.j);
					if (loc.classAssociations[loc.name].type == "belongsTo")
					{
						loc.key2 = ListFindNoCase(loc.associatedClass.$classData().keys, loc.key1);
						if (loc.key2)
							loc.key2 = ListGetAt(loc.associatedClass.$classData().keys, loc.key2);
						else
							loc.key2 = ListGetAt(loc.associatedClass.$classData().keys, loc.j);
						loc.first = loc.key1;
						loc.second = loc.key2;
					}
					else
					{
						loc.key2 = ListFindNoCase(loc.class.$classData().keys, loc.key1);
						if (loc.key2)
							loc.key2 = ListGetAt(loc.class.$classData().keys, loc.key2);
						else
							loc.key2 = ListGetAt(loc.class.$classData().keys, loc.j);
						loc.first = loc.key2;
						loc.second = loc.key1;
					}
					loc.toAppend = ListAppend(loc.toAppend, "#loc.class.$classData().tableName#.#loc.class.$classData().properties[loc.first].column# = #loc.classAssociations[loc.name].tableName#.#loc.associatedClass.$classData().properties[loc.second].column#");
				}
				loc.classAssociations[loc.name].join = loc.join & Replace(loc.toAppend, ",", " AND ", "all");
			}

			// go up or down one level in the association tree
			if (loc.delimChar == "(")
				loc.levels = ListAppend(loc.levels, loc.classAssociations[loc.name].modelName);
			else if (loc.delimChar == ")")
				loc.levels = ListDeleteAt(loc.levels, ListLen(loc.levels));

			// add info to the array that we will return
			ArrayAppend(loc.returnValue, loc.classAssociations[loc.name]);
		}
		</cfscript>
		<cfreturn loc.returnValue>
</cffunction>

<!--- other --->

<cffunction name="$createInstance" returntype="any" access="public" output="false">
	<cfargument name="properties" type="any" required="true">
	<cfargument name="persisted" type="boolean" required="true">
	<cfargument name="row" type="numeric" required="false" default="1">
	<cfargument name="base" type="boolean" required="false" default="true">
	<cfargument name="callbacks" type="boolean" required="false" default="true" hint="See documentation for @save.">
	<cfscript>
		var loc = {};
		loc.fileName = capitalize(variables.wheels.class.modelName);
		if (!ListFindNoCase(application.wheels.existingModelFiles, variables.wheels.class.modelName))
			loc.fileName = "Model";
		loc.returnValue = $createObjectFromRoot(path=application.wheels.modelComponentPath, fileName=loc.fileName, method="$initModelObject", name=variables.wheels.class.modelName, properties=arguments.properties, persisted=arguments.persisted, row=arguments.row, base=arguments.base);
		// if this method is called with a struct we're creating a new object and then we call the afterNew callback. If called with a query we call the afterFind callback instead. If the called method does not return false we proceed and run the afterInitialize callback.
		if ((IsQuery(arguments.properties) && loc.returnValue.$callback("afterFind", arguments.callbacks)) || (IsStruct(arguments.properties) && loc.returnValue.$callback("afterNew", arguments.callbacks)))
			loc.returnValue.$callback("afterInitialization", arguments.callbacks);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!--- PRIVATE MODEL OBJECT METHODS --->

<!--- crud --->

<cffunction name="$create" returntype="boolean" access="public" output="false">
	<cfargument name="parameterize" type="any" required="true">
	<cfscript>
		var loc = {};
		if (variables.wheels.class.timeStampingOnCreate)
			$timestampProperty(property=variables.wheels.class.timeStampOnCreateProperty);
		if (application.wheels.setUpdatedAtOnCreate && variables.wheels.class.timeStampingOnUpdate)
			$timestampProperty(property=variables.wheels.class.timeStampOnUpdateProperty);
		loc.sql = [];
		loc.sql2 = [];
		ArrayAppend(loc.sql, "INSERT INTO #variables.wheels.class.tableName# (");
		ArrayAppend(loc.sql2, " VALUES (");
		for (loc.key in variables.wheels.class.properties)
		{
			if (StructKeyExists(this, loc.key))
			{
				ArrayAppend(loc.sql, variables.wheels.class.properties[loc.key].column);
				ArrayAppend(loc.sql, ",");
				loc.param = {value=this[loc.key], type=variables.wheels.class.properties[loc.key].type, scale=variables.wheels.class.properties[loc.key].scale, null=this[loc.key] == ""};
				ArrayAppend(loc.sql2, loc.param);
				ArrayAppend(loc.sql2, ",");
			}
		}
		ArrayDeleteAt(loc.sql, ArrayLen(loc.sql));
		ArrayDeleteAt(loc.sql2, ArrayLen(loc.sql2));
		ArrayAppend(loc.sql, ")");
		ArrayAppend(loc.sql2, ")");
		loc.iEnd = ArrayLen(loc.sql);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			ArrayAppend(loc.sql, loc.sql2[loc.i]);
		loc.ins = variables.wheels.class.adapter.$query(sql=loc.sql, parameterize=arguments.parameterize, $primaryKey=variables.wheels.class.keys);
		loc.generatedKey = variables.wheels.class.adapter.$generatedKey();
		if (StructKeyExists(loc.ins.result, loc.generatedKey))
			this[ListGetAt(variables.wheels.class.keys, 1)] = loc.ins.result[loc.generatedKey];
	</cfscript>
	<cfreturn true>
</cffunction>

<cffunction name="$update" returntype="boolean" access="public" output="false">
	<cfargument name="parameterize" type="any" required="true">
	<cfscript>
		var loc = {};
		if (variables.wheels.class.timeStampingOnUpdate)
			$timestampProperty(property=variables.wheels.class.timeStampOnUpdateProperty);
		loc.sql = [];
		ArrayAppend(loc.sql, "UPDATE #variables.wheels.class.tableName# SET ");
		for (loc.key in variables.wheels.class.properties)
		{
			// include all non key values in the update
			if (StructKeyExists(this, loc.key) && !ListFindNoCase(variables.wheels.class.keys, loc.key))
			{
				ArrayAppend(loc.sql, "#variables.wheels.class.properties[loc.key].column# = ");
				loc.param = {value=this[loc.key], type=variables.wheels.class.properties[loc.key].type, scale=variables.wheels.class.properties[loc.key].scale, null=this[loc.key] == ""};
				ArrayAppend(loc.sql, loc.param);
				ArrayAppend(loc.sql, ",");
			}
		}
		ArrayDeleteAt(loc.sql, ArrayLen(loc.sql));
		loc.sql = $addKeyWhereClause(sql=loc.sql);
		loc.upd = variables.wheels.class.adapter.$query(sql=loc.sql, parameterize=arguments.parameterize);
	</cfscript>
	<cfreturn true>
</cffunction>

<!--- other --->

<!---
	developers can now override this method for localizing dates if they perfer.
--->
<cffunction name="$timestampProperty" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true" />
	<cfscript>
		this[arguments.property] = Now();
	</cfscript>
</cffunction>

<cffunction name="$keyWhereString" returntype="string" access="public" output="false">
	<cfargument name="properties" type="any" required="false" default="#variables.wheels.class.keys#">
	<cfargument name="values" type="any" required="false" default="">
	<cfargument name="keys" type="any" required="false" default="">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.iEnd = ListLen(arguments.properties);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.key = Trim(ListGetAt(arguments.properties, loc.i));
			if (Len(arguments.values))
				loc.value = Trim(ListGetAt(arguments.values, loc.i));
			else if (Len(arguments.keys))
				loc.value = this[ListGetAt(arguments.keys, loc.i)];
			else
				loc.value = "IS NULL";
			if (loc.value != "IS NULL")
				{
				loc.toAppend = loc.key & "=";
				if (!IsNumeric(loc.value))
					loc.toAppend = loc.toAppend & "'";
				loc.toAppend = loc.toAppend & loc.value;
				if (!IsNumeric(loc.value))
					loc.toAppend = loc.toAppend & "'";
				loc.returnValue = ListAppend(loc.returnValue, loc.toAppend, " ");
				}
			if (loc.i < loc.iEnd)
				loc.returnValue = ListAppend(loc.returnValue, "AND", " ");
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>




<<<<<<< .mine
=======
<cffunction name="findById" returntype="any" access="public" output="false">
	<cfargument name="id" type="any" required="true">
	<cfargument name="select" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="indexes" type="any" required="false" default="">
	<cfargument name="skipParam" type="any" required="false" default="">
	<cfargument name="reload" type="any" required="false" default="false">
	<cfset arguments.where = "#variables.class.primaryKey# = #arguments.id#">
	<cfset arguments._queryName = "findById">
	<cfset structDelete(arguments, "id")>
	<cfreturn findOne(argumentCollection=arguments)>
</cffunction>


<cffunction name="findOne" returntype="any" access="public" output="false">
	<cfargument name="select" type="any" required="false" default="">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="order" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="indexes" type="any" required="false" default="">
	<cfargument name="skipParam" type="any" required="false" default="">
	<cfargument name="reload" type="any" required="false" default="false">
	<cfset var locals = structNew()>

	<cfset arguments.maxrows = 1>
	<cfset arguments._queryName = "findOne">
	<cfset locals.query = _query(argumentCollection=arguments)>
	<cfset locals.object = _createModelObject(properties=locals.query)>

	<cfif locals.query.recordCount IS NOT 0>
		<cfset locals.object.found = true>
	<cfelse>
		<cfset locals.object.found = false>
	</cfif>

	<cfreturn locals.object>
</cffunction>


<cffunction name="findAll" returntype="any" access="public" output="false">
	<cfargument name="select" type="any" required="false" default="">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="order" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="maxrows" type="any" required="false" default="-1">
	<cfargument name="page" type="any" required="false" default="">
	<cfargument name="perPage" type="any" required="false" default=10>
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="indexes" type="any" required="false" default="">
	<cfargument name="skipParam" type="any" required="false" default="">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfset var locals = structNew()>

	<cfif len(arguments.page) IS NOT 0>
		<!--- count the total records (for use in paginationLinks) --->
		<cfset locals.countArguments = duplicate(arguments)>
		<cfif len(arguments.include) IS NOT 0>
			<cfset locals.countArguments.select = "COUNT(DISTINCT #variables.class.tableName#.#variables.class.primaryKey#) AS total">
		<cfelse>
			<cfset locals.countArguments.select = "COUNT(#variables.class.tableName#.#variables.class.primaryKey#) AS total">
		</cfif>
		<cfset structDelete(locals.countArguments, "order")>
		<cfset structDelete(locals.countArguments, "page")>
		<cfif isDefined("arguments.indexes.count")>
			<cfset locals.countArguments.indexes =  arguments.indexes.count>
		</cfif>
		<cfset locals.countArguments._queryName = "paginationCount">
		<cfset locals.countQuery = _query(argumentCollection=locals.countArguments)>
		<cfset locals.totalRecords = locals.countQuery.total>
		<cfset locals.currentPage = arguments.page>
		<cfif locals.totalRecords IS 0>
			<cfset locals.totalPages = 0>
		<cfelse>
			<cfset locals.totalPages = ceiling(locals.totalRecords/arguments.perPage)>
		</cfif>
		<cfif locals.totalRecords LTE ((arguments.page * arguments.perPage) - arguments.perPage)>
			<cfset locals.ids = 0>
		<cfelse>
			<!--- get the ids --->
			<cfset locals.paginationArguments = duplicate(arguments)>
			<cfset locals.paginationArguments.select = "#variables.class.tableName#.#variables.class.primaryKey# AS primaryKey">
			<cfset locals.paginationArguments.limit = arguments.perPage>
			<cfset locals.paginationArguments.offset = (arguments.perPage * arguments.page) - arguments.perPage>
			<cfif (locals.paginationArguments.limit + locals.paginationArguments.offset) GT locals.totalRecords>
				<cfset locals.paginationArguments.limit = locals.totalRecords - locals.paginationArguments.offset>
			</cfif>
			<cfif isDefined("arguments.indexes.ids")>
				<cfset locals.paginationArguments.indexes = arguments.indexes.ids>
			</cfif>
			<cfset locals.paginationArguments._queryName = "paginationIds">
			<cfset locals.primaryKeys = _query(argumentCollection=locals.paginationArguments)>
			<cfset locals.ids = valueList(locals.primaryKeys.primaryKey)>
		</cfif>
		<cfset arguments.where = "#variables.class.tableName#.#variables.class.primaryKey# IN (#locals.ids#)">
		<cfset arguments.softDeleteCheck = false>
	</cfif>

	<cfset arguments._queryName = "findAll">
	<cfset locals.query = _query(argumentCollection=arguments)>

	<cfif len(arguments.page) IS NOT 0>
		<!--- store pagination info in the request scope so paginationlinks can access it --->
		<cfset request.wheels[arguments.handle] = structNew()>
		<cfset request.wheels[arguments.handle].currentPage = locals.currentPage>
		<cfset request.wheels[arguments.handle].totalPages = locals.totalPages>
		<cfset request.wheels[arguments.handle].totalRecords = locals.totalRecords>
	</cfif>

	<cfreturn locals.query>
</cffunction>


<cffunction name="_query" returntype="any" access="private" output="false">
	<cfargument name="select" type="any" required="false" default="">
	<cfargument name="from" type="any" required="false" default="">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="order" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="indexes" type="any" required="false" default="">
	<cfargument name="maxrows" type="any" required="false" default="-1">
	<cfargument name="limit" type="any" required="false" default="">
	<cfargument name="offset" type="any" required="false" default="">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="softDeleteCheck" type="any" required="false" default="true">
	<cfargument name="skipParam" type="any" required="false" default="">
	<cfargument name="reload" type="any" required="false" default="false">
	<cfargument name="_queryName" type="any" required="false" default="query">
	<cfset var locals = structNew()>

	<!--- Remove parenthesis from date formatting to make it easier to parse --->
	<cfset arguments.where = replaceList(arguments.where, "'{ts ','}'", "','")>
	<cfset arguments.where = replaceList(arguments.where, "{ts ','}", "','")>

	<!--- replace values in the where argument with question marks so that we can cache it without the dynamic values --->
	<cfset locals.regex = "((=|<>|<|>|<=|>=|!=|!<|!>| LIKE | IN) ?)(''|'.+?'()|([0-9]|\.)+()|\([0-9]+(,[0-9]+)*\))(($|\)| (AND|OR)))">
	<cfset locals.paramedWhere = arguments.where>
	<!--- match strings, numbers and lists --->
	<cfset locals.paramedWhere = REReplace(locals.paramedWhere, locals.regex, "\1?\8" , "all")>

	<cfset locals.paramedArguments = structNew()>
	<cfset locals.paramedArguments.paramedWhere = locals.paramedWhere>
	<cfset locals.paramedArguments.select = arguments.select>
	<cfset locals.paramedArguments.from = arguments.from>
	<cfset locals.paramedArguments.order = arguments.order>
	<cfset locals.paramedArguments.include = arguments.include>
	<cfset locals.paramedArguments.indexes = arguments.indexes>

 	<!--- get where, order, joins info etc from the cache (double-checked lock) --->
	<cfset locals.category = "sql">
	<cfset locals.key = "#variables.class.name#_#_hashStruct(locals.paramedArguments)#">
	<cfset locals.lockName = locals.category & locals.key>
	<cflock name="#locals.lockName#" type="readonly" timeout="30">
		<cfset locals.sql = _getFromCache(locals.key, locals.category, "internal")>
	</cflock>

	<cfif isBoolean(locals.sql) AND NOT locals.sql>
   	<cflock name="#locals.lockName#" type="exclusive" timeout="30">
			<cfset locals.sql = _getFromCache(locals.key, locals.category, "internal")>
			<cfif isBoolean(locals.sql) AND NOT locals.sql>
				<!--- nothing was found in the cache so start figuring out where, order, joins clauses etc --->
				<cfset locals.sql = structNew()>

				<!--- add where clause --->
				<cfset locals.sql.where = "">
				<cfset locals.whereFields = "">
				<cfif len(arguments.where) IS NOT 0>
					<!--- create a where clause which only consists of question marks for param references, AND/OR operators and parenthesis --->
					<cfset locals.sql.where = locals.paramedWhere>
					<cfset locals.sql.params = arrayNew(1)>
					<cfset locals.sql.where = replaceList(locals.sql.where, "AND,OR", "#chr(7)#AND,#chr(7)#OR")>
					<cfloop list="#locals.sql.where#" delimiters="#chr(7)#" index="locals.i">
						<cfset locals.element = replace(locals.i, chr(7), "", "one")>
						<cfif find("(", locals.element) AND find(")", locals.element)>
							<cfset locals.elementDataPart = reverse(spanExcluding(reverse(locals.element), "("))>
							<cfset locals.elementDataPart = spanExcluding(locals.elementDataPart, ")")>
						<cfelseif find("(", locals.element)>
							<cfset locals.elementDataPart = reverse(spanExcluding(reverse(locals.element), "("))>
						<cfelseif find(")", locals.element)>
							<cfset locals.elementDataPart = spanExcluding(locals.element, ")")>
						<cfelse>
							<cfset locals.elementDataPart = locals.element>
						</cfif>
						<cfset locals.elementDataPart = trim(replaceList(locals.elementDataPart, "AND,OR", ""))>
						<cfset locals.param = structNew()>
						<cfset locals.temp = REFind("^([^ ]*) ?(=|<>|<|>|<=|>=|!=|!<|!>| LIKE | IN)", locals.elementDataPart, 1, true)>
						<cfif arrayLen(locals.temp.len) GT 1>
							<cfset locals.sql.where = replace(locals.sql.where, locals.element, replace(locals.element, locals.elementDataPart, "?", "one"))>
							<cfset locals.param.field = mid(locals.elementDataPart, locals.temp.pos[2], locals.temp.len[2])>

							<cfif (locals.param.field Contains "." AND listFirst(locals.param.field, ".") IS variables.class.tableName OR locals.param.field Does Not Contain ".") AND listFindNoCase(variables.class.fieldList, listLast(locals.param.field, ".")) IS NOT 0>
								<cfset locals.param.field = variables.class.tableName & "." & listLast(locals.param.field, ".")>
								<cfset locals.param.cfsqltype = variables.class.fields[listLast(locals.param.field, ".")].cfsqltype>
								<cfset locals.param.fieldName = listLast(locals.param.field, ".")>
							<cfelseif (locals.param.field Contains "." AND listFirst(locals.param.field, ".") IS variables.class.tableName OR locals.param.field Does Not Contain ".") AND listFindNoCase(variables.class.composedFieldList, listLast(locals.param.field, ".")) IS NOT 0>
								<cfset locals.param.cfsqltype = variables.class.composedFields[listLast(locals.param.field, ".")].cfsqltype>
								<cfset locals.param.fieldName = listLast(locals.param.field, ".")>
								<cfset locals.param.field = variables.class.composedFields[listLast(locals.param.field, ".")].sql>
							<cfelse>
								<cfset locals.temp = _extractFromAssociations(include=arguments.include, type="firstFieldMatchForWhere", match=locals.param.field)>
								<cfset locals.param.field = locals.temp.field>
								<cfset locals.param.cfsqltype = locals.temp.cfsqltype>
								<cfset locals.param.fieldName = locals.temp.fieldName>
							</cfif>
							<cfset locals.temp = REFind("^[^ ]* ?(=|<>|<|>|<=|>=|!=|!<|!>| LIKE | IN)", locals.elementDataPart, 1, true)>
							<cfset locals.param.operator = trim(mid(locals.elementDataPart, locals.temp.pos[2], locals.temp.len[2]))>
							<cfif locals.param.operator IS "IN">
								<cfset locals.param.list = true>
							<cfelse>
								<cfset locals.param.list = false>
							</cfif>
							<cfset locals.whereFields = listAppend(locals.whereFields, locals.param.field)>
							<cfset arrayAppend(locals.sql.params, locals.param)>
						</cfif>
					</cfloop>
					<cfset locals.sql.where = replaceList(locals.sql.where, "#chr(7)#AND,#chr(7)#OR", "AND,OR")>
				</cfif>

				<!--- add select clause --->
				<cfif len(arguments.select) IS NOT 0>
					<cfset locals.sql.select = "">
					<cfloop list="#arguments.select#" index="locals.i">
						<cfset locals.i = trim(locals.i)>
						<cfif arguments.select Does Not Contain " AS ">
							<cfif (locals.i Contains "." AND listFirst(locals.i, ".") IS variables.class.tableName OR locals.i Does Not Contain ".") AND listFindNoCase(variables.class.fieldList, listLast(locals.i, ".")) IS NOT 0>
								<cfset locals.i = variables.class.tableName & "." & listLast(locals.i, ".")>
							<cfelseif (locals.i Contains "." AND listFirst(locals.i, ".") IS variables.class.tableName OR locals.i Does Not Contain ".") AND listFindNoCase(variables.class.composedFieldList, listLast(locals.i, ".")) IS NOT 0>
								<cfset locals.i = variables.class.composedFields[listLast(locals.i, ".")].sql & " AS " & listLast(locals.i, ".")>
							<cfelse>
								<cfset locals.i = _extractFromAssociations(include=arguments.include, type="firstFieldMatchForSelect", match=locals.i)>
							</cfif>
						</cfif>
						<cfset locals.sql.select = listAppend(locals.sql.select, locals.i, chr(7))>
					</cfloop>
				<cfelse>
					<cfset locals.sql.select = "#variables.class.tableName#.#replace(variables.class.fieldList, ',', '#chr(7)##variables.class.tableName#.', 'all')#">
					<cfif len(variables.class.composedFieldList) IS NOT 0>
						<cfloop collection="#variables.class.composedFields#" item="locals.i">
							<cfset locals.sql.select = listAppend(locals.sql.select, "#variables.class.composedFields[locals.i].sql# AS #locals.i#", chr(7))>
						</cfloop>
					</cfif>
					<cfif len(arguments.include) IS NOT 0>
						<cfset locals.sql.select = locals.sql.select & _extractFromAssociations(include=arguments.include, type="fullSelectClause")>
					</cfif>
				</cfif>

				<!--- add order clause --->
				<cfset locals.sql.order = "">
				<cfset locals.sql.pagination.qualifiedSelect = "">
				<cfset locals.sql.pagination.simpleSelect = "">
				<cfset locals.sql.pagination.qualifiedOrder = "">
				<cfset locals.sql.pagination.simpleOrder = "">
				<cfset locals.sql.pagination.qualifiedOrderReversed = "">
				<cfset locals.sql.pagination.simpleOrderReversed = "">
				<cfif len(arguments.order) IS NOT 0>
					<cfif arguments.order IS "random">
						<cfif application.wheels.database.type IS "sqlserver">
							<cfset locals.sql.order = "NEWID()">
						<cfelseif application.wheels.database.type IS "mysql">
							<cfset locals.sql.order = "RAND()">
						</cfif>
					<cfelse>
						<cfloop list="#arguments.order#" index="locals.i">
							<cfset locals.i = trim(locals.i)>
							<cfif locals.i Does Not Contain " ASC" AND locals.i Does Not Contain " DESC">
								<cfset locals.i = locals.i & " ASC">
							</cfif>
							<cfset locals.sql.pagination.simpleOrder = listAppend(locals.sql.pagination.simpleOrder, listLast(locals.i, "."), chr(7))>
							<cfif (locals.i Contains "." AND listFirst(locals.i, ".") IS variables.class.tableName OR locals.i Does Not Contain ".") AND listFindNoCase(variables.class.fieldList, listLast(spanExcluding(locals.i, " "), ".")) IS NOT 0>
								<cfset locals.i = variables.class.tableName & "." & listLast(locals.i, ".")>
							<cfelseif (locals.i Contains "." AND listFirst(locals.i, ".") IS variables.class.tableName OR locals.i Does Not Contain ".") AND listFindNoCase(variables.class.composedFieldList, listLast(spanExcluding(locals.i, " "), ".")) IS NOT 0>
								<cfset locals.i = replace(locals.i, spanExcluding(locals.i, " "), variables.class.composedFields[listLast(spanExcluding(locals.i, " "), ".")].sql)>
							<cfelse>
								<cfset locals.i = _extractFromAssociations(include=arguments.include, type="firstFieldMatchForOrder", match=locals.i)>
							</cfif>
							<cfset locals.sql.order = listAppend(locals.sql.order, locals.i, chr(7))>
							<cfset locals.sql.pagination.qualifiedOrder = listAppend(locals.sql.pagination.qualifiedOrder, locals.i, chr(7))>
						</cfloop>
						<!--- create a select string for pagination that has the primary key and all fields from the order clause --->
						<cfset locals.sql.pagination.simpleSelect = REReplaceNoCase(locals.sql.pagination.simpleOrder, " (asc|desc)", "", "all") & chr(7) & variables.class.primaryKey>
						<cfset locals.sql.pagination.qualifiedSelect = REReplaceNoCase(locals.sql.pagination.qualifiedOrder, " (asc|desc)", "", "all") & chr(7) & variables.class.tableName & "." & variables.class.primaryKey>
						<!--- delete the primary key from select if it is not the last element of the list (because it has to be last in the list and not duplicated) --->
						<cfif listFindNoCase(locals.sql.pagination.simpleSelect, variables.class.primaryKey, chr(7)) IS NOT listLen(locals.sql.pagination.simpleSelect, chr(7))>
							<cfset locals.sql.pagination.simpleSelect = listDeleteAt(locals.sql.pagination.simpleSelect, listFindNoCase(locals.sql.pagination.simpleSelect, variables.class.primaryKey, chr(7)), chr(7))>
						</cfif>
						<cfif listFindNoCase(locals.sql.pagination.qualifiedSelect, "#variables.class.tableName#.#variables.class.primaryKey#", chr(7)) IS NOT listLen(locals.sql.pagination.qualifiedSelect, chr(7))>
							<cfset locals.sql.pagination.qualifiedSelect = listDeleteAt(locals.sql.pagination.qualifiedSelect, listFindNoCase(locals.sql.pagination.qualifiedSelect, "#variables.class.tableName#.#variables.class.primaryKey#", chr(7)), chr(7))>
						</cfif>
						<!--- add primary key to pagination order unless it is already there (to guarantee a unique order) --->
						<cfif REFindNoCase("#variables.class.tableName#.#variables.class.primaryKey# (asc|desc)", locals.sql.pagination.qualifiedOrder) IS 0>
							<cfset locals.sql.pagination.qualifiedOrder = listAppend(locals.sql.pagination.qualifiedOrder, "#variables.class.tableName#.#variables.class.primaryKey# ASC", chr(7))>
						</cfif>
						<cfif REFindNoCase("#variables.class.primaryKey# (asc|desc)", locals.sql.pagination.simpleOrder) IS 0>
							<cfset locals.sql.pagination.simpleOrder = listAppend(locals.sql.pagination.simpleOrder, "#variables.class.primaryKey# ASC", chr(7))>
						</cfif>
						<!--- reverse the order for use in SQL Server pagination SQL --->
						<cfset locals.sql.pagination.simpleOrderReversed = replaceNoCase(replaceNoCase(replaceNoCase(locals.sql.pagination.simpleOrder, "DESC", chr(164), "all"), "ASC", "DESC", "all"), chr(164), "ASC", "all")>
						<cfset locals.sql.pagination.qualifiedOrderReversed = replaceNoCase(replaceNoCase(replaceNoCase(locals.sql.pagination.qualifiedOrder, "DESC", chr(164), "all"), "ASC", "DESC", "all"), chr(164), "ASC", "all")>
						<!--- loop through qualified select string and add "AS xxx" for all composed fields --->
						<cfset locals.pos = 0>
						<cfloop list="#locals.sql.pagination.qualifiedSelect#" index="locals.i" delimiters="#chr(7)#">
							<cfset locals.pos = locals.pos + 1>
							<cfif REFindNoCase("^[a-z0-9-_]*\.#listGetAt(locals.sql.pagination.simpleSelect, locals.pos, chr(7))#$", locals.i) IS 0>
								<cfset locals.i = locals.i & " AS " & listGetAt(locals.sql.pagination.simpleSelect, locals.pos, chr(7))>
							</cfif>
							<cfset locals.sql.pagination.qualifiedSelect = listSetAt(locals.sql.pagination.qualifiedSelect, locals.pos, locals.i, chr(7))>
						</cfloop>
					</cfif>
				</cfif>

				<!--- add from clause --->
				<cfset locals.sql.from = variables.class.tableName>
				<cfif len(arguments.include) IS NOT 0>
					<cfset locals.joinStatements = _extractFromAssociations(include=arguments.include, type="joinStatements")>
					<cfset locals.join = " ">
					<cfloop from="#arrayLen(locals.joinStatements)#" to="1" step="-1" index="locals.i">
						<cfset locals.join = listAppend(locals.join, locals.joinStatements[locals.i], " ")>
					</cfloop>
					<cfloop from="1" to="#arrayLen(locals.joinStatements)#" index="locals.i">
						<!--- loop from the back of the join string and remove if they are not referenced in select, where, order by and not further back in the join string --->
						<cfset locals.tableName = spanExcluding(replace(locals.joinStatements[locals.i], "LEFT OUTER JOIN ", "", "one"), " ")>
						<cfif locals.sql.select Does Not Contain "#locals.tableName#." AND locals.whereFields Does Not Contain "#locals.tableName#." AND locals.sql.order Does Not Contain "#locals.tableName#." AND findNoCase("#locals.tableName#.", locals.join, find(locals.joinStatements[locals.i], locals.join, 1)+len(locals.joinStatements[locals.i])) IS 0>
							<cfset locals.join = replace(locals.join, " " & locals.joinStatements[locals.i], "", "one")>
						</cfif>
					</cfloop>
					<cfset locals.sql.from = locals.sql.from & locals.join>
				</cfif>

				<!--- add index hints (sql server only) --->
				<cfif isStruct(arguments.indexes)>
					<cfloop collection="#arguments.indexes#" item="locals.i">
						<cfif left(locals.sql.from, len(locals.i)) IS locals.i>
							<cfset locals.sql.from = replaceNoCase(locals.sql.from, locals.i, "#lCase(locals.i)# WITH (INDEX(#arguments.indexes[locals.i]#))", "one")>
						<cfelseif locals.sql.from Contains " #locals.i# ">
							<cfset locals.sql.from = replaceNoCase(locals.sql.from, " #locals.i# ", " #lCase(locals.i)# WITH (INDEX(#arguments.indexes[locals.i]#))", "one")>
						</cfif>
					</cfloop>
				</cfif>

				<!--- cache all the info so we don't have to do all this again for every single query --->
				<cfset _addToCache(locals.key, locals.sql, 86400, locals.category, "internal")>

			</cfif>
		</cflock>
	</cfif>

	<cfif len(locals.sql.where) IS NOT 0>
		<!--- Add the original values from the where clause to an array --->
		<cfset locals.start = 1>
		<cfset arguments.paramValues = arrayNew(1)>
		<cfloop from="1" to="#arrayLen(locals.sql.params)#" index="locals.i">
			<cfset locals.temp = REFind(locals.regex, arguments.where, locals.start, true)>
			<cfif arrayLen(locals.temp.pos) IS 1>
				<!--- nothing found, add a blank value --->
				<cfset locals.start = locals.start + 1>
				<cfset arrayAppend(arguments.paramValues, "")>
			<cfelse>
				<cfset locals.start = locals.temp.pos[4] + locals.temp.len[4]>
				<!--- strip out ', ", ( and ) characters if they are at the start or end of the string and add to array --->
				<cfset arrayAppend(arguments.paramValues, replaceList(chr(7) & mid(arguments.where, locals.temp.pos[4], locals.temp.len[4]) & chr(7), "#chr(7)#(,)#chr(7)#,#chr(7)#','#chr(7)#,#chr(7)#"",""#chr(7)#,#chr(7)#", ",,,,,,"))>
			</cfif>
		</cfloop>
	</cfif>

	<cfset arguments.sql = locals.sql>

	<cfif application.settings.cacheQueries AND (isNumeric(arguments.cache) OR (isBoolean(arguments.cache) AND arguments.cache))>
		<cfset locals.category = "query">
		<cfset locals.key = "#variables.class.name#_#_hashStruct(arguments)#">
		<cfset locals.lockName = locals.category & locals.key>
		<cflock name="#locals.lockName#" type="readonly" timeout="30">
			<cfset locals.query = _getFromCache(locals.key, locals.category)>
		</cflock>
		<cfif isBoolean(locals.query) AND NOT locals.query>
	   	<cflock name="#locals.lockName#" type="exclusive" timeout="30">
				<cfset locals.query = _getFromCache(locals.key, locals.category)>
				<cfif isBoolean(locals.query) AND NOT locals.query>
					<cfset locals.query = _executeQuery(argumentCollection=arguments)>
					<cfif NOT isNumeric(arguments.cache)>
						<cfset arguments.cache = application.settings.defaultCacheTime>
					</cfif>
					<cfset _addToCache(locals.key, locals.query, arguments.cache, locals.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset locals.query = _executeQuery(argumentCollection=arguments)>
	</cfif>

	<cfreturn locals.query>
</cffunction>


<cffunction name="_executeQuery" returntype="any" access="private" output="false">
	<cfset var locals = structNew()>
	<cfset arguments.sql.order = listChangeDelims(arguments.sql.order, ",", chr(7))>
	<cfset arguments.sql.select = listChangeDelims(arguments.sql.select, ",", chr(7))>
	<cfset arguments.sql.pagination.simpleSelect = listChangeDelims(arguments.sql.pagination.simpleSelect, ",", chr(7))>
	<cfset arguments.sql.pagination.qualifiedSelect = listChangeDelims(arguments.sql.pagination.qualifiedSelect, ",", chr(7))>
	<cfset arguments.sql.pagination.simpleOrder = listChangeDelims(arguments.sql.pagination.simpleOrder, ",", chr(7))>
	<cfset arguments.sql.pagination.qualifiedOrder = listChangeDelims(arguments.sql.pagination.qualifiedOrder, ",", chr(7))>
	<cfset arguments.sql.pagination.simpleOrderReversed = listChangeDelims(arguments.sql.pagination.simpleOrderReversed, ",", chr(7))>
	<cfset arguments.sql.pagination.qualifiedOrderReversed = listChangeDelims(arguments.sql.pagination.qualifiedOrderReversed, ",", chr(7))>

	<cfif application.settings.showDebugInformation>
		<cfset locals.queryStartTime = getTickCount()>
	</cfif>

	<cfset locals.key = _hashStruct(arguments)>
	<cfif NOT arguments.reload AND isDefined("request.wheels.cache") AND structKeyExists(request.wheels.cache, locals.key)>
		<cfset locals.query = request.wheels.cache[locals.key]>
	<cfelse>
		<cfif structKeyExists(variables.class.fields, "deletedAt") OR structKeyExists(variables.class.fields, "deletedOn")>
			<cfset locals.softDelete = true>
			<cfif structKeyExists(variables.class.fields, "deletedAt")>
				<cfset locals.softDeleteField = "deletedAt">
			<cfelseif structKeyExists(variables.class.fields, "deletedOn")>
				<cfset locals.softDeleteField = "deletedOn">
			</cfif>
		<cfelse>
			<cfset locals.softDelete = false>
		</cfif>

		<cfquery name="locals.query" datasource="#variables.class.database.read.datasource#" username="#variables.class.database.read.username#" password="#variables.class.database.read.password#" maxrows="#arguments.maxrows#">
		<cfif application.wheels.database.type IS "sqlserver" AND len(arguments.limit) IS NOT 0 AND len(arguments.offset) IS NOT 0>
		SELECT #preserveSingleQuotes(arguments.sql.pagination.simpleSelect)# AS primaryKey
		FROM (
			SELECT TOP #arguments.limit# #preserveSingleQuotes(arguments.sql.pagination.simpleSelect)#
			FROM (
				SELECT <cfif arguments.sql.from Contains " ">DISTINCT </cfif>TOP #(arguments.limit + arguments.offset)# #preserveSingleQuotes(arguments.sql.pagination.qualifiedSelect)#
				FROM #arguments.sql.from#
		<cfelse>
			SELECT #preserveSingleQuotes(arguments.sql.select)#
			FROM #arguments.sql.from#
		</cfif>
		<cfif len(arguments.sql.where) IS NOT 0>
			WHERE
			<cfif arguments.softDeleteCheck AND locals.softDelete AND arguments.where Contains " OR ">
				(
			</cfif>
			<cfset locals.pos = 0>
			<cfset arguments.sql.where = " #arguments.sql.where# ">
			<cfloop list="#arguments.sql.where#" delimiters="?" index="locals.i">
				<cfset locals.pos = locals.pos + 1>
				#locals.i#
				<cfif locals.pos LT listLen(arguments.sql.where, "?")>
					<cfset locals.tempField = arguments.sql.params[locals.pos].field>
					#preserveSingleQuotes(locals.tempField)#
					#arguments.sql.params[locals.pos].operator#
					<cfif arguments.sql.params[locals.pos].list>
						(
					</cfif>
					<cfif len(arguments.skipParam) IS NOT 0 AND listFindNoCase(arguments.skipParam, arguments.sql.params[locals.pos].fieldName)>
						<cfif arguments.sql.params[locals.pos].cfsqltype IS "cf_sql_varchar" OR arguments.sql.params[locals.pos].cfsqltype IS "cf_sql_longvarchar">
							'#arguments.paramValues[locals.pos]#'
						<cfelse>
							#arguments.paramValues[locals.pos]#
						</cfif>
					<cfelse>
						<cfqueryparam cfsqltype="#arguments.sql.params[locals.pos].cfsqltype#" list="#arguments.sql.params[locals.pos].list#" value="#arguments.paramValues[locals.pos]#">
					</cfif>
					<cfif arguments.sql.params[locals.pos].list>
						)
					</cfif>
				</cfif>
			</cfloop>
			<cfif arguments.softDeleteCheck AND locals.softDelete>
				<cfif arguments.where Contains " OR ">
					)
				</cfif>
				AND #variables.class.tableName#.#locals.softDeleteField# IS NULL
			</cfif>
		<cfelse>
			<cfif arguments.softDeleteCheck AND locals.softDelete>
				WHERE #variables.class.tableName#.#locals.softDeleteField# IS NULL
			</cfif>
		</cfif>
		<cfif application.wheels.database.type IS "sqlserver" AND len(arguments.limit) IS NOT 0 AND len(arguments.offset) IS NOT 0>
				ORDER BY #preserveSingleQuotes(arguments.sql.pagination.qualifiedOrder)#) AS tmp1
			ORDER BY #preserveSingleQuotes(arguments.sql.pagination.simpleOrderReversed)#) AS tmp2
		ORDER BY #preserveSingleQuotes(arguments.sql.pagination.simpleOrder)#
		<cfelse>
			<cfif len(arguments.sql.order) IS NOT 0>
				ORDER BY #preserveSingleQuotes(arguments.sql.order)#
			</cfif>
		</cfif>
		<cfif application.wheels.database.type IS "mysql">
			<cfif len(arguments.limit) IS NOT 0>
				LIMIT #arguments.limit#
			</cfif>
			<cfif len(arguments.offset) IS NOT 0>
				OFFSET #arguments.offset#
			</cfif>
		</cfif>
		</cfquery>
		<!--- store in request cache so we never run the exact same query twice in the same request --->
		<cfif isDefined("request.wheels.cache")>
			<cfset request.wheels.cache[locals.key] = locals.query>
		</cfif>
	</cfif>

	<cfreturn locals.query>
</cffunction>


<cffunction name="_extractFromAssociations" returntype="any" access="private" output="false">
	<cfargument name="include" type="any" required="true">
	<cfargument name="type" type="any" required="true">
	<cfargument name="match" type="any" required="false" default="">
	<cfset var locals = structNew()>

	<!--- setup the initial return data value --->
	<cfif arguments.type IS "joinStatements">
		<cfset locals.returnData = arrayNew(1)>
	<cfelse>
		<cfset locals.returnData = "">
	</cfif>

	<!--- add the current model name so that the levels list start at the lowest level --->
	<cfset locals.levels = variables.class.name>

	<!--- count the included associations --->
	<cfset locals.loopCount = listLen(replace(arguments.include, "(", ",", "all"))>

	<!--- clean up spaces in list and add a , at the end to indicate end of string --->
	<cfset locals.include = replace(arguments.include, " ", "", "all") & ",">

	<cfset locals.pos = 1>
	<cfloop from="1" to="#locals.loopCount#" index="locals.i">

		<!--- look for the next delimiter in the string and set it --->
		<cfset locals.delimPos = findOneOf("(),", locals.include, locals.pos)>
		<cfset locals.delimChar = mid(locals.include, locals.delimPos, 1)>

		<!--- set current association name and set new position to start search in the next loop (association names have to start with a letter) --->
		<cfset locals.name = mid(locals.include, locals.pos, locals.delimPos-locals.pos)>
		<cfset locals.pos = REFindNoCase("[a-z]", locals.include, locals.delimPos)>

		<!--- get a reference to the current model and get their associations --->
		<cfset locals.model = model(listLast(locals.levels))>
		<cfset locals.modelAssociations = locals.model._getAssociations()>
		<cfset locals.associatedTableName = locals.modelAssociations[locals.name].associatedTableName>
		<cfset locals.associatedModel = model(locals.modelAssociations[locals.name].associatedModelName)>
		<cfset locals.fieldList = locals.associatedModel._getFieldList()>
		<cfset locals.fields = locals.associatedModel._getFields()>
		<cfset locals.composedFieldList = locals.associatedModel._getComposedFieldList()>
		<cfset locals.composedFields = locals.associatedModel._getComposedFields()>

		<!--- Get the requested data --->
		<cfif arguments.type IS "fullSelectClause">
			<cfset locals.returnData = "#locals.returnData##chr(7)##locals.associatedTableName#.#replace(locals.associatedModel._getFieldList(), ',', '#chr(7)##locals.associatedTableName#.', 'all')#">
			<cfif len(locals.composedFieldList) IS NOT 0>
				<cfloop collection="#locals.composedFields#" item="locals.i">
					<cfset locals.returnData = listAppend(locals.returnData, "#locals.composedFields[locals.i].sql# AS #locals.i#", chr(7))>
				</cfloop>
			</cfif>

		<cfelseif arguments.type IS "firstFieldMatchForSelect">
			<cfif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS locals.associatedTableName OR arguments.match Does Not Contain ".") AND listFindNoCase(locals.fieldList, listLast(arguments.match, ".")) IS NOT 0>
				<cfreturn locals.associatedTableName & "." & listLast(arguments.match, ".")>
			<cfelseif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS locals.associatedTableName OR arguments.match Does Not Contain ".") AND listFindNoCase(locals.composedFieldList, listLast(arguments.match, ".")) IS NOT 0>
				<cfreturn locals.composedFields[listLast(arguments.match, ".")].sql & " AS " & listLast(arguments.match, ".")>
			</cfif>

		<cfelseif arguments.type IS "firstFieldMatchForOrder">
			<cfif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS locals.associatedTableName OR arguments.match Does Not Contain ".") AND listFindNoCase(locals.fieldList, listLast(spanExcluding(arguments.match, " "), ".")) IS NOT 0>
				<cfreturn locals.associatedTableName & "." & listLast(arguments.match, ".")>
			<cfelseif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS locals.associatedTableName OR arguments.match Does Not Contain ".") AND listFindNoCase(locals.composedFieldList, listLast(spanExcluding(arguments.match, " "), ".")) IS NOT 0>
				<cfreturn replace(arguments.match, spanExcluding(arguments.match, " "), locals.composedFields[listLast(spanExcluding(arguments.match, " "), ".")].sql)>
			</cfif>

		<cfelseif arguments.type IS "firstFieldMatchForWhere">
			<cfset locals.returnData = structNew()>
			<cfif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS locals.associatedTableName OR arguments.match Does Not Contain ".") AND listFindNoCase(locals.fieldList, listLast(arguments.match, ".")) IS NOT 0>
				<cfset locals.returnData.cfsqltype = locals.fields[listLast(arguments.match, ".")].cfsqltype>
				<cfset locals.returnData.fieldName = listLast(arguments.match, ".")>
				<cfset locals.returnData.field = locals.associatedTableName & "." & listLast(arguments.match, ".")>
				<cfreturn locals.returnData>
			<cfelseif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS locals.associatedTableName OR arguments.match Does Not Contain ".") AND listFindNoCase(locals.composedFieldList, listLast(arguments.match, ".")) IS NOT 0>
				<cfset locals.returnData.cfsqltype = locals.composedFields[listLast(arguments.match, ".")].cfsqltype>
				<cfset locals.returnData.fieldName = listLast(arguments.match, ".")>
				<cfset locals.returnData.field = locals.composedFields[listLast(arguments.match, ".")].sql>
				<cfreturn locals.returnData>
			</cfif>

		<cfelseif arguments.type IS "joinStatements">
			<cfset arrayPrepend(locals.returnData, locals.modelAssociations[locals.name].joinString)>
		</cfif>

		<cfif locals.delimChar IS "(">
			<!--- we're going up one level in the association tree so add the associated model's name to the list --->
			<cfset locals.levels = listAppend(locals.levels, locals.modelAssociations[locals.name].associatedModelName)>
		<cfelseif locals.delimChar IS ")">
			<!--- we're going down one level in the association tree so remove the last model name added --->
			<cfset locals.levels = listDeleteAt(locals.levels, listLen(locals.levels))>
		</cfif>

	</cfloop>

	<cfreturn locals.returnData>
</cffunction>>>>>>>> .r721

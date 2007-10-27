<cffunction name="reload" returntype="any" access="public" output="false">
	<cfreturn findByID(id=this.id, reload=true)>
</cffunction>


<cffunction name="findByID" returntype="any" access="public" output="false">
	<cfargument name="id" type="any" required="true">
	<cfargument name="select" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="indexes" type="any" required="false" default="">
	<cfargument name="skip_param" type="any" required="false" default="">
	<cfargument name="reload" type="any" required="false" default="false">
	<cfset var local = structNew()>

	<cfset arguments.where = "#variables.class.primary_key# = #arguments.id#">
	<cfset arguments.FL_query_name = "findByID">
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
	<cfargument name="skip_param" type="any" required="false" default="">
	<cfargument name="reload" type="any" required="false" default="false">
	<cfset var local = structNew()>

	<cfset arguments.maxrows = 1>
	<cfset arguments.FL_query_name = "findOne">
	<cfset local.query = FL_query(argumentCollection=arguments)>
	<cfset local.object = FL_new(local.query)>

	<cfif local.query.recordcount IS NOT 0>
		<cfset local.object.found = true>
	<cfelse>
		<cfset local.object.found = false>
	</cfif>

	<cfreturn local.object>
</cffunction>


<cffunction name="findAll" returntype="any" access="public" output="false">
	<cfargument name="select" type="any" required="false" default="">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="order" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="maxrows" type="any" required="false" default="-1">
	<cfargument name="page" type="any" required="false" default="">
	<cfargument name="per_page" type="any" required="false" default=10>
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="indexes" type="any" required="false" default="">
	<cfargument name="skip_param" type="any" required="false" default="">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfset var local = structNew()>

	<cfif len(arguments.page) IS NOT 0>
		<!--- count the total records (for use in paginationLinks) --->
		<cfset local.count_arguments = duplicate(arguments)>
		<cfif len(arguments.include) IS NOT 0>
			<cfset local.count_arguments.select = "COUNT(DISTINCT #variables.class.table_name#.#variables.class.primary_key#) AS total">
		<cfelse>
			<cfset local.count_arguments.select = "COUNT(#variables.class.table_name#.#variables.class.primary_key#) AS total">
		</cfif>
		<cfset local.count_arguments.order = "">
		<cfset local.count_arguments.page = "">
		<cfif isDefined("arguments.indexes.count")>
			<cfset local.count_arguments.indexes =  arguments.indexes.count>
		</cfif>
		<cfset local.count_arguments.FL_query_name = "pagination_count">
		<cfset local.count_query = FL_query(argumentCollection=local.count_arguments)>
		<cfset local.total_records = local.count_query.total>
		<cfset local.current_page = arguments.page>
		<cfif local.total_records IS 0>
			<cfset local.total_pages = 0>
		<cfelse>
			<cfset local.total_pages = ceiling(local.total_records/arguments.per_page)>
		</cfif>
		<cfif local.total_records LTE ((arguments.page * arguments.per_page) - arguments.per_page)>
			<cfset local.ids = 0>
		<cfelse>
			<!--- get the ids --->
			<cfset local.pagination_arguments = duplicate(arguments)>
			<cfset local.pagination_arguments.select = "#variables.class.table_name#.#variables.class.primary_key# AS primary_key">
			<cfset local.pagination_arguments.limit = arguments.per_page>
			<cfset local.pagination_arguments.offset = (arguments.per_page * arguments.page) - arguments.per_page>
			<cfif (local.pagination_arguments.limit + local.pagination_arguments.offset) GT local.total_records>
				<cfset local.pagination_arguments.limit = local.total_records - local.pagination_arguments.offset>
			</cfif>
			<cfif isDefined("arguments.indexes.ids")>
				<cfset local.pagination_arguments.indexes = arguments.indexes.ids>
			</cfif>
			<cfset local.pagination_arguments.FL_query_name = "pagination_ids">
			<cfset local.primary_keys = FL_query(argumentCollection=local.pagination_arguments)>
			<cfset local.ids = valueList(local.primary_keys.primary_key)>
		</cfif>
		<cfset arguments.where = "#variables.class.table_name#.#variables.class.primary_key# IN (#local.ids#)">
		<cfset arguments.soft_delete_check = false>
	</cfif>

	<cfset arguments.FL_query_name = "findAll">
	<cfset local.query = FL_query(argumentCollection=arguments)>

	<cfif len(arguments.page) IS NOT 0>
		<!--- store pagination info in the request scope so paginationlinks can access it --->
		<cfset request.wheels[arguments.handle] = structNew()>
		<cfset request.wheels[arguments.handle].current_page = local.current_page>
		<cfset request.wheels[arguments.handle].total_pages = local.total_pages>
		<cfset request.wheels[arguments.handle].total_records = local.total_records>
	</cfif>

	<cfreturn local.query>
</cffunction>


<cffunction name="FL_query" returntype="any" access="private" output="false">
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
	<cfargument name="soft_delete_check" type="any" required="false" default="true">
	<cfargument name="skip_param" type="any" required="false" default="">
	<cfargument name="reload" type="any" required="false" default="false">
	<cfargument name="FL_query_name" type="any" required="false" default="query">
	<cfset var local = structNew()>

	<!--- Remove parenthesis from date formatting to make it easier to parse --->
	<cfset arguments.where = replaceList(arguments.where, "'{ts ','}'", "','")>
	<cfset arguments.where = replaceList(arguments.where, "{ts ','}", "','")>

	<!--- replace values in the where argument with question marks so that we can cache it without the dynamic values --->
	<cfset local.regex = "((=|<>|<|>|<=|>=|!=|!<|!>| LIKE | IN) ?)(''|'.+?'()|([0-9]|\.)+()|\([0-9]+(,[0-9]+)*\))(($|\)| (AND|OR)))">
	<cfset local.paramed_where = arguments.where>
	<!--- match strings, numbers and lists --->
	<cfset local.paramed_where = REReplace(local.paramed_where, local.regex, "\1?\8" , "all")>

	<cfset local.paramed_arguments = structNew()>
	<cfset local.paramed_arguments.paramed_where = local.paramed_where>
	<cfset local.paramed_arguments.select = arguments.select>
	<cfset local.paramed_arguments.from = arguments.from>
	<cfset local.paramed_arguments.order = arguments.order>
	<cfset local.paramed_arguments.include = arguments.include>
	<cfset local.paramed_arguments.indexes = arguments.indexes>

 	<!--- get where, order, joins info etc from the cache (double-checked lock) --->
	<cfset local.category = "sql">
	<cfset local.key = "#variables.class.model_name#_#hashStruct(local.paramed_arguments)#">
	<cfset local.lock_name = local.category & local.key>
	<cflock name="#local.lock_name#" type="readonly" timeout="30">
		<cfset local.sql = getFromCache(local.key, local.category, "internal")>
	</cflock>

	<cfif isBoolean(local.sql) AND NOT local.sql>
   	<cflock name="#local.lock_name#" type="exclusive" timeout="30">
			<cfset local.sql = getFromCache(local.key, local.category, "internal")>
			<cfif isBoolean(local.sql) AND NOT local.sql>
				<!--- nothing was found in the cache so start figuring out where, order, joins clauses etc --->
				<cfset local.sql = structNew()>

				<!--- add where clause --->
				<cfset local.sql.where = "">
				<cfset local.where_fields = "">
				<cfif len(arguments.where) IS NOT 0>
					<!--- create a where clause which only consists of question marks for param references, AND/OR operators and parenthesis --->
					<cfset local.sql.where = local.paramed_where>
					<cfset local.sql.params = arrayNew(1)>
					<cfset local.sql.where = replaceList(local.sql.where, "AND,OR", "#chr(7)#AND,#chr(7)#OR")>
					<cfloop list="#local.sql.where#" delimiters="#chr(7)#" index="local.i">
						<cfset local.element = replace(local.i, chr(7), "", "one")>
						<cfif find("(", local.element) AND find(")", local.element)>
							<cfset local.element_data_part = reverse(spanExcluding(reverse(local.element), "("))>
							<cfset local.element_data_part = spanExcluding(local.element_data_part, ")")>
						<cfelseif find("(", local.element)>
							<cfset local.element_data_part = reverse(spanExcluding(reverse(local.element), "("))>
						<cfelseif find(")", local.element)>
							<cfset local.element_data_part = spanExcluding(local.element, ")")>
						<cfelse>
							<cfset local.element_data_part = local.element>
						</cfif>
						<cfset local.element_data_part = trim(replaceList(local.element_data_part, "AND,OR", ""))>
						<cfset local.param = structNew()>
						<cfset local.temp = REFind("^([^ ]*) ?(=|<>|<|>|<=|>=|!=|!<|!>| LIKE | IN)", local.element_data_part, 1, true)>
						<cfif arrayLen(local.temp.len) GT 1>
							<cfset local.sql.where = replace(local.sql.where, local.element, replace(local.element, local.element_data_part, "?", "one"))>
							<cfset local.param.field = mid(local.element_data_part, local.temp.pos[2], local.temp.len[2])>

							<cfif (local.param.field Contains "." AND listFirst(local.param.field, ".") IS variables.class.table_name OR local.param.field Does Not Contain ".") AND listFindNoCase(variables.class.field_list, listLast(local.param.field, ".")) IS NOT 0>
								<cfset local.param.field = variables.class.table_name & "." & listLast(local.param.field, ".")>
								<cfset local.param.cfsqltype = variables.class.columns[listLast(local.param.field, ".")].cfsqltype>
								<cfset local.param.field_name = listLast(local.param.field, ".")>
							<cfelseif (local.param.field Contains "." AND listFirst(local.param.field, ".") IS variables.class.table_name OR local.param.field Does Not Contain ".") AND listFindNoCase(variables.class.virtual_field_list, listLast(local.param.field, ".")) IS NOT 0>
								<cfset local.param.cfsqltype = variables.class.virtual_fields[listLast(local.param.field, ".")].cfsqltype>
								<cfset local.param.field_name = listLast(local.param.field, ".")>
								<cfset local.param.field = variables.class.virtual_fields[listLast(local.param.field, ".")].sql>
							<cfelse>
								<cfset local.temp = FL_extractFromAssociations(include=arguments.include, type="first_column_match_for_where", match=local.param.field)>
								<cfset local.param.field = local.temp.field>
								<cfset local.param.cfsqltype = local.temp.cfsqltype>
								<cfset local.param.field_name = local.temp.field_name>
							</cfif>
							<cfset local.temp = REFind("^[^ ]* ?(=|<>|<|>|<=|>=|!=|!<|!>| LIKE | IN)", local.element_data_part, 1, true)>
							<cfset local.param.operator = trim(mid(local.element_data_part, local.temp.pos[2], local.temp.len[2]))>
							<cfif local.param.operator IS "IN">
								<cfset local.param.list = true>
							<cfelse>
								<cfset local.param.list = false>
							</cfif>
							<cfset local.where_fields = listAppend(local.where_fields, local.param.field)>
							<cfset arrayAppend(local.sql.params, local.param)>
						</cfif>
					</cfloop>
					<cfset local.sql.where = replaceList(local.sql.where, "#chr(7)#AND,#chr(7)#OR", "AND,OR")>
				</cfif>

				<!--- add select clause --->
				<cfif len(arguments.select) IS NOT 0>
					<cfset local.sql.select = "">
					<cfloop list="#arguments.select#" index="local.i">
						<cfset local.i = trim(local.i)>
						<cfif arguments.select Does Not Contain " AS ">
							<cfif (local.i Contains "." AND listFirst(local.i, ".") IS variables.class.table_name OR local.i Does Not Contain ".") AND listFindNoCase(variables.class.field_list, listLast(local.i, ".")) IS NOT 0>
								<cfset local.i = variables.class.table_name & "." & listLast(local.i, ".")>
							<cfelseif (local.i Contains "." AND listFirst(local.i, ".") IS variables.class.table_name OR local.i Does Not Contain ".") AND listFindNoCase(variables.class.virtual_field_list, listLast(local.i, ".")) IS NOT 0>
								<cfset local.i = variables.class.virtual_fields[listLast(local.i, ".")].sql & " AS " & listLast(local.i, ".")>
							<cfelse>
								<cfset local.i = FL_extractFromAssociations(include=arguments.include, type="first_column_match_for_select", match=local.i)>
							</cfif>
						</cfif>
						<cfset local.sql.select = listAppend(local.sql.select, local.i, chr(7))>
					</cfloop>
				<cfelse>
					<cfset local.sql.select = "#variables.class.table_name#.#replace(variables.class.field_list, ',', '#chr(7)##variables.class.table_name#.', 'all')#">
					<cfif len(variables.class.virtual_field_list) IS NOT 0>
						<cfloop collection="#variables.class.virtual_fields#" item="local.i">
							<cfset local.sql.select = listAppend(local.sql.select, "#variables.class.virtual_fields[local.i].sql# AS #local.i#", chr(7))>
						</cfloop>
					</cfif>
					<cfif len(arguments.include) IS NOT 0>
						<cfset local.sql.select = local.sql.select & FL_extractFromAssociations(include=arguments.include, type="full_select_clause")>
					</cfif>
				</cfif>

				<!--- add order clause --->
				<cfset local.sql.order = "">
				<cfset local.sql.pagination.qualified_select = "">
				<cfset local.sql.pagination.simple_select = "">
				<cfset local.sql.pagination.qualified_order = "">
				<cfset local.sql.pagination.simple_order = "">
				<cfset local.sql.pagination.qualified_order_reversed = "">
				<cfset local.sql.pagination.simple_order_reversed = "">
				<cfif len(arguments.order) IS NOT 0>
					<cfif arguments.order IS "random">
						<cfif application.wheels.database.type IS "sqlserver">
							<cfset local.sql.order = "NEWID()">
						<cfelseif application.wheels.database.type IS "mysql">
							<cfset local.sql.order = "RAND()">
						</cfif>
					<cfelse>
						<cfloop list="#arguments.order#" index="local.i">
							<cfset local.i = trim(local.i)>
							<cfif local.i Does Not Contain " ASC" AND local.i Does Not Contain " DESC">
								<cfset local.i = local.i & " ASC">
							</cfif>
							<cfset local.sql.pagination.simple_order = listAppend(local.sql.pagination.simple_order, listLast(local.i, "."), chr(7))>
							<cfif (local.i Contains "." AND listFirst(local.i, ".") IS variables.class.table_name OR local.i Does Not Contain ".") AND listFindNoCase(variables.class.field_list, listLast(spanExcluding(local.i, " "), ".")) IS NOT 0>
								<cfset local.i = variables.class.table_name & "." & listLast(local.i, ".")>
							<cfelseif (local.i Contains "." AND listFirst(local.i, ".") IS variables.class.table_name OR local.i Does Not Contain ".") AND listFindNoCase(variables.class.virtual_field_list, listLast(spanExcluding(local.i, " "), ".")) IS NOT 0>
								<cfset local.i = replace(local.i, spanExcluding(local.i, " "), variables.class.virtual_fields[listLast(spanExcluding(local.i, " "), ".")].sql)>
							<cfelse>
								<cfset local.i = FL_extractFromAssociations(include=arguments.include, type="first_column_match_for_order", match=local.i)>
							</cfif>
							<cfset local.sql.order = listAppend(local.sql.order, local.i, chr(7))>
							<cfset local.sql.pagination.qualified_order = listAppend(local.sql.pagination.qualified_order, local.i, chr(7))>
						</cfloop>
						<!--- create a select string for pagination that has the primary key and all fields from the order clause --->
						<cfset local.sql.pagination.simple_select = REReplaceNoCase(local.sql.pagination.simple_order, " (asc|desc)", "", "all") & chr(7) & variables.class.primary_key>
						<cfset local.sql.pagination.qualified_select = REReplaceNoCase(local.sql.pagination.qualified_order, " (asc|desc)", "", "all") & chr(7) & variables.class.table_name & "." & variables.class.primary_key>
						<!--- delete the primary key from select if it is not the last element of the list (because it has to be last in the list and not duplicated) --->
						<cfif listFindNoCase(local.sql.pagination.simple_select, variables.class.primary_key, chr(7)) IS NOT listLen(local.sql.pagination.simple_select, chr(7))>
							<cfset local.sql.pagination.simple_select = listDeleteAt(local.sql.pagination.simple_select, listFindNoCase(local.sql.pagination.simple_select, variables.class.primary_key, chr(7)), chr(7))>
						</cfif>
						<cfif listFindNoCase(local.sql.pagination.qualified_select, "#variables.class.table_name#.#variables.class.primary_key#", chr(7)) IS NOT listLen(local.sql.pagination.qualified_select, chr(7))>
							<cfset local.sql.pagination.qualified_select = listDeleteAt(local.sql.pagination.qualified_select, listFindNoCase(local.sql.pagination.qualified_select, "#variables.class.table_name#.#variables.class.primary_key#", chr(7)), chr(7))>
						</cfif>
						<!--- add primary key to pagination order unless it is already there (to guarantee a unique order) --->
						<cfif REFindNoCase("#variables.class.table_name#.#variables.class.primary_key# (asc|desc)", local.sql.pagination.qualified_order) IS 0>
							<cfset local.sql.pagination.qualified_order = listAppend(local.sql.pagination.qualified_order, "#variables.class.table_name#.#variables.class.primary_key# ASC", chr(7))>
						</cfif>
						<cfif REFindNoCase("#variables.class.primary_key# (asc|desc)", local.sql.pagination.simple_order) IS 0>
							<cfset local.sql.pagination.simple_order = listAppend(local.sql.pagination.simple_order, "#variables.class.primary_key# ASC", chr(7))>
						</cfif>
						<!--- reverse the order for use in SQL Server pagination SQL --->
						<cfset local.sql.pagination.simple_order_reversed = replaceNoCase(replaceNoCase(replaceNoCase(local.sql.pagination.simple_order, "DESC", chr(164), "all"), "ASC", "DESC", "all"), chr(164), "ASC", "all")>
						<cfset local.sql.pagination.qualified_order_reversed = replaceNoCase(replaceNoCase(replaceNoCase(local.sql.pagination.qualified_order, "DESC", chr(164), "all"), "ASC", "DESC", "all"), chr(164), "ASC", "all")>
						<!--- loop through qualified select string and add "AS xxx" for all virtual fields --->
						<cfset local.pos = 0>
						<cfloop list="#local.sql.pagination.qualified_select#" index="local.i" delimiters="#chr(7)#">
							<cfset local.pos = local.pos + 1>
							<cfif REFindNoCase("^[a-z0-9-_]*\.#listGetAt(local.sql.pagination.simple_select, local.pos, chr(7))#$", local.i) IS 0>
								<cfset local.i = local.i & " AS " & listGetAt(local.sql.pagination.simple_select, local.pos, chr(7))>
							</cfif>
							<cfset local.sql.pagination.qualified_select = listSetAt(local.sql.pagination.qualified_select, local.pos, local.i, chr(7))>
						</cfloop>
					</cfif>
				</cfif>

				<!--- add from clause --->
				<cfset local.sql.from = variables.class.table_name>
				<cfif len(arguments.include) IS NOT 0>
					<cfset local.join_statements = FL_extractFromAssociations(include=arguments.include, type="join_statements")>
					<cfset local.join = " ">
					<cfloop from="#arrayLen(local.join_statements)#" to="1" step="-1" index="local.i">
						<cfset local.join = listAppend(local.join, local.join_statements[local.i], " ")>
					</cfloop>
					<cfloop from="1" to="#arrayLen(local.join_statements)#" index="local.i">
						<!--- loop from the back of the join string and remove if they are not referenced in select, where, order by and not further back in the join string --->
						<cfset local.table_name = spanExcluding(replace(local.join_statements[local.i], "LEFT OUTER JOIN ", "", "one"), " ")>
						<cfif local.sql.select Does Not Contain "#local.table_name#." AND local.where_fields Does Not Contain "#local.table_name#." AND local.sql.order Does Not Contain "#local.table_name#." AND findNoCase("#local.table_name#.", local.join, find(local.join_statements[local.i], local.join, 1)+len(local.join_statements[local.i])) IS 0>
							<cfset local.join = replace(local.join, " " & local.join_statements[local.i], "", "one")>
						</cfif>
					</cfloop>
					<cfset local.sql.from = local.sql.from & local.join>
				</cfif>

				<!--- add index hints (sql server only) --->
				<cfif isStruct(arguments.indexes)>
					<cfloop collection="#arguments.indexes#" item="local.i">
						<cfif left(local.sql.from, len(local.i)) IS local.i>
							<cfset local.sql.from = replaceNoCase(local.sql.from, local.i, "#lCase(local.i)# WITH (INDEX(#arguments.indexes[local.i]#))", "one")>
						<cfelseif local.sql.from Contains " #local.i# ">
							<cfset local.sql.from = replaceNoCase(local.sql.from, " #local.i# ", " #lCase(local.i)# WITH (INDEX(#arguments.indexes[local.i]#))", "one")>
						</cfif>
					</cfloop>
				</cfif>

				<!--- cache all the info so we don't have to do all this again for every single query --->
				<cfset addToCache(local.key, local.sql, 86400, local.category, "internal")>

			</cfif>
		</cflock>
	</cfif>

	<cfif len(local.sql.where) IS NOT 0>
		<!--- Add the original values from the where clause to an array --->
		<cfset local.start = 1>
		<cfset arguments.param_values = arrayNew(1)>
		<cfloop from="1" to="#arrayLen(local.sql.params)#" index="local.i">
			<cfset local.temp = REFind(local.regex, arguments.where, local.start, true)>
			<cfif arrayLen(local.temp.pos) IS 1>
				<!--- nothing found, add a blank value --->
				<cfset local.start = local.start + 1>
				<cfset arrayAppend(arguments.param_values, "")>
			<cfelse>
				<cfset local.start = local.temp.pos[4] + local.temp.len[4]>
				<!--- strip out ', ", ( and ) characters if they are at the start or end of the string and add to array --->
				<cfset arrayAppend(arguments.param_values, replaceList(chr(7) & mid(arguments.where, local.temp.pos[4], local.temp.len[4]) & chr(7), "#chr(7)#(,)#chr(7)#,#chr(7)#','#chr(7)#,#chr(7)#"",""#chr(7)#,#chr(7)#", ",,,,,,"))>
			</cfif>
		</cfloop>
	</cfif>

	<cfset arguments.sql = local.sql>

	<cfif application.settings.cache_queries AND (isNumeric(arguments.cache) OR (isBoolean(arguments.cache) AND arguments.cache))>
		<cfset local.category = "query">
		<cfset local.key = "#variables.class.model_name#_#hashStruct(arguments)#">
		<cfset local.lock_name = local.category & local.key>
		<cflock name="#local.lock_name#" type="readonly" timeout="30">
			<cfset local.query = getFromCache(local.key, local.category)>
		</cflock>
		<cfif isBoolean(local.query) AND NOT local.query>
	   	<cflock name="#local.lock_name#" type="exclusive" timeout="30">
				<cfset local.query = getFromCache(local.key, local.category)>
				<cfif isBoolean(local.query) AND NOT local.query>
					<cfset local.query = FL_executeQuery(argumentCollection=arguments)>
					<cfif NOT isNumeric(arguments.cache)>
						<cfset arguments.cache = application.settings.caching.queries>
					</cfif>
					<cfset addToCache(local.key, local.query, arguments.cache, local.category)>
				</cfif>
			</cflock>
		</cfif>
	<cfelse>
		<cfset local.query = FL_executeQuery(argumentCollection=arguments)>
	</cfif>

	<cfreturn local.query>
</cffunction>


<cffunction name="FL_executeQuery" returntype="any" access="private" output="false">
	<cfset var locals = structNew()>
	<cfset arguments.sql.order = listChangeDelims(arguments.sql.order, ",", chr(7))>
	<cfset arguments.sql.select = listChangeDelims(arguments.sql.select, ",", chr(7))>
	<cfset arguments.sql.pagination.simple_select = listChangeDelims(arguments.sql.pagination.simple_select, ",", chr(7))>
	<cfset arguments.sql.pagination.qualified_select = listChangeDelims(arguments.sql.pagination.qualified_select, ",", chr(7))>
	<cfset arguments.sql.pagination.simple_order = listChangeDelims(arguments.sql.pagination.simple_order, ",", chr(7))>
	<cfset arguments.sql.pagination.qualified_order = listChangeDelims(arguments.sql.pagination.qualified_order, ",", chr(7))>
	<cfset arguments.sql.pagination.simple_order_reversed = listChangeDelims(arguments.sql.pagination.simple_order_reversed, ",", chr(7))>
	<cfset arguments.sql.pagination.qualified_order_reversed = listChangeDelims(arguments.sql.pagination.qualified_order_reversed, ",", chr(7))>

	<cfif application.settings.show_debug_information>
		<cfset locals.query_start_time = getTickCount()>
	</cfif>

	<cfset locals.key = FL_hashArguments(arguments)>
	<cfif NOT arguments.reload AND isDefined("request.wheels.cache") AND structKeyExists(request.wheels.cache, locals.key)>
		<cfset locals.query = request.wheels.cache[locals.key]>
	<cfelse>
		<cfif structKeyExists(variables.class.columns, "deleted_at") OR structKeyExists(variables.class.columns, "deleted_on")>
			<cfset locals.soft_delete = true>
			<cfif structKeyExists(variables.class.columns, "deleted_at")>
				<cfset locals.soft_delete_field = "deleted_at">
			<cfelseif structKeyExists(variables.class.columns, "deleted_on")>
				<cfset locals.soft_delete_field = "deleted_on">
			</cfif>
		<cfelse>
			<cfset locals.soft_delete = false>
		</cfif>
		<cfquery name="locals.query" datasource="#application.settings.dsn#" timeout="#application.settings.query_timeout#" username="#application.settings.username#" password="#application.settings.password#">
		<cfif application.wheels.database.type IS "sqlserver" AND len(arguments.limit) IS NOT 0 AND len(arguments.offset) IS NOT 0>
		SELECT #preserveSingleQuotes(arguments.sql.pagination.simple_select)# AS primary_key
		FROM (
			SELECT TOP #arguments.limit# #preserveSingleQuotes(arguments.sql.pagination.simple_select)#
			FROM (
				SELECT <cfif arguments.sql.from Contains " ">DISTINCT </cfif>TOP #(arguments.limit + arguments.offset)# #preserveSingleQuotes(arguments.sql.pagination.qualified_select)#
				FROM #arguments.sql.from#
		<cfelse>
			SELECT <cfif application.wheels.database.type IS "sqlserver" AND arguments.maxrows GT 0>TOP #arguments.maxrows# </cfif>#preserveSingleQuotes(arguments.sql.select)#
			FROM #arguments.sql.from#
		</cfif>
		<cfif len(arguments.sql.where) IS NOT 0>
			WHERE
			<cfif arguments.soft_delete_check AND locals.soft_delete AND arguments.where Contains " OR ">
				(
			</cfif>
			<cfset locals.pos = 0>
			<cfset arguments.sql.where = " #arguments.sql.where# ">
			<cfloop list="#arguments.sql.where#" delimiters="?" index="locals.i">
				<cfset locals.pos = locals.pos + 1>
				#locals.i#
				<cfif locals.pos LT listLen(arguments.sql.where, "?")>
					<cfset locals.temp_field = arguments.sql.params[locals.pos].field>
					#preserveSingleQuotes(locals.temp_field)#
					#arguments.sql.params[locals.pos].operator#
					<cfif arguments.sql.params[locals.pos].list>
						(
					</cfif>
					<cfif len(arguments.skip_param) IS NOT 0 AND listFindNoCase(arguments.skip_param, arguments.sql.params[locals.pos].field_name)>
						<cfif arguments.sql.params[locals.pos].cfsqltype IS "cf_sql_varchar" OR arguments.sql.params[locals.pos].cfsqltype IS "cf_sql_longvarchar">
							'#arguments.param_values[locals.pos]#'
						<cfelse>
							#arguments.param_values[locals.pos]#
						</cfif>
					<cfelse>
						<cfqueryparam cfsqltype="#arguments.sql.params[locals.pos].cfsqltype#" list="#arguments.sql.params[locals.pos].list#" value="#arguments.param_values[locals.pos]#">
					</cfif>
					<cfif arguments.sql.params[locals.pos].list>
						)
					</cfif>
				</cfif>
			</cfloop>
			<cfif arguments.soft_delete_check AND locals.soft_delete>
				<cfif arguments.where Contains " OR ">
					)
				</cfif>
				AND #variables.class.table_name#.#locals.soft_delete_field# IS NULL
			</cfif>
		<cfelse>
			<cfif arguments.soft_delete_check AND locals.soft_delete>
				WHERE #variables.class.table_name#.#locals.soft_delete_field# IS NULL
			</cfif>
		</cfif>
		<cfif application.wheels.database.type IS "sqlserver" AND len(arguments.limit) IS NOT 0 AND len(arguments.offset) IS NOT 0>
				ORDER BY #preserveSingleQuotes(arguments.sql.pagination.qualified_order)#) AS tmp1
			ORDER BY #preserveSingleQuotes(arguments.sql.pagination.simple_order_reversed)#) AS tmp2
		ORDER BY #preserveSingleQuotes(arguments.sql.pagination.simple_order)#
		<cfelse>
			<cfif len(arguments.sql.order) IS NOT 0>
				ORDER BY #preserveSingleQuotes(arguments.sql.order)#
			</cfif>
		</cfif>
		<cfif application.wheels.database.type IS "mysql">
			<cfif arguments.maxrows GT 1>
				LIMIT #arguments.maxrows#
			<cfelseif len(arguments.limit) IS NOT 0>
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

	<cfif application.settings.show_debug_information AND isDefined("request.wheels")>
		<cfset locals.query_total_time = getTickCount() - locals.query_start_time>
		<cfset request.wheels.execution.query_total = request.wheels.execution.query_total + locals.query_total_time>
		<cfset "request.wheels.execution.queries.#arguments.FL_query_name#" = locals.query_total_time>
	</cfif>

	<cfreturn locals.query>
</cffunction>


<cffunction name="FL_extractFromAssociations" returntype="any" access="private" output="false">
	<cfargument name="include" type="any" required="true">
	<cfargument name="type" type="any" required="true">
	<cfargument name="match" type="any" required="false" default="">
	<cfset var local = structNew()>

	<!--- setup the initial return data value --->
	<cfif arguments.type IS "join_statements">
		<cfset local.return_data = arrayNew(1)>
	<cfelse>
		<cfset local.return_data = "">
	</cfif>

	<!--- add the current model name so that the levels list start at the lowest level --->
	<cfset local.levels = getModelName()>

	<!--- count the included associations --->
	<cfset local.loop_count = listLen(replace(arguments.include, "(", ",", "all"))>

	<!--- clean up spaces in list and add a , at the end to indicate end of string --->
	<cfset local.include = replace(arguments.include, " ", "", "all") & ",">

	<cfset local.pos = 1>
	<cfloop from="1" to="#local.loop_count#" index="local.i">

		<!--- look for the next delimiter in the string and set it --->
		<cfset local.delim_pos = findOneOf("(),", local.include, local.pos)>
		<cfset local.delim_char = mid(local.include, local.delim_pos, 1)>

		<!--- set current association name and set new position to start search in the next loop (association names have to start with a letter) --->
		<cfset local.name = mid(local.include, local.pos, local.delim_pos-local.pos)>
		<cfset local.pos = REFindNoCase("[a-z]", local.include, local.delim_pos)>

		<!--- get a reference to the current model and get their associations --->
		<cfset local.model = model(listLast(local.levels))>
		<cfset local.model_associations = local.model.getAssociations()>
		<cfset local.associated_table_name = local.model_associations[local.name].associated_table_name>
		<cfset local.associated_model = model(local.model_associations[local.name].associated_model_name)>
		<cfset local.field_list = local.associated_model.getFieldList()>
		<cfset local.fields = local.associated_model.getFields()>
		<cfset local.virtual_field_list = local.associated_model.getVirtualFieldList()>
		<cfset local.virtual_fields = local.associated_model.getVirtualFields()>

		<!--- Get the requested data --->
		<cfif arguments.type IS "full_select_clause">
			<cfset local.return_data = "#local.return_data##chr(7)##local.associated_table_name#.#replace(local.associated_model.getFieldList(), ',', '#chr(7)##local.associated_table_name#.', 'all')#">
			<cfif len(local.virtual_field_list) IS NOT 0>
				<cfloop collection="#local.virtual_fields#" item="local.i">
					<cfset local.return_data = listAppend(local.return_data, "#local.virtual_fields[local.i].sql# AS #local.i#", chr(7))>
				</cfloop>
			</cfif>

		<cfelseif arguments.type IS "first_column_match_for_select">
			<cfif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS local.associated_table_name OR arguments.match Does Not Contain ".") AND listFindNoCase(local.field_list, listLast(arguments.match, ".")) IS NOT 0>
				<cfreturn local.associated_table_name & "." & listLast(arguments.match, ".")>
			<cfelseif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS local.associated_table_name OR arguments.match Does Not Contain ".") AND listFindNoCase(local.virtual_field_list, listLast(arguments.match, ".")) IS NOT 0>
				<cfreturn local.virtual_fields[listLast(arguments.match, ".")].sql & " AS " & listLast(arguments.match, ".")>
			</cfif>

		<cfelseif arguments.type IS "first_column_match_for_order">
			<cfif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS local.associated_table_name OR arguments.match Does Not Contain ".") AND listFindNoCase(local.field_list, listLast(spanExcluding(arguments.match, " "), ".")) IS NOT 0>
				<cfreturn local.associated_table_name & "." & listLast(arguments.match, ".")>
			<cfelseif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS local.associated_table_name OR arguments.match Does Not Contain ".") AND listFindNoCase(local.virtual_field_list, listLast(spanExcluding(arguments.match, " "), ".")) IS NOT 0>
				<cfreturn replace(arguments.match, spanExcluding(arguments.match, " "), local.virtual_fields[listLast(spanExcluding(arguments.match, " "), ".")].sql)>
			</cfif>

		<cfelseif arguments.type IS "first_column_match_for_where">
			<cfset local.return_data = structNew()>
			<cfif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS local.associated_table_name OR arguments.match Does Not Contain ".") AND listFindNoCase(local.field_list, listLast(arguments.match, ".")) IS NOT 0>
				<cfset local.return_data.cfsqltype = local.fields[listLast(arguments.match, ".")].cfsqltype>
				<cfset local.return_data.field_name = listLast(arguments.match, ".")>
				<cfset local.return_data.field = local.associated_table_name & "." & listLast(arguments.match, ".")>
				<cfreturn local.return_data>
			<cfelseif (arguments.match Contains "." AND listFirst(arguments.match, ".") IS local.associated_table_name OR arguments.match Does Not Contain ".") AND listFindNoCase(local.virtual_field_list, listLast(arguments.match, ".")) IS NOT 0>
				<cfset local.return_data.cfsqltype = local.virtual_fields[listLast(arguments.match, ".")].cfsqltype>
				<cfset local.return_data.field_name = listLast(arguments.match, ".")>
				<cfset local.return_data.field = local.virtual_fields[listLast(arguments.match, ".")].sql>
				<cfreturn local.return_data>
			</cfif>

		<cfelseif arguments.type IS "join_statements">
			<cfset arrayPrepend(local.return_data, local.model_associations[local.name].join_string)>
		</cfif>

		<cfif local.delim_char IS "(">
			<!--- we're going up one level in the association tree so add the associated model's name to the list --->
			<cfset local.levels = listAppend(local.levels, local.model_associations[local.name].associated_model_name)>
		<cfelseif local.delim_char IS ")">
			<!--- we're going down one level in the association tree so remove the last model name added --->
			<cfset local.levels = listDeleteAt(local.levels, listLen(local.levels))>
		</cfif>

	</cfloop>

	<cfreturn local.return_data>
</cffunction>
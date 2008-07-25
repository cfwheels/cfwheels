<cfcomponent output="false">

	<cffunction name="generatedKey" returntype="string" access="public" output="false">
		<cfreturn "identitycol">
	</cffunction>

	<cffunction name="randomOrder" returntype="string" access="public" output="false">
		<cfreturn "NEWID()">
	</cffunction>

	<cffunction name="getType" returntype="string" access="public" output="false">
		<cfargument name="type" type="string" required="true">
		<cfscript>
			var loc = {};
			switch(arguments.type)
			{
				case "bit": {loc.returnValue = "cf_sql_bit"; break;}
				case "binary": case "timestamp": {loc.returnValue = "cf_sql_binary"; break;}
				case "char": case "nchar": case "uniqueidentifier": {loc.returnValue = "cf_sql_char"; break;}
				case "decimal": case "money": case "smallmoney": {loc.returnValue = "cf_sql_decimal"; break;}
				case "float": {loc.returnValue = "cf_sql_float"; break;}
				case "int": {loc.returnValue = "cf_sql_integer";	break;}
				case "image": {loc.returnValue = "cf_sql_longvarbinary"; break;}
				case "text":	case "ntext": {loc.returnValue = "cf_sql_longvarchar";	break;}
				case "numeric":	{loc.returnValue = "cf_sql_numeric"; break;}
				case "real":	{loc.returnValue = "cf_sql_real"; break;}
				case "smallint":	{loc.returnValue = "cf_sql_smallint"; break;}
				case "datetime": case "smalldatetime": {loc.returnValue = "cf_sql_timestamp"; break;}
				case "tinyint":	{loc.returnValue = "cf_sql_tinyint"; break;}
				case "varbinary":	{loc.returnValue = "cf_sql_varbinary"; break;}
				case "varchar": case "nvarchar": {loc.returnValue = "cf_sql_varchar"; break;}
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="query" returntype="struct" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfargument name="limit" type="numeric" required="false" default=0>
		<cfargument name="offset" type="numeric" required="false" default=0>
		<cfargument name="parameterize" type="any" required="true">
		<cfset var loc = StructNew()>
		<cfset var query = StructNew()>

<!---
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
				<cfset local.i = CFW_extractFromAssociations(include=arguments.include, type="first_column_match_for_order", match=local.i)>
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

		<cfquery name="locals.query" datasource="#variables.class.database.read.datasource#" username="#variables.class.database.read.username#" password="#variables.class.database.read.password#" timeout="#variables.class.database.read.timeout#">

			<!--- SELECT and FROM clauses --->
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

			<!--- WHERE clause --->
			<cfif (len(arguments.sql.where) IS NOT 0) OR (arguments.soft_delete_check AND locals.soft_delete) OR (len(arguments.literal_where) IS NOT 0)>
				WHERE
			</cfif>

			<cfset locals.where_exists = false>
			<cfif len(arguments.sql.where) IS NOT 0>
				(
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
				)
				<cfset locals.where_exists = true>
			</cfif>

			<cfif arguments.soft_delete_check AND locals.soft_delete>
				<cfif locals.where_exists>
					AND
				</cfif>
				(#variables.class.table_name#.#locals.soft_delete_field# IS NULL)
				<cfset locals.where_exists = true>
			</cfif>

			<cfif len(arguments.literal_where) IS NOT 0>
				<cfif locals.where_exists>
					AND
				</cfif>
				(#arguments.literal_where#)
			</cfif>

			<!--- ORDER BY, LIMIT and OFFSET clauses --->
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

 --->

		<cfif arguments.limit GT 0>
			<cfdump var="#arguments#">
			<cfset loc.select = ReplaceNoCase(arguments.sql[1], "SELECT ", "")>
			<cfset loc.qualifiedOrder = ReplaceNoCase(arguments.sql[ArrayLen(arguments.sql)], "ORDER BY ", "")>
			<cfloop list="#loc.select#" index="loc.i">
				<cfif ListContainsNoCase(loc.qualifiedOrder, loc.i) IS 0>
					<cfset loc.qualifiedOrder = ListAppend(loc.qualifiedOrder, "#loc.i# ASC")>
				</cfif>
			</cfloop>
			<cfset loc.simpleOrder = "">
			<cfloop list="#loc.qualifiedOrder#" index="loc.i">
				<cfset loc.simpleOrder = ListAppend(loc.simpleOrder, ListLast(loc.i, "."))>
			</cfloop>
			<cfset loc.simpleOrderReversed = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(loc.simpleOrder, "DESC", chr(7), "all"), "ASC", "DESC", "all"), chr(7), "ASC", "all")>
			<cfset loc.qualifiedOrderReversed = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(loc.qualifiedOrder, "DESC", chr(7), "all"), "ASC", "DESC", "all"), chr(7), "ASC", "all")>
			<cfset loc.simpleSelect = ReplaceNoCase(ReplaceNoCase(loc.simpleOrder, " DESC", "", "all"), " ASC", "", "all")>
			<cfset loc.qualifiedSelect = ReplaceNoCase(ReplaceNoCase(loc.qualifiedOrder, " DESC", "", "all"), " ASC", "", "all")>
			<cfdump var="#loc#">
			<cfabort>
		</cfif>

		<cfset arguments.name = "query.name">
		<cfset arguments.result = "loc.result">
		<cfset arguments.datasource = application.settings.database.datasource>
		<cfset arguments.username = application.settings.database.username>
		<cfset arguments.password = application.settings.database.password>
		<cfset loc.sql = arguments.sql>
		<cfset loc.limit = arguments.limit>
		<cfset loc.offset = arguments.offset>
		<cfset loc.parameterize = arguments.parameterize>
		<cfset StructDelete(arguments, "sql")>
		<cfset StructDelete(arguments, "limit")>
		<cfset StructDelete(arguments, "offset")>
		<cfset StructDelete(arguments, "parameterize")>
		<!--- name="#arguments.name#" --->
		<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif (IsBoolean(loc.parameterize) AND loc.parameterize) OR (NOT IsBoolean(loc.parameterize) AND ListFindNoCase(loc.parameterize, loc.i.property))><cfqueryparam cfsqltype="#loc.i.type#" value="#loc.i.value#"><cfelse>'#loc.i.value#'</cfif><cfelse>#preserveSingleQuotes(loc.i)#</cfif>#chr(13)##chr(10)#</cfloop></cfquery>
		<cfset loc.returnValue.result = loc.result>
		<cfif StructKeyExists(query, "name")>
			<cfset loc.returnValue.query = query.name>
		</cfif>
		<cfreturn loc.returnValue>
	</cffunction>

</cfcomponent>
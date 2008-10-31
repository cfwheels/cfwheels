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
			case "bigint": {loc.returnValue = "cf_sql_bigint"; break;}
			case "binary": case "timestamp": {loc.returnValue = "cf_sql_binary"; break;}
			case "bit": {loc.returnValue = "cf_sql_bit"; break;}
			case "char": case "nchar": case "uniqueidentifier": {loc.returnValue = "cf_sql_char"; break;}
			case "date": {loc.returnValue = "cf_sql_date"; break;}
			case "decimal": case "money": case "smallmoney": {loc.returnValue = "cf_sql_decimal"; break;}
			case "float": {loc.returnValue = "cf_sql_float"; break;}
			case "int": {loc.returnValue = "cf_sql_integer";	break;}
			case "image": {loc.returnValue = "cf_sql_longvarbinary"; break;}
			case "text": case "ntext": {loc.returnValue = "cf_sql_longvarchar";	break;}
			case "numeric":	{loc.returnValue = "cf_sql_numeric"; break;}
			case "real": {loc.returnValue = "cf_sql_real"; break;}
			case "smallint": {loc.returnValue = "cf_sql_smallint"; break;}
			case "datetime": case "smalldatetime": {loc.returnValue = "cf_sql_timestamp"; break;}
			case "tinyint":	{loc.returnValue = "cf_sql_tinyint"; break;}
			case "varbinary": {loc.returnValue = "cf_sql_varbinary"; break;}
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

	<cfif arguments.limit GT 0>
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
		<cfset loc.beforeWhere = "SELECT " & loc.simpleSelect & " FROM (SELECT TOP " & arguments.limit & " " & loc.simpleSelect & " FROM (SELECT ">
		<cfif ListLast(arguments.sql[2], " ") Contains " ">
			<cfset loc.beforeWhere = loc.beforeWhere & "DISTINCT ">
		</cfif>
		<cfset loc.beforeWhere = loc.beforeWhere & "TOP " & arguments.limit+arguments.offset & " " & loc.qualifiedSelect & " " & arguments.sql[2]>
		<cfset loc.afterWhere = "ORDER BY " & loc.qualifiedOrder & ") AS tmp1 ORDER BY " & loc.simpleOrderReversed & ") AS tmp2 ORDER BY " & loc.simpleOrder>
		<cfset ArrayDeleteAt(arguments.sql, 1)>
		<cfset ArrayDeleteAt(arguments.sql, 1)>
		<cfset ArrayDeleteAt(arguments.sql, ArrayLen(arguments.sql))>
		<cfset ArrayPrepend(arguments.sql, loc.beforeWhere)>
		<cfset ArrayAppend(arguments.sql, loc.afterWhere)>
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
	<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif (IsBoolean(loc.parameterize) AND loc.parameterize) OR (NOT IsBoolean(loc.parameterize) AND ListFindNoCase(loc.parameterize, loc.i.property))><cfset loc.queryParamAttributes = StructNew()><cfset loc.queryParamAttributes.cfsqltype = loc.i.type><cfset loc.queryParamAttributes.value = loc.i.value><cfif StructKeyExists(loc.i, "null")><cfset loc.queryParamAttributes.null = loc.i.null></cfif><cfif loc.i.type IS "cf_sql_numeric" OR loc.i.type IS "cf_sql_decimal"><cfset loc.queryParamAttributes.scale = loc.i.scale></cfif><cfqueryparam attributeCollection="#loc.queryParamAttributes#"><cfelse>'#loc.i.value#'</cfif><cfelse>#preserveSingleQuotes(loc.i)#</cfif>#chr(13)##chr(10)#</cfloop></cfquery>
	<cfset loc.returnValue.result = loc.result>
	<cfif StructKeyExists(query, "name")>
		<cfset loc.returnValue.query = query.name>
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>

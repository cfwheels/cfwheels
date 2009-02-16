<cffunction name="generatedKey" returntype="string" access="public" output="false">
	<cfreturn "rowid">
</cffunction>

<cffunction name="randomOrder" returntype="string" access="public" output="false">
	<cfreturn "dbms_random.value()">
</cffunction>

<cffunction name="getType" returntype="string" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.type = Replace(arguments.type, "()", "");
		switch(loc.type)
		{
			case "blob": case "bfile": {loc.returnValue = "cf_sql_blob"; break;}
			case "char": case "nchar": {loc.returnValue = "cf_sql_char"; break;}
			case "clob": case "nclob": {loc.returnValue = "cf_sql_clob"; break;}
			case "date": case "timestamp": {loc.returnValue = "cf_sql_timestamp"; break;}
			case "binary_double": {loc.returnValue = "cf_sql_double"; break;}
			case "number": case "float": case "binary_float": {loc.returnValue = "cf_sql_float"; break;}
			case "long": {loc.returnValue = "cf_sql_longvarchar"; break;}
			case "raw": {loc.returnValue = "cf_sql_varbinary"; break;}
			case "varchar2": case "nvarchar2": {loc.returnValue = "cf_sql_varchar"; break;}
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
		<cfset loc.beforeWhere = "SELECT * FROM (SELECT a.*, rownum rnum FROM (">
		<cfset loc.afterWhere = ") a WHERE rownum <=" & arguments.limit+arguments.offset & ")" & " WHERE rnum >" & arguments.offset>
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

<cffunction name="generatedKey" returntype="string" access="public" output="false">
	<cfreturn "generated_key">
</cffunction>

<cffunction name="randomOrder" returntype="string" access="public" output="false">
	<cfreturn "RAND()">
</cffunction>

<cffunction name="getType" returntype="string" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.type = Replace(arguments.type, "()", "");
		switch(loc.type)
		{
			case "bigint": {loc.returnValue = "cf_sql_bigint"; break;}
			case "binary": {loc.returnValue = "cf_sql_binary"; break;}
			case "bit": case "bool": {loc.returnValue = "cf_sql_bit";	break;}
			case "blob": case "tinyblob": case "mediumblob": case "longblob": {loc.returnValue = "cf_sql_blob";	break;}
			case "char": {loc.returnValue = "cf_sql_char"; break;}
			case "date": {loc.returnValue = "cf_sql_date"; break;}
			case "decimal": {loc.returnValue = "cf_sql_decimal"; break;}
			case "double": {loc.returnValue = "cf_sql_double"; break;}
			case "float": {loc.returnValue = "cf_sql_float"; break;}
			case "int": case "mediumint": {loc.returnValue = "cf_sql_integer"; break;}
			case "smallint": case "year": {loc.returnValue = "cf_sql_smallint"; break;}
			case "time": {loc.returnValue = "cf_sql_time"; break;}
			case "datetime": case "timestamp": {loc.returnValue = "cf_sql_timestamp"; break;}
			case "tinyint": {loc.returnValue = "cf_sql_tinyint"; break;}
			case "varbinary": {loc.returnValue = "cf_sql_varbinary"; break;}
			case "varchar": case "text": case "mediumtext": case "longtext": case "tinytext": case "enum": case "set": {loc.returnValue = "cf_sql_varchar"; break;}
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
	<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif (IsBoolean(loc.parameterize) AND loc.parameterize) OR (NOT IsBoolean(loc.parameterize) AND ListFindNoCase(loc.parameterize, loc.i.property))><cfset loc.queryParamAttributes = StructNew()><cfset loc.queryParamAttributes.cfsqltype = loc.i.type><cfset loc.queryParamAttributes.value = loc.i.value><cfif StructKeyExists(loc.i, "null")><cfset loc.queryParamAttributes.null = loc.i.null></cfif><cfif loc.i.type IS "cf_sql_numeric" OR loc.i.type IS "cf_sql_decimal"><cfset loc.queryParamAttributes.scale = loc.i.scale></cfif><cfqueryparam attributeCollection="#loc.queryParamAttributes#"><cfelse>'#loc.i.value#'</cfif><cfelse>#preserveSingleQuotes(loc.i)#</cfif>#chr(13)##chr(10)#</cfloop><cfif loc.limit>LIMIT #loc.limit#<cfif loc.offset>#chr(13)##chr(10)#OFFSET #loc.offset#</cfif></cfif></cfquery>
	<cfset loc.returnValue.result = loc.result>
	<cfif StructKeyExists(query, "name")>
		<cfset loc.returnValue.query = query.name>
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>

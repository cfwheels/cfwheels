<cfcomponent output="false">

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
			switch(arguments.type)
			{
				case "number": {loc.returnValue = "cf_sql_float"; break;}
				case "varchar2": case "nvarchar2": {loc.returnValue = "cf_sql_varchar"; break;}
				case "date": {loc.returnValue = "cf_sql_timestamp"; break;}
				case "timestamp": {loc.returnValue = "cf_sql_date"; break;}
				case "char": {loc.returnValue = "cf_sql_char"; break;}
				case "clob": {loc.returnValue = "cf_sql_clob"; break;}
				case "blob": {loc.returnValue = "cf_sql_blob"; break;}
				case "binary_float": {loc.returnValue = "cf_sql_float"; break;}
				case "binary_double": {loc.returnValue = "cf_sql_double"; break;}
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
		<!--- name="#arguments.name#" --->
		<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif (IsBoolean(loc.parameterize) AND loc.parameterize) OR (NOT IsBoolean(loc.parameterize) AND ListFindNoCase(loc.parameterize, loc.i.property))><cfqueryparam cfsqltype="#loc.i.type#" value="#loc.i.value#"><cfelse>'#loc.i.value#'</cfif><cfelse>#preserveSingleQuotes(loc.i)#</cfif>#chr(13)##chr(10)#</cfloop></cfquery>
		<cfset loc.returnValue.result = loc.result>
		<cfif StructKeyExists(query, "name")>
			<cfset loc.returnValue.query = query.name>
		</cfif>
		<cfreturn loc.returnValue>
	</cffunction>

</cfcomponent>
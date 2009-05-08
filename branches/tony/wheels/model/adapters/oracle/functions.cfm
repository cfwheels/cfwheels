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
	<cfargument name="parameterize" type="boolean" required="true">
	<cfscript>
		var loc = {};
		var query = {};
		if (arguments.limit > 0)
		{
			loc.beforeWhere = "SELECT * FROM (SELECT a.*, rownum rnum FROM (";
			loc.afterWhere = ") a WHERE rownum <=" & arguments.limit+arguments.offset & ")" & " WHERE rnum >" & arguments.offset;
			ArrayPrepend(arguments.sql, loc.beforeWhere);
			ArrayAppend(arguments.sql, loc.afterWhere);
		}
		arguments.name = "query.name";
		arguments.result = "loc.result";
		arguments.datasource = variables.instance.connection.datasource;
		arguments.username = variables.instance.connection.username;
		arguments.password = variables.instance.connection.password;
		loc.sql = arguments.sql;
		loc.limit = arguments.limit;
		loc.offset = arguments.offset;
		loc.parameterize = arguments.parameterize;
		StructDelete(arguments, "sql");
		StructDelete(arguments, "limit");
		StructDelete(arguments, "offset");
		StructDelete(arguments, "parameterize");
	</cfscript>
	<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif IsBoolean(loc.parameterize) AND loc.parameterize><cfset loc.queryParamAttributes = StructNew()><cfset loc.queryParamAttributes.cfsqltype = loc.i.type><cfset loc.queryParamAttributes.value = loc.i.value><cfif StructKeyExists(loc.i, "null")><cfset loc.queryParamAttributes.null = loc.i.null></cfif><cfif StructKeyExists(loc.i, "scale") AND loc.i.scale GT 0><cfset loc.queryParamAttributes.scale = loc.i.scale></cfif><cfqueryparam attributeCollection="#loc.queryParamAttributes#"><cfelse>'#loc.i.value#'</cfif><cfelse>#preserveSingleQuotes(loc.i)#</cfif>#chr(13)##chr(10)#</cfloop></cfquery>
	<cfscript>
		loc.returnValue.result = loc.result;
		if (StructKeyExists(query, "name"))
			loc.returnValue.query = query.name;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>
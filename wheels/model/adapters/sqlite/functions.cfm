<cffunction name="$generatedKey" returntype="string" access="public" output="false">
	<cfreturn "generated_key">
</cffunction>

<cffunction name="$randomOrder" returntype="string" access="public" output="false">
	<cfreturn "RANDOM()">
</cffunction>

<cffunction name="$getType" returntype="string" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		switch(arguments.type)
		{
			case "blob": {loc.returnValue = "cf_sql_blob"; break;}
			case "boolean": {loc.returnValue = "cf_sql_bit"; break;}
			case "char": {loc.returnValue = "cf_sql_char"; break;}
			case "date": {loc.returnValue = "cf_sql_date"; break;}
			case "datetime": {loc.returnValue = "cf_sql_timestamp"; break;}
			case "int": case "integer": {loc.returnValue = "cf_sql_integer"; break;}
			case "numeric": {loc.returnValue = "cf_sql_numeric"; break;}
			case "real": {loc.returnValue = "cf_sql_real"; break;}
			case "varchar": case "text": {loc.returnValue = "cf_sql_varchar"; break;}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$query" returntype="struct" access="public" output="false">
	<cfargument name="sql" type="array" required="true">
	<cfargument name="limit" type="numeric" required="false" default=0>
	<cfargument name="offset" type="numeric" required="false" default=0>
	<cfargument name="parameterize" type="boolean" required="true">
	<cfargument name="$primaryKey" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		var query = {};
		arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
		arguments.name = "query.name";
		arguments.result = "loc.result";
		arguments.datasource = variables.instance.connection.datasource;
		if (Len(variables.instance.connection.username))
			arguments.username = variables.instance.connection.username;
		if (Len(variables.instance.connection.password))
			arguments.password = variables.instance.connection.password;
		if (application.wheels.serverName == "Railo")
			arguments.psq = false; // set queries in Railo to not preserve single quotes on the entire cfquery block (we'll handle this individually in the SQL statement instead)  
		loc.sql = arguments.sql;
		loc.limit = arguments.limit;
		loc.offset = arguments.offset;
		loc.parameterize = arguments.parameterize;
		loc.primaryKey = arguments.$primaryKey;
		StructDelete(arguments, "sql");
		StructDelete(arguments, "limit");
		StructDelete(arguments, "offset");
		StructDelete(arguments, "parameterize");
		StructDelete(arguments, "$primaryKey");
	</cfscript>
	<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif IsBoolean(loc.parameterize) AND loc.parameterize><cfset loc.queryParamAttributes = $CFQueryParameters(loc.i)><cfif loc.queryParamAttributes._useNull>NULL<cfelseif StructKeyExists(loc.queryParamAttributes, "list")>(<cfqueryparam attributeCollection="#loc.queryParamAttributes#">)<cfelse><cfqueryparam attributeCollection="#loc.queryParamAttributes#"></cfif><cfelse>'#loc.i.value#'</cfif><cfelse>#Replace(PreserveSingleQuotes(loc.i), "[[comma]]", ",", "all")#</cfif>#chr(13)##chr(10)#</cfloop><cfif loc.limit>LIMIT #loc.limit#<cfif loc.offset>#chr(13)##chr(10)#OFFSET #loc.offset#</cfif></cfif></cfquery>
	<cfscript>
		loc.returnValue.result = loc.result;
		if (StructKeyExists(query, "name"))
			loc.returnValue.query = query.name;
	</cfscript>
	<cfif StructKeyExists(loc.result, "sql") AND Left(loc.result.sql, 12) IS "INSERT INTO ">
		<!--- getting the id of the last inserted row is not supported so we need to get it manually --->
		<cfquery attributeCollection="#arguments#">SELECT sqlite3_last_insert_rowid() AS lastId</cfquery>
		<cfset loc.returnValue.result.generated_key = query.name.lastId>
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>
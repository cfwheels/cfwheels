<cffunction name="$generatedKey" returntype="string" access="public" output="false">
	<cfreturn "generated_key">
</cffunction>

<cffunction name="$randomOrder" returntype="string" access="public" output="false">
	<cfreturn "RAND()">
</cffunction>

<cffunction name="$getType" returntype="string" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		switch(arguments.type)
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

<cffunction name="$beginTransaction">
	<cfset $query(sql=ListToArray("START TRANSACTION"), parameterize=true)>
</cffunction>

<cffunction name="$commitTransaction">
	<cfset $query(sql=ListToArray("COMMIT"), parameterize=true)>
</cffunction>

<cffunction name="$rollbackTransaction">
	<cfset $query(sql=ListToArray("ROLLBACK"), parameterize=true)>
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
	<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif IsBoolean(loc.parameterize) AND loc.parameterize><cfset loc.queryParamAttributes = StructNew()><cfset loc.queryParamAttributes.cfsqltype = loc.i.type><cfset loc.queryParamAttributes.value = loc.i.value><cfif StructKeyExists(loc.i, "null")><cfset loc.queryParamAttributes.null = loc.i.null></cfif><cfif StructKeyExists(loc.i, "scale") AND loc.i.scale GT 0><cfset loc.queryParamAttributes.scale = loc.i.scale></cfif><cfqueryparam attributeCollection="#loc.queryParamAttributes#"><cfelse>'#loc.i.value#'</cfif><cfelse>#Replace(PreserveSingleQuotes(loc.i), "[[comma]]", ",", "all")#</cfif>#chr(13)##chr(10)#</cfloop><cfif loc.limit>LIMIT #loc.limit#<cfif loc.offset>#chr(13)##chr(10)#OFFSET #loc.offset#</cfif></cfif></cfquery>
	<cfscript>
		loc.returnValue.result = loc.result;
		if (StructKeyExists(query, "name"))
			loc.returnValue.query = query.name;
	</cfscript>
	<cfif StructKeyExists(server, "railo") AND StructKeyExists(loc.result, "sql") AND Left(loc.result.sql, 12) IS "INSERT INTO ">
		<!--- railo does not yet support the "generated_key" value returned from the cfquery tag so until they do we need to get it manually --->
		<cfquery attributeCollection="#arguments#">SELECT LAST_INSERT_ID() AS lastId</cfquery>
		<cfset loc.returnValue.result.generated_key = query.name.lastId>
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>
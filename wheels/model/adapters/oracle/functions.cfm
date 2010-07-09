<cffunction name="$generatedKey" returntype="string" access="public" output="false">
	<cfreturn "rowid">
</cffunction>

<cffunction name="$randomOrder" returntype="string" access="public" output="false">
	<cfreturn "dbms_random.value()">
</cffunction>

<cffunction name="$getType" returntype="string" access="public" output="false">
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
	<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif IsBoolean(loc.parameterize) AND loc.parameterize><cfset loc.queryParamAttributes = $CFQueryParameters(loc.i)><cfif loc.queryParamAttributes.value eq "null">NULL<cfelseif StructKeyExists(loc.queryParamAttributes, "list")>(<cfqueryparam attributeCollection="#loc.queryParamAttributes#">)<cfelse><cfqueryparam attributeCollection="#loc.queryParamAttributes#"></cfif><cfelse>'#loc.i.value#'</cfif><cfelse>#Replace(PreserveSingleQuotes(loc.i), "[[comma]]", ",", "all")#</cfif>#chr(13)##chr(10)#</cfloop></cfquery>
	<cfscript>
		loc.returnValue.result = loc.result;
		if (StructKeyExists(query, "name"))
			loc.returnValue.query = query.name;
	</cfscript>
	<cfif StructKeyExists(loc.result, "sql") AND Left(loc.result.sql, 12) IS "INSERT INTO ">
		<!--- the rowid value returned by ColdFusion is not the actual primary key value (unlike the way it works for sql server and mysql) so on insert statements we need to get that value out of the database using the rowid reference --->
		<cfset loc.tbl = SpanExcluding(Right(loc.result.sql, Len(loc.result.sql)-12), " ")>
		<cfquery attributeCollection="#arguments#">SELECT #loc.primaryKey# FROM #loc.tbl# WHERE ROWID = '#loc.result.rowid#'</cfquery>
		<cfset loc.returnValue.result.rowid = query.name[loc.primaryKey]>
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>
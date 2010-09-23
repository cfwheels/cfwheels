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

		arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
		if (arguments.limit > 0)
		{
			loc.beforeWhere = "SELECT * FROM (SELECT a.*, rownum rnum FROM (";
			loc.afterWhere = ") a WHERE rownum <=" & arguments.limit+arguments.offset & ")" & " WHERE rnum >" & arguments.offset;
			ArrayPrepend(arguments.sql, loc.beforeWhere);
			ArrayAppend(arguments.sql, loc.afterWhere);
		}

		// oracle doesn't support limit and offset in sql
		StructDelete(arguments, "limit", false);
		StructDelete(arguments, "offset", false);
		loc.returnValue = $performQuery(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$identitySelect" returntype="any" access="public" output="false">
	<cfargument name="queryAttributes" type="struct" required="true">
	<cfargument name="result" type="struct" required="true">
	<cfargument name="primaryKey" type="string" required="true">
	<cfset var loc = {}>
	<cfset var query = {}>
	<cfset loc.sql = Trim(arguments.result.sql)>
	<cfif Left(loc.sql, 11) IS "INSERT INTO" AND NOT StructKeyExists(arguments.result, $generatedKey())>
		<cfset loc.startPar = Find("(", loc.sql) + 1>
		<cfset loc.endPar = Find(")", loc.sql)>
		<cfset loc.columnList = ReplaceList(Mid(loc.sql, loc.startPar, (loc.endPar-loc.startPar)), "#Chr(10)#,#Chr(13)#, ", ",,")>
		<cfif NOT ListFindNoCase(loc.columnList, arguments.primaryKey)>
			<cfset loc.returnValue = {}>
			<!--- the rowid value returned by Railo/ACF is not the actual primary key value (unlike the way it works for sql server and mysql) so on insert statements we need to get that value out of the database using the rowid reference --->
			<cfset loc.tbl = SpanExcluding(Right(loc.sql, Len(loc.sql)-12), " ")>
			<cfquery attributeCollection="#arguments.queryAttributes#">SELECT #arguments.primaryKey# FROM #loc.tbl# WHERE ROWID = '#arguments.result[$generatedKey()]#'</cfquery>
			<cfset loc.returnValue[$generatedKey()] = query.name[arguments.args.$primaryKey]>
			<cfreturn loc.returnValue>
		</cfif>
	</cfif>
</cffunction>
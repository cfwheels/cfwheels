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
		arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
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
		<cfif NOT ListFindNoCase(loc.columnList, ListFirst(arguments.primaryKey))>
			<cfset loc.returnValue = {}>
			<cfquery attributeCollection="#arguments.queryAttributes#">SELECT last_insert_rowid() AS lastId</cfquery>
			<cfset loc.returnValue[$generatedKey()] = query.name.lastId>
			<cfreturn loc.returnValue>
		</cfif>
	</cfif>
</cffunction>
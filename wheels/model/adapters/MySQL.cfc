<cfcomponent extends="Base" output="false">

	<cffunction name="$generatedKey" returntype="string" access="public" output="false">
		<cfscript>
			var loc = {};
			loc.rv = "generated_key";
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$randomOrder" returntype="string" access="public" output="false">
		<cfscript>
			var loc = {};
			loc.rv = "RAND()";
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$defaultValues" returntype="string" access="public" output="false">
		<cfscript>
			var loc = {};
			loc.rv = "() VALUES()";
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$getType" returntype="string" access="public" output="false">
		<cfargument name="type" type="string" required="true">
		<cfscript>
			var loc = {};
			switch (arguments.type)
			{
				case "bigint":
					loc.rv = "cf_sql_bigint";
					break;
				case "binary":
					loc.rv = "cf_sql_binary";
					break;
				case "bit": case "bool":
					loc.rv = "cf_sql_bit";
					break;
				case "blob": case "tinyblob": case "mediumblob": case "longblob":
					loc.rv = "cf_sql_blob";
					break;
				case "char":
					loc.rv = "cf_sql_char";
					break;
				case "date":
					loc.rv = "cf_sql_date";
					break;
				case "decimal":
					loc.rv = "cf_sql_decimal";
					break;
				case "double":
					loc.rv = "cf_sql_double";
					break;
				case "float":
					loc.rv = "cf_sql_float";
					break;
				case "int": case "mediumint":
					loc.rv = "cf_sql_integer";
					break;
				case "smallint": case "year":
					loc.rv = "cf_sql_smallint";
					break;
				case "time":
					loc.rv = "cf_sql_time";
					break;
				case "datetime": case "timestamp":
					loc.rv = "cf_sql_timestamp";
					break;
				case "tinyint":
					loc.rv = "cf_sql_tinyint";
					break;
				case "varbinary":
					loc.rv = "cf_sql_varbinary";
					break;
				case "varchar": case "text": case "mediumtext": case "longtext": case "tinytext": case "enum": case "set":
					loc.rv = "cf_sql_varchar";
					break;
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>
	
	<cffunction name="$query" returntype="struct" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfargument name="limit" type="numeric" required="false" default=0>
		<cfargument name="offset" type="numeric" required="false" default=0>
		<cfargument name="parameterize" type="boolean" required="true">
		<cfargument name="$primaryKey" type="string" required="false" default="">
		<cfscript>
			var loc = {};
			arguments = $convertMaxRowsToLimit(arguments);
			arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
			loc.rv = $performQuery(argumentCollection=arguments);
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>
	
	<cffunction name="$identitySelect" returntype="any" access="public" output="false">
		<cfargument name="queryAttributes" type="struct" required="true">
		<cfargument name="result" type="struct" required="true">
		<cfargument name="primaryKey" type="string" required="true">
		<cfset var loc = StructNew()>
		<cfset var query = StructNew()>
		<cfset loc.sql = Trim(arguments.result.sql)>
		<cfif Left(loc.sql, 11) IS "INSERT INTO" AND NOT StructKeyExists(arguments.result, $generatedKey())>
			<cfset loc.startPar = Find("(", loc.sql) + 1>
			<cfset loc.endPar = Find(")", loc.sql)>
			<cfset loc.columnList = ReplaceList(Mid(loc.sql, loc.startPar, (loc.endPar-loc.startPar)), "#Chr(10)#,#Chr(13)#, ", ",,")>
			<cfif NOT ListFindNoCase(loc.columnList, ListFirst(arguments.primaryKey))>
				<cfset loc.rv = StructNew()>
				<cfquery attributeCollection="#arguments.queryAttributes#">SELECT LAST_INSERT_ID() AS lastId</cfquery>
				<cfset loc.rv[$generatedKey()] = query.name.lastId>
				<cfreturn loc.rv>
			</cfif>
		</cfif>
	</cffunction>

	<cfinclude template="../../plugins/injection.cfm">
</cfcomponent>
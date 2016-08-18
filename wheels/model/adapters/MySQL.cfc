<cfcomponent extends="Base" output="false">

	<cfscript>
	public string function $generatedKey() {
		local.rv = "generated_key";
		return local.rv;
	}

	public string function $randomOrder() {
		local.rv = "RAND()";
		return local.rv;
	}

	public string function $defaultValues() {
		local.rv = "() VALUES()";
		return local.rv;
	}

	public string function $getType(required string type) {
		switch (arguments.type) {
			case "bigint":
				local.rv = "cf_sql_bigint";
				break;
			case "binary": case "geometry": case "point": case "linestring": case "polygon": case "multipoint": case "multilinestring": case "multipolygon": case "geometrycollection":
				local.rv = "cf_sql_binary";
				break;
			case "bit": case "bool":
				local.rv = "cf_sql_bit";
				break;
			case "blob": case "tinyblob": case "mediumblob": case "longblob":
				local.rv = "cf_sql_blob";
				break;
			case "char":
				local.rv = "cf_sql_char";
				break;
			case "date":
				local.rv = "cf_sql_date";
				break;
			case "decimal":
				local.rv = "cf_sql_decimal";
				break;
			case "double":
				local.rv = "cf_sql_double";
				break;
			case "float":
				local.rv = "cf_sql_float";
				break;
			case "int": case "mediumint":
				local.rv = "cf_sql_integer";
				break;
			case "smallint": case "year":
				local.rv = "cf_sql_smallint";
				break;
			case "time":
				local.rv = "cf_sql_time";
				break;
			case "datetime": case "timestamp":
				local.rv = "cf_sql_timestamp";
				break;
			case "tinyint":
				local.rv = "cf_sql_tinyint";
				break;
			case "varbinary":
				local.rv = "cf_sql_varbinary";
				break;
			case "varchar": case "text": case "mediumtext": case "longtext": case "tinytext": case "enum": case "set":
				local.rv = "cf_sql_varchar";
				break;
		}
		return local.rv;
	}

	public struct function $query(
	  required array sql,
	  numeric limit=0,
	  numeric offset=0,
	  required boolean parameterize,
	  string $primaryKey=""
	) {
		arguments = $convertMaxRowsToLimit(arguments);
		arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
		local.rv = $performQuery(argumentCollection=arguments);
		return local.rv;
	}
	</cfscript>

	<cffunction name="$identitySelect" returntype="any" access="public" output="false">
		<cfargument name="queryAttributes" type="struct" required="true">
		<cfargument name="result" type="struct" required="true">
		<cfargument name="primaryKey" type="string" required="true">
		<cfset var query = StructNew()>
		<cfset local.sql = Trim(arguments.result.sql)>
		<cfif Left(local.sql, 11) IS "INSERT INTO" AND NOT StructKeyExists(arguments.result, $generatedKey())>
			<cfset local.startPar = Find("(", local.sql) + 1>
			<cfset local.endPar = Find(")", local.sql)>
			<cfset local.columnList = ReplaceList(Mid(local.sql, local.startPar, (local.endPar-local.startPar)), "#Chr(10)#,#Chr(13)#, ", ",,")>
			<cfif NOT ListFindNoCase(local.columnList, ListFirst(arguments.primaryKey))>
				<cfset local.rv = StructNew()>
				<cfquery attributeCollection="#arguments.queryAttributes#">SELECT LAST_INSERT_ID() AS lastId</cfquery>
				<cfset local.rv[$generatedKey()] = query.name.lastId>
				<cfreturn local.rv>
			</cfif>
		</cfif>
	</cffunction>

	<cfscript>
	include "../../plugins/injection.cfm";
	</cfscript>

</cfcomponent>
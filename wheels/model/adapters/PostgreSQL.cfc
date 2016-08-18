<cfcomponent extends="Base" output="false">

	<cfscript>
	public string function $generatedKey() {
		local.rv = "lastId";
		return local.rv;
	}

	public string function $randomOrder() {
		local.rv = "random()";
		return local.rv;
	}

	public string function $getType(required string type) {
		switch (arguments.type) {
			case "bigint": case "int8": case "bigserial": case "serial8":
				local.rv = "cf_sql_bigint";
				break;
			case "bool": case "boolean": case "bit": case "varbit":
				local.rv = "cf_sql_bit";
				break;
			case "bytea":
				local.rv = "cf_sql_binary";
				break;
			case "char": case "character":
				local.rv = "cf_sql_char";
				break;
			case "date": case "timestamp": case "timestamptz":
				local.rv = "cf_sql_timestamp";
				break;
			case "decimal": case "double": case "precision": case "float": case "float4": case "float8":
				local.rv = "cf_sql_decimal";
				break;
			case "integer": case "int": case "int4": case "serial": case "oid":
				// oid cols should probably be avoided - placed here for completeness
				local.rv = "cf_sql_integer";
				break;
			case "numeric": case "smallmoney": case "money":
				// postgres has deprecated the money type: http://www.postgresql.org/docs/8.1/static/datatype-money.html
				local.rv = "cf_sql_numeric";
				break;
			case "real":
				local.rv = "cf_sql_real";
				break;
			case "smallint": case "int2":
				local.rv = "cf_sql_smallint";
				break;
			case "text":
				local.rv = "cf_sql_longvarchar";
				break;
			case "time": case "timetz":
				local.rv = "cf_sql_time";
				break;
			case "varchar": case "varying": case "bpchar": case "uuid":
				local.rv = "cf_sql_varchar";
				break;
		}
		return local.rv;
	}

	public struct function $query(
	  required array sql,
	  numeric limit="0",
	  numeric offset="0",
	  required boolean parameterize,
	  string $primaryKey=""
	) {
		arguments = $convertMaxRowsToLimit(arguments);
		arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
		arguments.sql = $addColumnsToSelectAndGroupBy(arguments.sql);
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
				<!--- Railo/ACF doesn't support PostgreSQL natively when it comes to returning the primary key value of the last inserted record so we have to do it manually by using the sequence --->
				<cfset local.rv = StructNew()>
				<cfset local.tbl = SpanExcluding(Right(local.sql, Len(local.sql)-12), " ")>
				<cfquery attributeCollection="#arguments.queryAttributes#">SELECT currval(pg_get_serial_sequence('#local.tbl#', '#arguments.primaryKey#')) AS lastId</cfquery>
				<cfset local.rv[$generatedKey()] = query.name.lastId>
				<cfreturn local.rv>
			</cfif>
		</cfif>
	</cffunction>

	<cfscript>
		include "../../plugins/injection.cfm";
	</cfscript>
</cfcomponent>
component extends="Base" output=false {

	/**
	 * Map database types to the ones used in CFML.
	 * Using oid cols should probably be avoided, included here for completeness.
	 * PostgreSQL has deprecated the money type, included here for completeness.
	 */
	public string function $getType(required string type, string scale, string details) {
		switch (arguments.type) {
			case "bigint":
			case "int8":
			case "bigserial":
			case "serial8":
				local.rv = "cf_sql_bigint";
				break;
			case "bool":
			case "boolean":
			case "bit":
			case "varbit":
				local.rv = "cf_sql_bit";
				break;
			case "bytea":
				local.rv = "cf_sql_binary";
				break;
			case "char":
			case "character":
				local.rv = "cf_sql_char";
				break;
			case "date":
			case "timestamp":
			case "timestamptz":
				local.rv = "cf_sql_timestamp";
				break;
			case "decimal":
			case "double":
			case "precision":
			case "float":
			case "float4":
			case "float8":
				local.rv = "cf_sql_decimal";
				break;
			case "integer":
			case "int":
			case "int4":
			case "serial":
			case "oid":
				local.rv = "cf_sql_integer";
				break;
			case "numeric":
			case "smallmoney":
			case "money":
				local.rv = "cf_sql_numeric";
				break;
			case "real":
				local.rv = "cf_sql_real";
				break;
			case "smallint":
			case "int2":
				local.rv = "cf_sql_smallint";
				break;
			case "text":
				local.rv = "cf_sql_longvarchar";
				break;
			case "time":
			case "timetz":
				local.rv = "cf_sql_time";
				break;
			case "varchar":
			case "varying":
			case "bpchar":
			case "uuid":
				local.rv = "cf_sql_varchar";
				break;
		}
		return local.rv;
	}

	/**
	 * Call functions to make adapter specific changes to arguments before executing query.
	 */
	public struct function $querySetup(
		required array sql,
		numeric limit = 0,
		numeric offset = 0,
		required boolean parameterize,
		string $primaryKey = ""
	) {
		$convertMaxRowsToLimit(args = arguments);
		$removeColumnAliasesInOrderClause(args = arguments);
		$addColumnsToSelectAndGroupBy(args = arguments);
		$moveAggregateToHaving(args = arguments);
		return $performQuery(argumentCollection = arguments);
	}

	/**
	 * Override Base adapter's function.
	 */
	public string function $generatedKey() {
		return "lastId";
	}

	/**
	 * Override Base adapter's function.
	 */
	public any function $identitySelect(
		required struct queryAttributes,
		required struct result,
		required string primaryKey
	) {
		var query = {};
		local.sql = Trim(arguments.result.sql);
		if (Left(local.sql, 11) == "INSERT INTO" && !StructKeyExists(arguments.result, $generatedKey())) {
			local.startPar = Find("(", local.sql) + 1;
			local.endPar = Find(")", local.sql);
			local.columnList = "";
			if (local.endPar) {
				local.columnList = ReplaceList(
					Mid(local.sql, local.startPar, (local.endPar - local.startPar)),
					"#Chr(10)#,#Chr(13)#, ",
					",,"
				);
			}

			// Lucee/ACF doesn't support PostgreSQL natively when it comes to returning the primary key value of the last inserted record so we have to do it manually by using the sequence.
			if (!ListFindNoCase(local.columnList, ListFirst(arguments.primaryKey))) {
				local.rv = {};
				local.tbl = SpanExcluding(Right(local.sql, Len(local.sql) - 12), " ");
				query = $query(
					sql = "SELECT currval(pg_get_serial_sequence('#local.tbl#', '#arguments.primaryKey#')) AS lastId",
					argumentCollection = arguments.queryAttributes
				);
				local.rv[$generatedKey()] = query.lastId;
				return local.rv;
			}
		}
	}

	/**
	 * Override Base adapter's function.
	 */
	public string function $randomOrder() {
		return "random()";
	}

	include "../../plugins/standalone/injection.cfm";

}

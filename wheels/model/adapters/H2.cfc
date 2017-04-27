component extends="Base" output=false {

	/**
	 * Map database types to the ones used in CFML.
	 */
	public string function $getType(required string type, string scale, string details) {
		switch (arguments.type) {
			case "bigint": case "int8":
				local.rv = "cf_sql_bigint";
				break;
			case "binary": case "bytea": case "raw":
				local.rv = "cf_sql_binary";
				break;
			case "bit": case "bool": case "boolean":
				local.rv = "cf_sql_bit";
				break;
			case "blob": case "tinyblob": case "mediumblob": case "longblob": case "image": case "oid":
				local.rv = "cf_sql_blob";
				break;
			case "char": case "character": case "nchar":
				local.rv = "cf_sql_char";
				break;
			case "date":
				local.rv = "cf_sql_date";
				break;
			case "dec": case "decimal": case "number": case "numeric":
				local.rv = "cf_sql_decimal";
				break;
			case "double":
				local.rv = "cf_sql_double";
				break;
			case "float": case "float4": case "float8": case "real":
				local.rv = "cf_sql_float";
				break;
			case "int": case "int4": case "integer": case "mediumint": case "signed":
				local.rv = "cf_sql_integer";
				break;
			case "int2": case "smallint": case "year":
				local.rv = "cf_sql_smallint";
				break;
			case "time":
				local.rv = "cf_sql_time";
				break;
			case "datetime": case "smalldatetime": case "timestamp":
				local.rv = "cf_sql_timestamp";
				break;
			case "tinyint":
				local.rv = "cf_sql_tinyint";
				break;
			case "varbinary": case "longvarbinary":
				local.rv = "cf_sql_varbinary";
				break;
			case "varchar": case "varchar2": case "longvarchar": case "varchar_ignorecase": case "nvarchar": case "nvarchar2": case "clob": case "nclob": case "text": case "tinytext": case "mediumtext": case "longtext": case "ntext":
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
	  numeric limit=0,
	  numeric offset=0,
	  required boolean parameterize,
	  string $primaryKey=""
	) {
		$convertMaxRowsToLimit(args=arguments);
		$removeColumnAliasesInOrderClause(args=arguments);
		$addColumnsToSelectAndGroupBy(args=arguments);
		$moveAggregateToHaving(args=arguments);
		return $performQuery(argumentCollection=arguments);
	}

	/**
	 * Override Base adapter's function.
	 * When using H2, cfdbinfo incorrectly returns information_schema tables.
	 * To fix we create a new query result that excludes these tables.
	 * Yes, it should actually be "table_schem" below, not a typo.
	 */
	public query function $getColumns() {
		local.columns = super.$getColumns(argumentCollection=arguments);
		local.rv = QueryNew(local.columns.columnList);
		local.iEnd = local.columns.recordCount;
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			if (local.columns["table_schem"][local.i] != "information_schema") {
				QueryAddRow(local.rv);
				local.jEnd = ListLen(local.columns.columnList);
				for (local.j = 1; local.j <= local.jEnd; local.j++) {
					local.item = ListGetAt(local.columns.columnList, local.j);
					QuerySetCell(local.rv, local.item, local.columns[local.item][local.i]);
				}
			}
		}
		return local.rv;
	}

	include "../../plugins/standalone/injection.cfm";
}

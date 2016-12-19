component extends="Base" output=false {

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

	public struct function $querySetup(
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

	public any function $identitySelect(
	  required struct queryAttributes,
	  required struct result,
	  required string primaryKey
	) {
		var query = {};
		local.sql = Trim(arguments.result.sql);
		if (Left(local.sql, 11) IS "INSERT INTO" AND NOT StructKeyExists(arguments.result, $generatedKey())) {
			local.startPar = Find("(", local.sql) + 1;
			local.endPar = Find(")", local.sql);
			local.columnList = ReplaceList(Mid(local.sql, local.startPar, (local.endPar-local.startPar)), "#Chr(10)#,#Chr(13)#, ", ",,");
			if (! ListFindNoCase(local.columnList, ListFirst(arguments.primaryKey))) {
				local.rv = {};
				query = $query(sql="SELECT LAST_INSERT_ID() AS lastId", argumentCollection=arguments.queryAttributes);
				local.rv[$generatedKey()] = query.lastId;
				return local.rv;
			}
		}
	}

	include "../../plugins/functions.cfm";

}

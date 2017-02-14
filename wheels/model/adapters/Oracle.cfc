component extends="Base" output="false" {

	public string function $generatedKey() {
		local.rv = "rowid";
		return local.rv;
	}

	public string function $randomOrder() {
		local.rv = "dbms_random.value()";
		return local.rv;
	}

	public string function $defaultValues(required string $primaryKey) {
		local.rv = "(#arguments.$primaryKey#) VALUES(DEFAULT)";
		return local.rv;
	}

	public string function $tableAlias(required string table, required string alias) {
		local.rv = arguments.table & " " & arguments.alias;
		return local.rv;
	}

	public string function $getType(required string type, required string scale) {
		switch (LCase(arguments.type)) {
			case "blob": case "bfile":
				local.rv = "cf_sql_blob";
				break;
			case "char": case "nchar":
				local.rv = "cf_sql_char";
				break;
			case "clob": case "nclob":
				local.rv = "cf_sql_clob";
				break;
			case "date": case "timestamp":
				local.rv = "cf_sql_timestamp";
				break;
			case "binary_double":
				local.rv = "cf_sql_double";
				break;
			case "number": case "float": case "decimal": case "binary_float":
				// integer datatypes are represented by number(38,0)
				if (Val(arguments.scale) == 0) {
					local.rv = "cf_sql_integer";
				} else {
					local.rv = "cf_sql_float";
				}
				break;
			case "long":
				local.rv = "cf_sql_longvarchar";
				break;
			case "raw":
				local.rv = "cf_sql_varbinary";
				break;
			case "varchar2": case "nvarchar2":
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
		arguments.sql = $addColumnsToSelectAndGroupBy(arguments.sql);
		if (arguments.limit > 0) {
			local.select = ReplaceNoCase(ReplaceNoCase(arguments.sql[1], "SELECT DISTINCT ", ""), "SELECT ", "");
			local.select = $columnAlias(list=$tableName(list=local.select, action="remove"), action="keep");
			local.beforeWhere = "SELECT #local.select# FROM (SELECT * FROM (SELECT tmp.*, rownum rnum FROM (";
			local.afterWhere = ") tmp WHERE rownum <=" & arguments.limit+arguments.offset & ")" & " WHERE rnum >" & arguments.offset & ")";
			ArrayPrepend(arguments.sql, local.beforeWhere);
			ArrayAppend(arguments.sql, local.afterWhere);
		}

		// oracle doesn't support limit and offset in sql
		StructDelete(arguments, "limit");
		StructDelete(arguments, "offset");
		local.rv = $performQuery(argumentCollection=arguments);
		local.rv = $handleTimestampObject(local.rv);
		return local.rv;
	}

	/**
  * Oracle will return timestamp as an object. you need to call timestampValue()
  * to get the string representation
  */
	public struct function $handleTimestampObject(required struct results) {
		// depending on the driver and engine used with oracle, timestamps
		// can be returned as objects instead of strings.
		if (StructKeyExists(arguments.results, "query")) {
			// look for all timestamp columns
			local.query = arguments.results.query;
			if (local.query.recordCount > 0) {
				local.metadata = GetMetaData(local.query);
				local.columns = [];
				local.iEnd = ArrayLen(local.metadata);
				for (local.i=1; local.i <= local.iEnd; local.i++) {
					local.column = local.metadata[local.i];
					if (local.column.typename == "timestamp") {
						ArrayAppend(local.columns, local.column.name);
					}
				}

				// if we have any timestamp columns
				if (!ArrayIsEmpty(local.columns)) {
					local.iEnd = ArrayLen(local.columns);
					for (local.i=1; local.i <= local.iEnd; local.i++) {
						local.column = local.columns[local.i];
						local.jEnd = local.query.recordCount;
						for (local.j=1; local.j <= local.jEnd; local.j++) {
							if (IsObject(local.query[local.column][local.j])) {
								// call timestampValue() on objects to convert to string
								local.query[local.column][local.j] = local.query[local.column][local.j].timestampValue();
							} else if (IsSimpleValue(local.query[local.column][local.j]) && Len(local.query[local.column][local.j])) {
								// if the driver does the conversion automatically, there is no need to continue
								break;
							}
						}
					}
				}
				arguments.results.query = local.query;
			}
		}
		local.rv = arguments.results;
		return local.rv;
	}

	public any function $identitySelect(
	  required struct queryAttributes,
	  required struct result,
	  required string primaryKey
	) {
		var query = {};
		local.sql = Trim(arguments.result.sql);
		if (Left(local.sql, 11) IS "INSERT INTO") {

			local.startPar = Find("(", local.sql) + 1;
			local.endPar = Find(")", local.sql);
			local.columnList = ReplaceList(Mid(local.sql, local.startPar, (local.endPar-local.startPar)), "#Chr(10)#,#Chr(13)#, ", ",,");

			if (! ListFindNoCase(local.columnList, ListFirst(arguments.primaryKey))) {
				local.rv = StructNew();
				local.tbl = SpanExcluding(Right(local.sql, Len(local.sql)-12), " ");
				if (! StructKeyExists(arguments.result, $generatedKey()) || application.wheels.serverName IS NOT "Adobe ColdFusion") {
					/*
					there isn't a way in oracle to tell what (if any) sequences exists
					on a table. hence we'll just have to perform a guess for now.
					TODO: in 1.2 we need to look at letting the developer specify the sequence
					name through a setting in the model
					 */
					try {
						query = $query(sql="SELECT #local.tbl#_seq.currval AS lastId FROM dual", argumentCollection=arguments.queryAttributes);
					} catch(any e) {
						// in case the sequence doesn't exists return a blank string for the expected value
						query.lastId = "";
					}
				} else {
					query = $query(sql="SELECT #arguments.primaryKey# AS lastId FROM #local.tbl# WHERE ROWID = '#arguments.result[$generatedKey()]#'", argumentCollection=arguments.queryAttributes);
				}
				local.lastId = Trim(query.lastId);
				if (Len(query.lastId)) {
					local.rv[$generatedKey()] = Trim(local.lastid);
					return local.rv;
				}
			} else {
				// since Oracle always returns rowid we need to delete it in those cases
				// where we have manually inserted the primary key, if we don't do this we'll
				// end up setting the rowid value to the object
				if (StructKeyExists(arguments.result, "rowid")) {
					StructDelete(arguments.result, "rowid");
				}
				if (StructKeyExists(arguments.result, "generatedkey")) {
					StructDelete(arguments.result, "generatedkey");
				}
			}
		}
	}

	public query function $getColumnInfo(
	  required string table,
	  required string datasource,
	  required string username,
	  required string password
	) {
		local.args = Duplicate(arguments);
		StructDelete(local.args, "table");
		if (!Len(local.args.username))
		{
			StructDelete(local.args, "username");
		}
		if (!Len(local.args.password))
		{
			StructDelete(local.args, "password");
		}
		local.rv = $query(
			sql="
				SELECT
					TC.COLUMN_NAME
					,TC.DATA_TYPE AS TYPE_NAME
					,TC.NULLABLE AS IS_NULLABLE
					,CASE WHEN PKC.COLUMN_NAME IS NULL THEN 0 ELSE 1 END AS IS_PRIMARYKEY
					,0 AS IS_FOREIGNKEY
					,'' AS REFERENCED_PRIMARYKEY
					,'' AS REFERENCED_PRIMARYKEY_TABLE
					,NVL(TC.DATA_PRECISION, TC.DATA_LENGTH) AS COLUMN_SIZE
					,TC.DATA_SCALE AS DECIMAL_DIGITS
					,TC.DATA_DEFAULT AS COLUMN_DEFAULT_VALUE
					,TC.DATA_LENGTH AS CHAR_OCTET_LENGTH
					,TC.COLUMN_ID AS ORDINAL_POSITION
					,'' AS REMARKS
				FROM
					ALL_TAB_COLUMNS TC
					LEFT JOIN ALL_CONSTRAINTS PK
						ON (PK.CONSTRAINT_TYPE = 'P'
						AND PK.TABLE_NAME = TC.TABLE_NAME
						AND TC.OWNER = PK.OWNER)
					LEFT JOIN ALL_CONS_COLUMNS PKC
						ON (PK.CONSTRAINT_NAME = PKC.CONSTRAINT_NAME
						AND TC.COLUMN_NAME = PKC.COLUMN_NAME
						AND TC.OWNER = PKC.OWNER)
				WHERE
					TC.TABLE_NAME = '#UCase(arguments.table)#'
				ORDER BY
					TC.COLUMN_ID
			",
			argumentCollection=local.args
		);
		/*
		wheels catches the error and raises a Wheels.TableNotFound error
		to mimic this we will throw an error if the query result is empty
		 */
		if (! local.rv.recordCount) {
			$throw(type="Wheels.TableNotFound", message="The `#arguments.table#` table could not be found in the database.");
		}
		return local.rv;
	}

	include "../../plugins/injection.cfm";

}

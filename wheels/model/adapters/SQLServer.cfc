component extends="Base" output=false {

	public string function $generatedKey() {
		local.rv = "identitycol";
		return local.rv;
	}

	public string function $randomOrder() {
		local.rv = "NEWID()";
		return local.rv;
	}

	public string function $getType(required string type) {
		switch (arguments.type) {
			case "bigint":
				local.rv = "cf_sql_bigint";
				break;
			case "binary": case "geography": case "geometry": case "timestamp":
				local.rv = "cf_sql_binary";
				break;
			case "bit":
				local.rv = "cf_sql_bit";
				break;
			case "char": case "nchar": case "uniqueidentifier":
				local.rv = "cf_sql_char";
				break;
			case "date":
				local.rv = "cf_sql_date";
				break;
			case "datetime": case "datetime2": case "smalldatetime": case "datetimeoffset":
				local.rv = "cf_sql_timestamp";
				break;
			case "decimal": case "money": case "smallmoney":
				local.rv = "cf_sql_decimal";
				break;
			case "float":
				local.rv = "cf_sql_float";
				break;
			case "int":
				local.rv = "cf_sql_integer";
				break;
			case "image":
				local.rv = "cf_sql_longvarbinary";
				break;
			case "text": case "ntext": case "xml":
				local.rv = "cf_sql_longvarchar";
				break;
			case "numeric":
				local.rv = "cf_sql_numeric";
				break;
			case "real":
				local.rv = "cf_sql_real";
				break;
			case "smallint":
				local.rv = "cf_sql_smallint";
				break;
			case "time":
				local.rv = "cf_sql_time";
				break;
			case "tinyint":
				local.rv = "cf_sql_tinyint";
				break;
			case "varbinary":
				local.rv = "cf_sql_varbinary";
				break;
			case "varchar": case "nvarchar":
				local.rv = "cf_sql_varchar";
				break;
		}
		return local.rv;
	}

	public struct function $querySetup(
	  required array sql,
	  numeric limit="0",
	  numeric offset="0",
	  required boolean parameterize,
	  string $primaryKey=""
	) {

		if (StructKeyExists(arguments, "maxrows") && arguments.maxrows > 0) {
			if (arguments.maxrows > 0) {
				arguments.sql [1] = ReplaceNoCase(arguments.sql[1], "SELECT ", "SELECT TOP #arguments.maxrows# ", "one");
			}
			StructDelete(arguments, "maxrows");
		}
		if (arguments.limit + arguments.offset > 0) {
			local.containsGroup = false;
			local.afterWhere = "";
			if (IsSimpleValue(arguments.sql[ArrayLen(arguments.sql) - 1]) && FindNoCase("GROUP BY", arguments.sql[ArrayLen(arguments.sql) - 1])) {
				local.containsGroup = true;
			}
			if (Find(",", arguments.sql[ArrayLen(arguments.sql)])) {
				// fix for pagination issue when ordering multiple columns with same name
				local.order = arguments.sql[ArrayLen(arguments.sql)];
				local.newOrder = "";
				local.doneColumns = "";
				local.done = 0;
				local.iEnd = ListLen(local.order);
				for (local.i=1; local.i <= local.iEnd; local.i++) {
					local.item = ListGetAt(local.order, local.i);
					local.column = SpanExcluding(Reverse(SpanExcluding(Reverse(local.item), ".")), " ");
					if (ListFind(local.doneColumns, local.column)) {
						local.done++;
						local.item &= " AS tmp" & local.done;
					}
					local.doneColumns = ListAppend(local.doneColumns, local.column);
					local.newOrder = ListAppend(local.newOrder, local.item);
				}
				arguments.sql[ArrayLen(arguments.sql)] = local.newOrder;
			}

			// select clause always comes first in the array, the order by clause last, remove the leading keywords leaving only the columns and set to the ones used in the inner most sub query
			local.thirdSelect = ReplaceNoCase(ReplaceNoCase(arguments.sql[1], "SELECT DISTINCT ", ""), "SELECT ", "");
			local.thirdOrder = ReplaceNoCase(arguments.sql[ArrayLen(arguments.sql)], "ORDER BY ", "");
			if (local.containsGroup) {
				local.thirdGroup = ReplaceNoCase(arguments.sql[ArrayLen(arguments.sql) - 1], "GROUP BY ", "");
			}

			// the first select is the outer most in the query and need to contain columns without table names and using aliases when they exist
			local.firstSelect = $columnAlias(list=$tableName(list=local.thirdSelect, action="remove"), action="keep");

			// we need to add columns from the inner order clause to the select clauses in the inner two queries
			local.iEnd = ListLen(local.thirdOrder);
			for (local.i=1; local.i <= local.iEnd; local.i++) {
				local.item = REReplace(REReplace(ListGetAt(local.thirdOrder, local.i), " ASC\b", ""), " DESC\b", "");
				if (!ListFindNoCase(local.thirdSelect, local.item)) {
					local.thirdSelect = ListAppend(local.thirdSelect, local.item);
				}
				if (local.containsGroup) {
					local.item = REReplace(local.item, "[[:space:]]AS[[:space:]][A-Za-z1-9]+", "", "all");
					if (!ListFindNoCase(local.thirdGroup, local.item)) {
						local.thirdGroup = ListAppend(local.thirdGroup, local.item);
					}
				}
			}

			// the second select also needs to contain columns without table names and using aliases when they exist (but now including the columns added above)
			local.secondSelect = $columnAlias(list=$tableName(list=local.thirdSelect, action="remove"), action="keep");

			// first order also needs the table names removed, the column aliases can be kept since they are removed before running the query anyway
			local.firstOrder = $tableName(list=local.thirdOrder, action="remove");

			// second order clause is the same as the first but with the ordering reversed
			local.secondOrder = Replace(REReplace(REReplace(local.firstOrder, " DESC\b", Chr(7), "all"), " ASC\b", " DESC", "all"), Chr(7), " ASC", "all");

			// fix column aliases from order by clauses
			local.thirdOrder = $columnAlias(list=local.thirdOrder, action="remove");
			local.secondOrder = $columnAlias(list=local.secondOrder, action="keep");
			local.firstOrder = $columnAlias(list=local.firstOrder, action="keep");

			// build new sql string and replace the old one with it
			local.beforeWhere = "SELECT " & local.firstSelect & " FROM (SELECT TOP " & arguments.limit & " " & local.secondSelect & " FROM (SELECT ";
			if (Find(" ", ListRest(arguments.sql[2], " "))) {
				local.beforeWhere &= "DISTINCT ";
			}
			local.beforeWhere &= "TOP " & arguments.limit + arguments.offset & " " & local.thirdSelect & " " & arguments.sql[2];
			if (local.containsGroup) {
				local.afterWhere = "GROUP BY " & local.thirdGroup & " ";
			}
			local.afterWhere = "ORDER BY " & local.thirdOrder & ") AS tmp1 ORDER BY " & local.secondOrder & ") AS tmp2 ORDER BY " & local.firstOrder;
			ArrayDeleteAt(arguments.sql, 1);
			ArrayDeleteAt(arguments.sql, 1);
			ArrayDeleteAt(arguments.sql, ArrayLen(arguments.sql));
			if (local.containsGroup) {
				ArrayDeleteAt(arguments.sql, ArrayLen(arguments.sql));
			}
			ArrayPrepend(arguments.sql, local.beforeWhere);
			ArrayAppend(arguments.sql, local.afterWhere);
		} else {
			arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
		}

		// sql server doesn't support limit and offset in sql
		StructDelete(arguments, "limit");
		StructDelete(arguments, "offset");
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
				local.rv = StructNew();
				query = $query(sql="SELECT SCOPE_IDENTITY() AS lastId", argumentCollection=arguments.queryAttributes);
				local.rv[$generatedKey()] = query.lastId;
				return local.rv;
			}
		}
	}

	include "../../plugins/injection.cfm";

}

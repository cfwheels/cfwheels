component output=false {
	include "../../global/functions.cfm";
	include "cfquery.cfm";

	/**
	 * Initialize and return the adapter object.
	 */
	public any function $init(required string dataSource, required string username, required string password) {
		variables.dataSource = arguments.dataSource;
		variables.username = arguments.username;
		variables.password = arguments.password;
		return this;
	}

	/**
	 * Set a default for the column name that holds the last inserted auto-incrementing primary key value.
	 * Individual database adapters will override when necessary.
	 */
	public string function $generatedKey() {
		return "generated_key";
	}

	/**
	 * Set a default for the string to use to order records randomly.
	 * Individual database adapters will override when necessary.
	 */
	public string function $randomOrder() {
		return "RAND()";
	}

	/**
	 * Set a default for the string to use when inserting a record with default values only.
	 * Individual database adapters will override when necessary.
	 */
	public string function $defaultValues() {
		return " DEFAULT VALUES";
	}

	/**
	 * Set a default for the table alias string (e.g. "users AS users2").
	 * Individual database adapters will override when necessary.
	 */
	public string function $tableAlias(required string table, required string alias) {
		return arguments.table & " AS " & arguments.alias;
	}

	/**
	 * Internal function.
	 */
	public string function $tableName(required string list, required string action) {
		local.rv = "";
		local.iEnd = ListLen(arguments.list);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.item = ListGetAt(arguments.list, local.i);

			// Remove table name if specified.
			if (arguments.action == "remove") {
				local.item = ListRest(local.item, ".");
			}

			local.rv = ListAppend(local.rv, local.item);
		}
		return local.rv;
	}

	/**
	 * Internal function.
	 */
	public string function $columnAlias(required string list, required string action) {
		local.rv = "";
		local.iEnd = ListLen(arguments.list);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.item = ListGetAt(arguments.list, local.i);
			if (Find(" AS ", local.item)) {
				local.sort = "";
				if (Right(local.item, 4) == " ASC" || Right(local.item, 5) == " DESC") {
					local.sort = " " & Reverse(SpanExcluding(Reverse(local.item), " "));
					local.item = Mid(local.item, 1, Len(local.item)-Len(local.sort));
				}
				local.alias = Reverse(SpanExcluding(Reverse(local.item), " "));

				// Keep or remove the alias.
				if (arguments.action == "keep") {
					local.item = local.alias;
				} else if (arguments.action == "remove") {
					local.item = Replace(local.item, " AS " & local.alias, "");
				}

				local.item &= local.sort;
			}
			local.rv = ListAppend(local.rv, local.item);
		}
		return local.rv;
	}

	/**
	 * Remove the column aliases from the order by clause (this is passed in so that we can handle sub queries with calculated properties).
	 */
	public array function $removeColumnAliasesInOrderClause(required array sql) {
		local.rv = arguments.sql;
		if (IsSimpleValue(local.rv[ArrayLen(local.rv)]) && Left(local.rv[ArrayLen(local.rv)], 9) == "ORDER BY ") {
			local.pos = ArrayLen(local.rv);
			local.list = ReplaceNoCase(local.rv[local.pos], "ORDER BY ", "");
			local.rv[local.pos] = "ORDER BY " & $columnAlias(list=local.list, action="remove");
		}
		return local.rv;
	}

	/**
	 * Internal function.
	 */
	public boolean function $isAggregateFunction(required string sql) {

		// Find "(FUNCTION(..." pattern inside the sql.
		local.match = REFind("^\([A-Z]+\(", arguments.sql, 0, true);

		// Guard against invalid match.
		if (ArrayLen(local.match.pos) == 0) {
			local.rv = false;
		} else if (local.match.len[1] <= 2) {
			local.rv = false;
		} else {

			// Extract and analyze the function name.
			local.name = Mid(arguments.sql, local.match.pos[1]+1, local.match.len[1]-2);
			local.rv = ListContains("AVG,COUNT,MAX,MIN,SUM", local.name);

		}
		return local.rv;
	}

	/**
	 * Internal function.
	 */
	public array function $addColumnsToSelectAndGroupBy(required array sql) {
		local.rv = arguments.sql;
		if (IsSimpleValue(local.rv[ArrayLen(local.rv)]) && Left(local.rv[ArrayLen(local.rv)], 8) == "ORDER BY" && IsSimpleValue(local.rv[ArrayLen(local.rv)-1]) && Left(local.rv[ArrayLen(local.rv)-1], 8) == "GROUP BY") {
			local.iEnd = ListLen(local.rv[ArrayLen(local.rv)]);
			for (local.i = 1; local.i <= local.iEnd; local.i++) {
				local.item = Trim(ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(ListGetAt(local.rv[ArrayLen(local.rv)], local.i), "ORDER BY ", ""), " ASC", ""), " DESC", ""));
				if (!ListFindNoCase(ReplaceNoCase(local.rv[ArrayLen(local.rv)-1], "GROUP BY ", ""), local.item) && !$isAggregateFunction(local.item)) {
					local.key = ArrayLen(local.rv)-1;
					local.rv[local.key] = ListAppend(local.rv[local.key], local.item);
				}
			}
		}
		return local.rv;
	}

	/**
	 * Retrieves all the column information from a table.
	 */
	public query function $getColumns(required string tableName) {
		local.args = {};
		local.args.dataSource = variables.dataSource;
		local.args.username = variables.username;
		local.args.password = variables.password;
		local.args.table = arguments.tableName;
		if ($get("showErrorInformation")) {
			try {
				local.rv = $getColumnInfo(argumentCollection=local.args);
			} catch (any e) {
				Throw(
					type="Wheels.TableNotFound",
					message="The `#arguments.tableName#` table could not be found in the database.<br>`#e.message#`<br>`#e.detail#.`",
					extendedInfo="Add a table named `#arguments.tableName#` to your database or tell CFWheels to use a different table for this model. For example you can tell a `user` model to use a table called `tbl_users` by creating a `User.cfc` file in the `models` folder, creating an `init` method inside it and then calling `table(""tbl_users"")` from within it. You can also issue a reload request, if you have made changes to your files, to make CFWheels pick up on those changes."
				);
			}
		} else {
			local.rv = $getColumnInfo(argumentCollection=local.args);
		}
		return local.rv;
	}

	/**
	 * Internal function.
	 */
	public string function $getValidationType(required string type) {
		switch(arguments.type) {
			case "CF_SQL_DECIMAL": case "CF_SQL_DOUBLE": case "CF_SQL_FLOAT": case "CF_SQL_MONEY": case "CF_SQL_MONEY4": case "CF_SQL_NUMERIC": case "CF_SQL_REAL":
				return "float";
			case "CF_SQL_INTEGER": case "CF_SQL_BIGINT": case "CF_SQL_SMALLINT": case "CF_SQL_TINYINT":
				return "integer";
			case "CF_SQL_BINARY": case "CF_SQL_VARBINARY": case "CF_SQL_LONGVARBINARY": case "CF_SQL_BLOB": case "CF_SQL_CLOB":
				return "binary";
			case "CF_SQL_DATE": case "CF_SQL_TIME": case "CF_SQL_TIMESTAMP":
				return "datetime";
			case "CF_SQL_BIT":
				return "boolean";
			case "CF_SQL_ARRAY":
				return "array";
			case "CF_SQL_STRUCT":
				return "struct";
			default:
				return "string";
		}
	}

	/**
	 * Internal function.
	 */
	public string function $cleanInStatementValue(required string statement) {
		local.rv = arguments.statement;
		local.delim = ",";
		if (Find("'", local.rv)) {
			local.delim = "','";
			local.rv = RemoveChars(local.rv, 1, 1);
			local.rv = Reverse(RemoveChars(Reverse(local.rv), 1, 1));
			local.rv = Replace(local.rv, "''", "'", "all");
		}
		return ReplaceNoCase(local.rv, local.delim, Chr(7), "all");
	}

	/**
	 * Internal function.
	 */
	public struct function $queryParams(required struct settings) {
		if (!StructKeyExists(arguments.settings, "value")) {
			Throw(
				type="Wheels.QueryParamValue",
				message="The value for `cfqueryparam` cannot be determined",
				extendedInfo="This is usually caused by a syntax error in the `WHERE` statement, such as forgetting to quote strings for example."
			);
		}
		local.rv = {};
		local.rv.cfsqltype = arguments.settings.type;
		local.rv.value = arguments.settings.value;
		if (StructKeyExists(arguments.settings, "null")) {
			local.rv.null = arguments.settings.null;
		}
		if (StructKeyExists(arguments.settings, "scale") && arguments.settings.scale > 0) {
			local.rv.scale = arguments.settings.scale;
		}
		if (StructKeyExists(arguments.settings, "list") && arguments.settings.list) {
			local.rv.list = arguments.settings.list;
			local.rv.separator = Chr(7);
			local.rv.value = $cleanInStatementValue(local.rv.value);
		}
		return local.rv;
	}

	/**
	 * Get information about the table using cfdbinfo.
	 * Individual database adapters will override when necessary.
	 */
	public query function $getColumnInfo(
		required string table,
		required string datasource,
		required string username,
		required string password
	) {
		arguments.type = "columns";
		return $dbinfo(argumentCollection=arguments);
	}

	/**
	 * Internal function.
	 */
	public string function $quoteValue(required string str, string sqlType="CF_SQL_VARCHAR", string type) {
		if (!StructKeyExists(arguments, "type")) {
			arguments.type = $getValidationType(arguments.sqlType);
		}
		if (!ListFindNoCase("integer,float,boolean", arguments.type) || !Len(arguments.str)) {
			local.rv = "'#arguments.str#'";
		} else {
			local.rv = arguments.str;
		}
		return local.rv;
	}

	/**
	 * Internal function.
	 */
	public struct function $convertMaxRowsToLimit(required struct args) {
		local.rv = arguments.args;
		if (StructKeyExists(local.rv, "maxRows") && local.rv.maxRows > 0) {
			if (local.rv.maxRows > 0) {
				local.rv.limit = local.rv.maxRows;
			}
			StructDelete(local.rv, "maxRows");
		}
		return local.rv;
	}

	/**
	 * Internal function.
	 */
	public string function $comment(required string text) {
		return "/* " & arguments.text & " */";
	}

	/**
	 * Internal function.
	 */
	public struct function $performQuery(
	  required array sql,
	  required boolean parameterize,
	  numeric limit=0,
	  numeric offset=0,
	  string $primaryKey="",
	  string $debugName="query"
	) {
		local.queryAttributes = {};
		local.queryAttributes.dataSource = variables.dataSource;
		local.queryAttributes.username = variables.username;
		local.queryAttributes.password = variables.password;
		local.queryAttributes.result = "local.$wheels.result";
		local.queryAttributes.name = "local." & arguments.$debugName;
		if (StructKeyExists(local.queryAttributes, "username") && !Len(local.queryAttributes.username)) {
			StructDelete(local.queryAttributes, "username");
		}
		if (StructKeyExists(local.queryAttributes, "password") && !Len(local.queryAttributes.password)) {
			StructDelete(local.queryAttributes, "password");
		}

		// Set queries in Lucee to not preserve single quotes on the entire cfquery block (we'll handle this individually in the SQL statement instead).
		if ($get("serverName") == "Lucee") {
			local.queryAttributes.psq = false;
		}

		// Add a key as a comment for cached queries to ensure query is unique for the life of this application.
		local.comment = "";
		if (StructKeyExists(arguments, "cachedwithin")) {
			local.comment = $comment("cachekey:#$get("cacheKey")#");
		}

		// Overloaded arguments are settings for the query.
		local.orgArgs = Duplicate(arguments);
		StructDelete(local.orgArgs, "sql");
		StructDelete(local.orgArgs, "parameterize");
		StructDelete(local.orgArgs, "$debugName");
		StructDelete(local.orgArgs, "limit");
		StructDelete(local.orgArgs, "offset");
		StructDelete(local.orgArgs, "$primaryKey");
		StructAppend(local.queryAttributes, local.orgArgs);
		return $executeQuery(
			queryAttributes=local.queryAttributes,
			sql=arguments.sql,
			parameterize=arguments.parameterize,
			limit=arguments.limit,
			offset=arguments.offset,
			comment=local.comment,
			debugName=arguments.$debugName,
			primaryKey=arguments.$primaryKey
		);
	}

	include "../../plugins/standalone/injection.cfm";
}

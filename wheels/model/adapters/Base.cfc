<cfcomponent output="false">
	<cfscript>
		include "../../global/cfml.cfm";

		public any function init(
		  required string dataSource,
		  required string username,
		  required string password
		) {
			variables.dataSource = arguments.dataSource;
			variables.username = arguments.username;
			variables.password = arguments.password;
			return this;
		}

		public string function $defaultValues() {
			local.rv = " DEFAULT VALUES";
			return local.rv;
		}

		public string function $tableName(required string list, required string action) {
			local.rv = "";
			local.iEnd = ListLen(arguments.list);
			for (local.i = 1; local.i <= local.iEnd; local.i++) {
				local.item = ListGetAt(arguments.list, local.i);
				if (arguments.action == "remove") {
					// removes table names
					local.item = ListRest(local.item, ".");
				}
				local.rv = ListAppend(local.rv, local.item);
			}
			return local.rv;
		}

		public string function $tableAlias(required string table, required string alias) {
			local.rv = arguments.table & " AS " & arguments.alias;
			return local.rv;
		}

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
					if (arguments.action == "keep") {
						// keeps the alias only
						local.item = local.alias;
					} else if (arguments.action == "remove") {
						// removes the alias
						local.item = Replace(local.item, " AS " & local.alias, "");
					}
					local.item &= local.sort;
				}
				local.rv = ListAppend(local.rv, local.item);
			}
			return local.rv;
		}

		public array function $removeColumnAliasesInOrderClause(required array sql) {
			local.rv = arguments.sql;
			if (IsSimpleValue(local.rv[ArrayLen(local.rv)]) && Left(local.rv[ArrayLen(local.rv)], 9) == "ORDER BY ") {
				// remove the column aliases from the order by clause (this is passed in so that we can handle sub queries with calculated properties)
				local.pos = ArrayLen(local.rv);
				local.list = ReplaceNoCase(local.rv[local.pos], "ORDER BY ", "");
				local.rv[local.pos] = "ORDER BY " & $columnAlias(list=local.list, action="remove");
			}
			return local.rv;
		}

		public boolean function $isAggregateFunction(required string sql) {
			// find "(FUNCTION(..." pattern inside the sql
			local.match = REFind("^\([A-Z]+\(", arguments.sql, 0, true);

			// guard against invalid match
			if (ArrayLen(local.match.pos) == 0) {
				local.rv = false;
			} else if (local.match.len[1] <= 2) {
				local.rv = false;
			} else {
				// extract and analyze the function name
				local.name = Mid(arguments.sql, local.match.pos[1]+1, local.match.len[1]-2);
				local.rv = ListContains("AVG,COUNT,MAX,MIN,SUM", local.name);
			}
			return local.rv;
		}

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
    * retrieves all the column information from a table
    */
		public query function $getColumns(required string tableName) {
			local.args = {};
			local.args.dataSource = variables.dataSource;
			local.args.username = variables.username;
			local.args.password = variables.password;
			local.args.table = arguments.tableName;
			if (application.wheels.showErrorInformation) {
				try {
					local.rv = $getColumnInfo(argumentCollection=local.args);
				} catch (any e) {
					$throw(type="Wheels.TableNotFound", message="The `#arguments.tableName#` table could not be found in the database.", extendedInfo="Add a table named `#arguments.tableName#` to your database or tell CFWheels to use a different table for this model. For example you can tell a `user` model to use a table called `tbl_users` by creating a `User.cfc` file in the `models` folder, creating an `init` method inside it and then calling `table(""tbl_users"")` from within it. #e.message# #e.detail#");
				}
			} else {
				local.rv = $getColumnInfo(argumentCollection=local.args);
			}
			return local.rv;
		}

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

		public string function $cleanInStatementValue(required string statement) {
			local.rv = arguments.statement;
			local.delim = ",";
			if (Find("'", local.rv)) {
				local.delim = "','";
				local.rv = RemoveChars(local.rv, 1, 1);
				local.rv = Reverse(RemoveChars(Reverse(local.rv), 1, 1));
				local.rv = Replace(local.rv, "''", "'", "all");
			}
			local.rv = ReplaceNoCase(local.rv, local.delim, Chr(7), "all");
			return local.rv;
		}

		public struct function $CFQueryParameters(required struct settings) {
			if (!StructKeyExists(arguments.settings, "value")) {
				$throw(type="Wheels.QueryParamValue", message="The value for `cfqueryparam` cannot be determined", extendedInfo="This is usually caused by a syntax error in the `WHERE` statement, such as forgetting to quote strings for example.");
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

		public query function $getColumnInfo(
		  required string table,
		  required string datasource,
		  required string username,
		  required string password
		) {
			arguments.type = "columns";
			local.rv = $dbinfo(argumentCollection=arguments);
			return local.rv;
		}

		public string function $quoteValue(
		  required string str,
		  string sqlType="CF_SQL_VARCHAR",
		  string type
		) {
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

		public string function $comment(required string text) {
			return "/* " & arguments.text & " */";
		}

		include "../../plugins/injection.cfm";
</cfscript>

	<cffunction name="$performQuery" returntype="struct" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfargument name="parameterize" type="boolean" required="true">
		<cfargument name="limit" type="numeric" required="false" default="0">
		<cfargument name="offset" type="numeric" required="false" default="0">
		<cfargument name="$primaryKey" type="string" required="false" default="">
		<cfscript>
			var query = {};
			local.rv = {};
			local.args = {};
			local.args.dataSource = variables.dataSource;
			local.args.username = variables.username;
			local.args.password = variables.password;
			local.args.result = "local.result";
			local.args.name = "query.name";
			if (StructKeyExists(local.args, "username") && !Len(local.args.username)) {
				StructDelete(local.args, "username");
			}
			if (StructKeyExists(local.args, "password") && !Len(local.args.password)) {
				StructDelete(local.args, "password");
			}

			// set queries in Lucee to not preserve single quotes on the entire
			// cfquery block (we'll handle this individually in the SQL statement instead)
			if (application.wheels.serverName == "Lucee") {
				local.args.psq = false;
			}

			// add a key as a comment for cached queries to ensure query is unique for the life of this application
			if (StructKeyExists(arguments, "cachedwithin")) {
				local.comment = $comment("cachekey:#application.wheels.cachekey#");
			}

			// overloaded arguments are settings for the query
			local.orgArgs = Duplicate(arguments);
			StructDelete(local.orgArgs, "sql");
			StructDelete(local.orgArgs, "parameterize");
			StructDelete(local.orgArgs, "limit");
			StructDelete(local.orgArgs, "offset");
			StructDelete(local.orgArgs, "$primaryKey");
			StructAppend(local.args, local.orgArgs);
		</cfscript>
		<cfquery attributeCollection="#local.args#"><cfset local.pos = 0><cfloop array="#arguments.sql#" index="local.i"><cfset local.pos = local.pos + 1><cfif IsStruct(local.i)><cfset local.queryParamAttributes = $CFQueryParameters(local.i)><cfif NOT IsBinary(local.i.value) AND local.i.value IS "null" AND local.pos GT 1 AND (Right(arguments.sql[local.pos-1], 2) IS "IS" OR Right(arguments.sql[local.pos-1], 6) IS "IS NOT")>NULL<cfelseif StructKeyExists(local.queryParamAttributes, "list")><cfif arguments.parameterize>(<cfqueryparam attributeCollection="#local.queryParamAttributes#">)<cfelse>(#PreserveSingleQuotes(local.i.value)#)</cfif><cfelse><cfif arguments.parameterize><cfqueryparam attributeCollection="#local.queryParamAttributes#"><cfelse>#$quoteValue(str=local.i.value, sqlType=local.i.type)#</cfif></cfif><cfelse><cfset local.i = Replace(PreserveSingleQuotes(local.i), "[[comma]]", ",", "all")>#PreserveSingleQuotes(local.i)#</cfif>#chr(13)##chr(10)#</cfloop><cfif arguments.limit>LIMIT #arguments.limit#<cfif arguments.offset>#chr(13)##chr(10)#OFFSET #arguments.offset#</cfif></cfif><cfif StructKeyExists(local, "comment")>#local.comment#</cfif></cfquery>
		<cfscript>
			if (StructKeyExists(query, "name")) {
				local.rv.query = query.name;
			}

			// get/set the primary key value if necessary
			// will be done on insert statement involving auto-incremented primary keys when Lucee/ACF cannot retrieve it for us
			// this happens on non-supported databases (example: H2) and drivers (example: jTDS)
			local.$id = $identitySelect(queryAttributes=local.args, result=local.result, primaryKey=arguments.$primaryKey);
			if (StructKeyExists(local, "$id")) {
				StructAppend(local.result, local.$id);
			}

			local.rv.result = local.result;
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

</cfcomponent>

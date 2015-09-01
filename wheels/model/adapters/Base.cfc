<cfcomponent output="false">
	<cfinclude template="../../global/cfml.cfm">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="datasource" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfscript>
			variables.instance.connection = arguments;
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="$defaultValues" returntype="string" access="public" output="false">
		<cfscript>
			var loc = {};
			loc.rv = " DEFAULT VALUES";
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$tableName" returntype="string" access="public" output="false">
		<cfargument name="list" type="string" required="true">
		<cfargument name="action" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.rv = "";
			loc.iEnd = ListLen(arguments.list);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(arguments.list, loc.i);
				if (arguments.action == "remove")
				{
					// removes table names
					loc.item = ListRest(loc.item, ".");
				}
				loc.rv = ListAppend(loc.rv, loc.item);
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$tableAlias" returntype="string" access="public" output="false">
		<cfargument name="table" type="string" required="true">
		<cfargument name="alias" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.rv = arguments.table & " AS " & arguments.alias;
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$columnAlias" returntype="string" access="public" output="false">
		<cfargument name="list" type="string" required="true">
		<cfargument name="action" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.rv = "";
			loc.iEnd = ListLen(arguments.list);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(arguments.list, loc.i);
				if (Find(" AS ", loc.item))
				{
					loc.sort = "";
					if (Right(loc.item, 4) == " ASC" || Right(loc.item, 5) == " DESC")
					{
						loc.sort = " " & Reverse(SpanExcluding(Reverse(loc.item), " "));
						loc.item = Mid(loc.item, 1, Len(loc.item)-Len(loc.sort));
					}
					loc.alias = Reverse(SpanExcluding(Reverse(loc.item), " "));
					if (arguments.action == "keep")
					{
						// keeps the alias only
						loc.item = loc.alias;
					}
					else if (arguments.action == "remove")
					{
						// removes the alias
						loc.item = Replace(loc.item, " AS " & loc.alias, "");
					}
					loc.item &= loc.sort;
				}
				loc.rv = ListAppend(loc.rv, loc.item);
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$removeColumnAliasesInOrderClause" returntype="array" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfscript>
			var loc = {};
			loc.rv = arguments.sql;
			if (IsSimpleValue(loc.rv[ArrayLen(loc.rv)]) && Left(loc.rv[ArrayLen(loc.rv)], 9) == "ORDER BY ")
			{
				// remove the column aliases from the order by clause (this is passed in so that we can handle sub queries with calculated properties)
				loc.pos = ArrayLen(loc.rv);
				loc.list = ReplaceNoCase(loc.rv[loc.pos], "ORDER BY ", "");
				loc.rv[loc.pos] = "ORDER BY " & $columnAlias(list=loc.list, action="remove");
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$isAggregateFunction" returntype="boolean" access="public" output="false">
		<cfargument name="sql" type="string" required="true">
		<cfscript>
			var loc = {};

			// find "(FUNCTION(..." pattern inside the sql
			loc.match = REFind("^\([A-Z]+\(", arguments.sql, 0, true);

			// guard against invalid match
			if (ArrayLen(loc.match.pos) == 0)
			{
				loc.rv = false;
			}
			else if (loc.match.len[1] <= 2)
			{
				loc.rv = false;
			}
			else
			{
				// extract and analyze the function name
				loc.name = Mid(arguments.sql, loc.match.pos[1]+1, loc.match.len[1]-2);
				loc.rv = ListContains("AVG,COUNT,MAX,MIN,SUM", loc.name);
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$addColumnsToSelectAndGroupBy" returntype="array" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfscript>
			var loc = {};
			loc.rv = arguments.sql;
			if (IsSimpleValue(loc.rv[ArrayLen(loc.rv)]) && Left(loc.rv[ArrayLen(loc.rv)], 8) == "ORDER BY" && IsSimpleValue(loc.rv[ArrayLen(loc.rv)-1]) && Left(loc.rv[ArrayLen(loc.rv)-1], 8) == "GROUP BY")
			{
				loc.iEnd = ListLen(loc.rv[ArrayLen(loc.rv)]);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.item = Trim(ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(ListGetAt(loc.rv[ArrayLen(loc.rv)], loc.i), "ORDER BY ", ""), " ASC", ""), " DESC", ""));
					if (!ListFindNoCase(ReplaceNoCase(loc.rv[ArrayLen(loc.rv)-1], "GROUP BY ", ""), loc.item) && !$isAggregateFunction(loc.item))
					{
						loc.key = ArrayLen(loc.rv)-1;
						loc.rv[loc.key] = ListAppend(loc.rv[loc.key], loc.item);
					}
				}
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$getColumns" returntype="query" access="public" output="false" hint="retrieves all the column information from a table">
		<cfargument name="tableName" type="string" required="true" hint="the table to retrieve column information for">
		<cfscript>
			var loc = {};
			loc.args = Duplicate(variables.instance.connection);
			loc.args.table = arguments.tableName;
			if (application.wheels.showErrorInformation)
			{
				try
				{
					loc.rv = $getColumnInfo(argumentCollection=loc.args);
				}
				catch (any e)
				{
					$throw(type="Wheels.TableNotFound", message="The `#arguments.tableName#` table could not be found in the database.", extendedInfo="Add a table named `#arguments.tableName#` to your database or tell CFWheels to use a different table for this model. For example you can tell a `user` model to use a table called `tbl_users` by creating a `User.cfc` file in the `models` folder, creating an `init` method inside it and then calling `table(""tbl_users"")` from within it.");
				}
			}
			else
			{
				loc.rv = $getColumnInfo(argumentCollection=loc.args);
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$getValidationType" returntype="string" access="public" output="false">
		<cfargument name="type" type="string" required="true">
		<cfswitch expression="#arguments.type#">
			<cfcase value="CF_SQL_DECIMAL,CF_SQL_DOUBLE,CF_SQL_FLOAT,CF_SQL_MONEY,CF_SQL_MONEY4,CF_SQL_NUMERIC,CF_SQL_REAL" delimiters=",">
				<cfreturn "float">
			</cfcase>
			<cfcase value="CF_SQL_INTEGER,CF_SQL_BIGINT,CF_SQL_SMALLINT,CF_SQL_TINYINT" delimiters=",">
				<cfreturn "integer">
			</cfcase>
			<cfcase value="CF_SQL_BINARY,CF_SQL_VARBINARY,CF_SQL_LONGVARBINARY,CF_SQL_BLOB,CF_SQL_CLOB" delimiters=",">
				<cfreturn "binary">
			</cfcase>
			<cfcase value="CF_SQL_DATE,CF_SQL_TIME,CF_SQL_TIMESTAMP" delimiters=",">
				<cfreturn "datetime">
			</cfcase>
			<cfcase value="CF_SQL_BIT" delimiters=",">
				<cfreturn "boolean">
			</cfcase>
			<cfcase value="CF_SQL_ARRAY" delimiters=",">
				<cfreturn "array">
			</cfcase>
			<cfcase value="CF_SQL_STRUCT" delimiters=",">
				<cfreturn "struct">
			</cfcase>
			<cfdefaultcase>
				<cfreturn "string">
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="$cleanInStatementValue" returntype="string" access="public" output="false">
		<cfargument name="statement" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.rv = arguments.statement;
			loc.delim = ",";
			if (Find("'", loc.rv))
			{
				loc.delim = "','";
				loc.rv = RemoveChars(loc.rv, 1, 1);
				loc.rv = Reverse(RemoveChars(Reverse(loc.rv), 1, 1));
				loc.rv = Replace(loc.rv, "''", "'", "all");
			}
			loc.rv = ReplaceNoCase(loc.rv, loc.delim, Chr(7), "all");
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$CFQueryParameters" returntype="struct" access="public" output="false">
		<cfargument name="settings" type="struct" required="true">
		<cfscript>
			var loc = {};
			if (!StructKeyExists(arguments.settings, "value"))
			{
				$throw(type="Wheels.QueryParamValue", message="The value for `cfqueryparam` cannot be determined", extendedInfo="This is usually caused by a syntax error in the `WHERE` statement, such as forgetting to quote strings for example.");
			}
			loc.rv = {};
			loc.rv.cfsqltype = arguments.settings.type;
			loc.rv.value = arguments.settings.value;
			if (StructKeyExists(arguments.settings, "null"))
			{
				loc.rv.null = arguments.settings.null;
			}
			if (StructKeyExists(arguments.settings, "scale") && arguments.settings.scale > 0)
			{
				loc.rv.scale = arguments.settings.scale;
			}
			if (StructKeyExists(arguments.settings, "list") && arguments.settings.list)
			{
				loc.rv.list = arguments.settings.list;
				loc.rv.separator = Chr(7);
				loc.rv.value = $cleanInStatementValue(loc.rv.value);
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$performQuery" returntype="struct" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfargument name="parameterize" type="boolean" required="true">
		<cfargument name="limit" type="numeric" required="false" default="0">
		<cfargument name="offset" type="numeric" required="false" default="0">
		<cfargument name="connection" type="struct" required="false" default="#variables.instance.connection#">
		<cfargument name="$primaryKey" type="string" required="false" default="">
		<cfscript>
			var loc = {};
			var query = {};
			loc.rv = {};
			loc.args = Duplicate(arguments.connection);
			loc.args.result = "loc.result";
			loc.args.name = "query.name";
			if (StructKeyExists(loc.args, "username") && !Len(loc.args.username))
			{
				StructDelete(loc.args, "username");
			}
			if (StructKeyExists(loc.args, "password") && !Len(loc.args.password))
			{
				StructDelete(loc.args, "password");
			}

			// set queries in Railo/Lucee to not preserve single quotes on the entire
			// cfquery block (we'll handle this individually in the SQL statement instead)
			if (application.wheels.serverName == "Railo" || application.wheels.serverName == "Lucee")
			{
				loc.args.psq = false;
			}

			// overloaded arguments are settings for the query
			loc.orgArgs = Duplicate(arguments);
			StructDelete(loc.orgArgs, "sql");
			StructDelete(loc.orgArgs, "parameterize");
			StructDelete(loc.orgArgs, "limit");
			StructDelete(loc.orgArgs, "offset");
			StructDelete(loc.orgArgs, "$primaryKey");
			StructAppend(loc.args, loc.orgArgs);
		</cfscript>
		<cfquery attributeCollection="#loc.args#"><cfset loc.pos = 0><cfloop array="#arguments.sql#" index="loc.i"><cfset loc.pos = loc.pos + 1><cfif IsStruct(loc.i)><cfset loc.queryParamAttributes = $CFQueryParameters(loc.i)><cfif NOT IsBinary(loc.i.value) AND loc.i.value IS "null" AND loc.pos GT 1 AND (Right(arguments.sql[loc.pos-1], 2) IS "IS" OR Right(arguments.sql[loc.pos-1], 6) IS "IS NOT")>NULL<cfelseif StructKeyExists(loc.queryParamAttributes, "list")><cfif arguments.parameterize>(<cfqueryparam attributeCollection="#loc.queryParamAttributes#">)<cfelse>(#PreserveSingleQuotes(loc.i.value)#)</cfif><cfelse><cfif arguments.parameterize><cfqueryparam attributeCollection="#loc.queryParamAttributes#"><cfelse>#$quoteValue(str=loc.i.value, sqlType=loc.i.type)#</cfif></cfif><cfelse><cfset loc.i = Replace(PreserveSingleQuotes(loc.i), "[[comma]]", ",", "all")>#PreserveSingleQuotes(loc.i)#</cfif>#chr(13)##chr(10)#</cfloop><cfif arguments.limit>LIMIT #arguments.limit#<cfif arguments.offset>#chr(13)##chr(10)#OFFSET #arguments.offset#</cfif></cfif></cfquery>
		<cfscript>
			if (StructKeyExists(query, "name"))
			{
				loc.rv.query = query.name;
			}

			// get/set the primary key value if necessary
			// will be done on insert statement involving auto-incremented primary keys when Railo/ACF cannot retrieve it for us
			// this happens on non-supported databases (example: H2) and drivers (example: jTDS)
			loc.$id = $identitySelect(queryAttributes=loc.args, result=loc.result, primaryKey=arguments.$primaryKey);
			if (StructKeyExists(loc, "$id"))
			{
				StructAppend(loc.result, loc.$id);
			}

			loc.rv.result = loc.result;
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$getColumnInfo" returntype="query" access="public" output="false">
		<cfargument name="table" type="string" required="true">
		<cfargument name="datasource" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfscript>
			var loc = {};
			arguments.type = "columns";
			loc.rv = $dbinfo(argumentCollection=arguments);
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$quoteValue" returntype="string" access="public" output="false">
		<cfargument name="str" type="string" required="true" hint="string to quote">
		<cfargument name="sqlType" type="string" default="CF_SQL_VARCHAR" hint="sql column type for data">
		<cfargument name="type" type="string" required="false" hint="validation type for data">
		<cfscript>
			var loc = {};
			if (!StructKeyExists(arguments, "type"))
			{
				arguments.type = $getValidationType(arguments.sqlType);
			}
			if (!ListFindNoCase("integer,float,boolean", arguments.type) || !Len(arguments.str))
			{
				loc.rv = "'#arguments.str#'";
			}
			else
			{
				loc.rv = arguments.str;
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$convertMaxRowsToLimit" returntype="struct" access="public" output="false">
		<cfargument name="args" type="struct" required="true">
		<cfscript>
			var loc = {};
			loc.rv = arguments.args;
			if (StructKeyExists(loc.rv, "maxRows") && loc.rv.maxRows > 0)
			{
				if (loc.rv.maxRows > 0)
				{
					loc.rv.limit = loc.rv.maxRows;
				}
				StructDelete(loc.rv, "maxRows");
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cfinclude template="../../plugins/injection.cfm">
</cfcomponent>
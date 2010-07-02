<cfcomponent output="false">
	<cfinclude template="../../global/cfml.cfm">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="datasource" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset variables.instance.connection = arguments>
		<cfreturn this>
	</cffunction>

	<cffunction name="$tableName" returntype="string" access="public" output="false">
		<cfargument name="list" type="string" required="true">
		<cfargument name="action" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.returnValue = "";
			loc.iEnd = ListLen(arguments.list);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = ListGetAt(arguments.list, loc.i);
				if (arguments.action == "remove")
					loc.iItem = ListRest(loc.iItem, "."); // removes table names
				loc.returnValue = ListAppend(loc.returnValue, loc.iItem);
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="$columnAlias" returntype="string" access="public" output="false">
		<cfargument name="list" type="string" required="true">
		<cfargument name="action" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.returnValue = "";
			loc.iEnd = ListLen(arguments.list);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = ListGetAt(arguments.list, loc.i);
				if (Find(" AS ", loc.iItem))
				{
					loc.sort = "";
					if (Right(loc.iItem, 4) == " ASC" || Right(loc.iItem, 5) == " DESC")
					{
						loc.sort = " " & Reverse(SpanExcluding(Reverse(loc.iItem), " "));
						loc.iItem = Mid(loc.iItem, 1, Len(loc.iItem)-Len(loc.sort));
					}
					loc.alias = Reverse(SpanExcluding(Reverse(loc.iItem), " "));
					if (arguments.action == "keep")
							loc.iItem = loc.alias; // keeps the alias only
					else if (arguments.action == "remove")
						loc.iItem = Replace(loc.iItem, " AS " & loc.alias, ""); // removes the alias
					loc.iItem = loc.iItem & loc.sort;
				}
				loc.returnValue = ListAppend(loc.returnValue, loc.iItem);
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="$removeColumnAliasesInOrderClause" returntype="array" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfscript>
			var loc = {};
			loc.returnValue = arguments.sql;
			if (IsSimpleValue(loc.returnValue[ArrayLen(loc.returnValue)]) && Left(loc.returnValue[ArrayLen(loc.returnValue)], 9) == "ORDER BY ")
			{
				// remove the column aliases from the order by clause (this is passed in so that we can handle sub queries with calculated properties)
				loc.pos = ArrayLen(loc.returnValue);
				loc.orderByClause = ReplaceNoCase(loc.returnValue[loc.pos], "ORDER BY ", "");
				loc.returnValue[loc.pos] = "ORDER BY " & $columnAlias(list=loc.orderByClause, action="remove");
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="$getColumns" returntype="query" access="public" output="false"
		hint="retrieves all the column information from a table">
		<cfargument name="tableName" type="string" required="true" hint="the table to retrieve column information for">
		<cfscript>
		var loc = {};
		loc.args = duplicate(variables.instance.connection);
		loc.args.table = arguments.tableName;
		loc.args.type = "columns";
		if (application.wheels.showErrorInformation)
		{
			try
			{
				loc.columns = $dbinfo(argumentCollection=loc.args);
			}
			catch (Any e)
			{
				$throw(type="Wheels.TableNotFound", message="The `#arguments.tableName#` table could not be found in the database.", extendedInfo="Add a table named `#arguments.tableName#` to your database or tell Wheels to use a different table for this model. For example you can tell a `user` model to use a table called `tbl_users` by creating a `User.cfc` file in the `models` folder, creating an `init` method inside it and then calling `table(""tbl_users"")` from within it.");
			}
		}
		else
		{
			loc.columns = $dbinfo(argumentCollection=loc.args);
		}
		</cfscript>
		<cfreturn loc.columns>
	</cffunction>

	<cffunction name="$getValidationType" returntype="string" access="public" output="false">
		<cfargument name="type" type="string" required="true">
		<cfswitch expression="#arguments.type#">
			<cfcase value="cf_sql_real,cf_sql_numeric,cf_sql_float,cf_sql_decimal,cf_sql_double" delimiters=",">
				<cfreturn "float">
			</cfcase>
			<cfcase value="cf_sql_tinyint,cf_sql_smallint,cf_sql_integer,cf_sql_bigint" delimiters=",">
				<cfreturn "integer">
			</cfcase>
			<cfcase value="cf_sql_char,cf_sql_varchar" delimiters=",">
				<cfreturn "string">
			</cfcase>
			<cfcase value="cf_sql_date,cf_sql_timestamp,cf_sql_time" delimiters=",">
				<cfreturn "datetime">
			</cfcase>
			<cfdefaultcase>
				<cfreturn "">
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="$cleanInStatmentValue" returntype="string" access="public" output="false">
		<cfargument name="statement" type="string" required="true">
		<cfscript>
		var loc = {};
		loc.delim = ",";
		if (Find("'", arguments.statement))
		{
			loc.delim = "','";
			arguments.statement = RemoveChars(arguments.statement, 1, 1);
			arguments.statement = reverse(RemoveChars(reverse(arguments.statement), 1, 1));
			arguments.statement = Replace(arguments.statement, "''", "'", "all");
		}
		arguments.statement = ReplaceNoCase(arguments.statement, loc.delim, chr(7), "all");
		</cfscript>
		<cfreturn arguments.statement>
	</cffunction>
	
	<cffunction name="$CFQueryParameters" returntype="struct" access="public" output="false">
		<cfargument name="settings" type="struct" required="true">
		<cfscript>
		var loc = {};
		loc.params = {};
		loc.params.cfsqltype = arguments.settings.type;
		loc.params.value = arguments.settings.value;
		if (StructKeyExists(arguments.settings, "null"))
		{
			loc.params.null = arguments.settings.null;
		}
		if (StructKeyExists(arguments.settings, "scale") AND arguments.settings.scale GT 0)
		{
			loc.params.scale = arguments.settings.scale;
		}
		if (StructKeyExists(arguments.settings, "list") AND arguments.settings.list)
		{
			loc.params.list = arguments.settings.list;
			loc.params.separator = chr(7);
			loc.params.value = $cleanInStatmentValue(loc.params.value);
		}
		</cfscript>	
		<cfreturn loc.params>
	</cffunction>


</cfcomponent>
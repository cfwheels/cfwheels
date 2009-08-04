<cfcomponent output="false">

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

</cfcomponent>
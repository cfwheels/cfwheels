<cffunction name="$generatedKey" returntype="string" access="public" output="false">
	<cfreturn "identitycol">
</cffunction>

<cffunction name="$randomOrder" returntype="string" access="public" output="false">
	<cfreturn "NEWID()">
</cffunction>

<cffunction name="$getType" returntype="string" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		switch(arguments.type)
		{
			case "bigint": {loc.returnValue = "cf_sql_bigint"; break;}
			case "binary": case "timestamp": {loc.returnValue = "cf_sql_binary"; break;}
			case "bit": {loc.returnValue = "cf_sql_bit"; break;}
			case "char": case "nchar": case "uniqueidentifier": {loc.returnValue = "cf_sql_char"; break;}
			case "date": {loc.returnValue = "cf_sql_date"; break;}
			case "datetime": case "datetime2": case "smalldatetime": {loc.returnValue = "cf_sql_timestamp"; break;}
			case "decimal": case "money": case "smallmoney": {loc.returnValue = "cf_sql_decimal"; break;}
			case "float": {loc.returnValue = "cf_sql_float"; break;}
			case "int": {loc.returnValue = "cf_sql_integer"; break;}
			case "image": {loc.returnValue = "cf_sql_longvarbinary"; break;}
			case "text": case "ntext": case "xml": {loc.returnValue = "cf_sql_longvarchar";	break;}
			case "numeric":	{loc.returnValue = "cf_sql_numeric"; break;}
			case "real": {loc.returnValue = "cf_sql_real"; break;}
			case "smallint": {loc.returnValue = "cf_sql_smallint"; break;}
			case "time": {loc.returnValue = "cf_sql_time"; break;}
			case "tinyint":	{loc.returnValue = "cf_sql_tinyint"; break;}
			case "varbinary": {loc.returnValue = "cf_sql_varbinary"; break;}
			case "varchar": case "nvarchar": {loc.returnValue = "cf_sql_varchar"; break;}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$query" returntype="struct" access="public" output="false">
	<cfargument name="sql" type="array" required="true">
	<cfargument name="limit" type="numeric" required="false" default=0>
	<cfargument name="offset" type="numeric" required="false" default=0>
	<cfargument name="parameterize" type="boolean" required="true">
	<cfargument name="$primaryKey" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		var query = {};
		if (arguments.limit > 0)
		{
			if (arguments.sql[ArrayLen(arguments.sql)] Contains ",")
			{
				// fix for pagination issue when ordering multiple columns with same name
				loc.order = arguments.sql[ArrayLen(arguments.sql)];
				loc.newOrder = "";
				loc.doneColumns = "";
				loc.done = 0;
				loc.iEnd = ListLen(loc.order);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.item = ListGetAt(loc.order, loc.i);
					loc.column = SpanExcluding(Reverse(SpanExcluding(Reverse(loc.item), ".")), " ");
					if (ListFind(loc.doneColumns, loc.column))
					{
						loc.done++;
						loc.item = loc.item & " AS tmp" & loc.done; 
					}
					loc.doneColumns = ListAppend(loc.doneColumns, loc.column);
					loc.newOrder = ListAppend(loc.newOrder, loc.item);
				}
				arguments.sql[ArrayLen(arguments.sql)] = loc.newOrder;
			}

			// select clause always comes first in the array, the order by clause last, remove the leading keywords leaving only the columns and set to the ones used in the inner most sub query
			loc.thirdSelect = ReplaceNoCase(ReplaceNoCase(arguments.sql[1], "SELECT DISTINCT ", ""), "SELECT ", "");
			loc.thirdOrder = ReplaceNoCase(arguments.sql[ArrayLen(arguments.sql)], "ORDER BY ", "");
	
			// the first select is the outer most in the query and need to contain columns without table names and using aliases when they exist
			loc.firstSelect = $columnAlias(list=$tableName(list=loc.thirdSelect, action="remove"), action="keep");

			// we need to add columns from the inner order clause to the select clauses in the inner two queries
			loc.iEnd = ListLen(loc.thirdOrder);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = ReplaceNoCase(ReplaceNoCase(ListGetAt(loc.thirdOrder, loc.i), " ASC", ""), " DESC", "");
				if (!ListFindNoCase(loc.thirdSelect, loc.iItem))
					loc.thirdSelect = ListAppend(loc.thirdSelect, loc.iItem);
			}

			// the second select also needs to contain columns without table names and using aliases when they exist (but now including the columns added above)
			loc.secondSelect = $columnAlias(list=$tableName(list=loc.thirdSelect, action="remove"), action="keep");

			// first order also needs the table names removed, the column aliases can be kept since they are removed before running the query anyway
			loc.firstOrder = $tableName(list=loc.thirdOrder, action="remove");

			// second order clause is the same as the first but with the ordering reversed
			loc.secondOrder = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(loc.firstOrder, " DESC", chr(7), "all"), " ASC", " DESC", "all"), chr(7), " ASC", "all");

			// fix column aliases from order by clauses
			loc.thirdOrder = $columnAlias(list=loc.thirdOrder, action="remove");
			loc.secondOrder = $columnAlias(list=loc.secondOrder, action="keep");
			loc.firstOrder = $columnAlias(list=loc.firstOrder, action="keep");

			// build new sql string and replace the old one with it
			loc.beforeWhere = "SELECT " & loc.firstSelect & " FROM (SELECT TOP " & arguments.limit & " " & loc.secondSelect & " FROM (SELECT ";
			if (ListRest(arguments.sql[2], " ") Contains " ")
				loc.beforeWhere = loc.beforeWhere & "DISTINCT ";
			loc.beforeWhere = loc.beforeWhere & "TOP " & arguments.limit+arguments.offset & " " & loc.thirdSelect & " " & arguments.sql[2];
			loc.afterWhere = "ORDER BY " & loc.thirdOrder & ") AS tmp1 ORDER BY " & loc.secondOrder & ") AS tmp2 ORDER BY " & loc.firstOrder;
			ArrayDeleteAt(arguments.sql, 1);
			ArrayDeleteAt(arguments.sql, 1);
			ArrayDeleteAt(arguments.sql, ArrayLen(arguments.sql));
			ArrayPrepend(arguments.sql, loc.beforeWhere);
			ArrayAppend(arguments.sql, loc.afterWhere);
		}
		else
		{
			arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
		}
		arguments.name = "query.name";
		arguments.result = "loc.result";
		arguments.datasource = variables.instance.connection.datasource;
		if (Len(variables.instance.connection.username))
			arguments.username = variables.instance.connection.username;
		if (Len(variables.instance.connection.password))
			arguments.password = variables.instance.connection.password;
		if (application.wheels.serverName == "Railo")
			arguments.psq = false; // set queries in Railo to not preserve single quotes on the entire cfquery block (we'll handle this individually in the SQL statement instead)  
		loc.sql = arguments.sql;
		loc.limit = arguments.limit;
		loc.offset = arguments.offset;
		loc.parameterize = arguments.parameterize;
		loc.primaryKey = arguments.$primaryKey;
		StructDelete(arguments, "sql");
		StructDelete(arguments, "limit");
		StructDelete(arguments, "offset");
		StructDelete(arguments, "parameterize");
		StructDelete(arguments, "$primaryKey");
	</cfscript>
	<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif IsBoolean(loc.parameterize) AND loc.parameterize><cfset loc.queryParamAttributes = StructNew()><cfset loc.queryParamAttributes.cfsqltype = loc.i.type><cfset loc.queryParamAttributes.value = loc.i.value><cfif StructKeyExists(loc.i, "null")><cfset loc.queryParamAttributes.null = loc.i.null></cfif><cfif StructKeyExists(loc.i, "scale") AND loc.i.scale GT 0><cfset loc.queryParamAttributes.scale = loc.i.scale></cfif><cfqueryparam attributeCollection="#loc.queryParamAttributes#"><cfelse>'#loc.i.value#'</cfif><cfelse>#Replace(PreserveSingleQuotes(loc.i), "[[comma]]", ",", "all")#</cfif>#chr(13)##chr(10)#</cfloop></cfquery>
	<cfscript>
		loc.returnValue.result = loc.result;
		if (StructKeyExists(query, "name"))
			loc.returnValue.query = query.name;
	</cfscript>
	<cfif StructKeyExists(server, "railo") AND StructKeyExists(loc.result, "sql") AND Left(loc.result.sql, 12) IS "INSERT INTO ">
		<!--- railo does not yet support the "identitycol" value returned from the cfquery tag so until they do we need to get it manually --->
		<cfquery attributeCollection="#arguments#">SELECT @@identity AS lastId</cfquery>
		<cfset loc.returnValue.result.identitycol = query.name.lastId>
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>
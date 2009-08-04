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
			case "decimal": case "money": case "smallmoney": {loc.returnValue = "cf_sql_decimal"; break;}
			case "float": {loc.returnValue = "cf_sql_float"; break;}
			case "int": {loc.returnValue = "cf_sql_integer";	break;}
			case "image": {loc.returnValue = "cf_sql_longvarbinary"; break;}
			case "text": case "ntext": {loc.returnValue = "cf_sql_longvarchar";	break;}
			case "numeric":	{loc.returnValue = "cf_sql_numeric"; break;}
			case "real": {loc.returnValue = "cf_sql_real"; break;}
			case "smallint": {loc.returnValue = "cf_sql_smallint"; break;}
			case "datetime": case "smalldatetime": {loc.returnValue = "cf_sql_timestamp"; break;}
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
			loc.select = ReplaceNoCase(arguments.sql[1], "SELECT ", "");
			loc.qualifiedOrder = ReplaceNoCase(arguments.sql[ArrayLen(arguments.sql)], "ORDER BY ", "");
			
			// the primary keys listed in the select clause needs to be added to the order clause as well for the query to work properly
			loc.iEnd = ListLen(loc.select);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = ListGetAt(loc.select, loc.i);
				if (!ListContainsNoCase(loc.qualifiedOrder, loc.iItem))
					loc.qualifiedOrder = ListAppend(loc.qualifiedOrder, "#loc.iItem# ASC");
			}
			
			// create the simple order clause (used in the two outer queries) by revoming the table names from the qualified select
			loc.simpleOrder = "";
			loc.iEnd = ListLen(loc.qualifiedOrder);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				loc.simpleOrder = ListAppend(loc.simpleOrder, ListLast(ListGetAt(loc.qualifiedOrder, loc.i), "."));
			
			// the select clauses are just a variation of the order by clause since we have to select what we order by anyway for the sub queries to work
			loc.simpleSelect = ReplaceNoCase(ReplaceNoCase(loc.simpleOrder, " DESC", "", "all"), " ASC", "", "all");
			loc.qualifiedSelect = ReplaceNoCase(ReplaceNoCase(loc.qualifiedOrder, " DESC", "", "all"), " ASC", "", "all");
			
			// remove any " AS " aliased columns from the order by clauses
			loc.newSimpleOrder = "";
			loc.iEnd = ListLen(loc.simpleOrder);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = ListGetAt(loc.simpleOrder, loc.i);
				if (!Find(" AS ", loc.iItem))
					loc.newSimpleOrder = ListAppend(loc.newSimpleOrder, loc.iItem);
			}
			loc.simpleOrder = loc.newSimpleOrder;
			loc.newQualifiedOrder = "";
			loc.iEnd = ListLen(loc.qualifiedOrder);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = ListGetAt(loc.qualifiedOrder, loc.i);
				if (!Find(" AS ", loc.iItem))
					loc.newQualifiedOrder = ListAppend(loc.newQualifiedOrder, loc.iItem);
			}
			loc.qualifiedOrder = loc.newQualifiedOrder;

			// create the outer most select clause, add the " AS " aliased columns first and then the others unless they already exist
			loc.firstSelect = "";
			loc.iEnd = ListLen(loc.simpleSelect);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = ListGetAt(loc.simpleSelect, loc.i);
				if (Find(" AS ", loc.iItem))
					loc.firstSelect = ListAppend(loc.firstSelect, loc.iItem);
			}
			loc.iEnd = ListLen(loc.simpleSelect);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = ListGetAt(loc.simpleSelect, loc.i);
				if (!Find(" AS ", loc.iItem) && !ListContainsNoCase(loc.firstSelect, loc.iItem & " AS "))
					loc.firstSelect = ListAppend(loc.firstSelect, loc.iItem);
			}

			// create the middle and inner most select clauses
			loc.secondSelect = "";
			loc.iEnd = ListLen(loc.simpleSelect);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = SpanExcluding(ListGetAt(loc.simpleSelect, loc.i), " ");
				if (!ListFindNoCase(loc.secondSelect, loc.iItem))
					loc.secondSelect = ListAppend(loc.secondSelect, loc.iItem);
			}
			loc.thirdSelect = "";
			loc.iEnd = ListLen(loc.qualifiedSelect);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = SpanExcluding(ListGetAt(loc.qualifiedSelect, loc.i), " ");
				if (!ListFindNoCase(loc.thirdSelect, loc.iItem))
					loc.thirdSelect = ListAppend(loc.thirdSelect, loc.iItem);
			}

			// reverse ordering for use in sub queries
			loc.simpleOrderReversed = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(loc.simpleOrder, "DESC", chr(7), "all"), "ASC", "DESC", "all"), chr(7), "ASC", "all");
			loc.qualifiedOrderReversed = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(loc.qualifiedOrder, "DESC", chr(7), "all"), "ASC", "DESC", "all"), chr(7), "ASC", "all");

			// create the entire sql statement and replace the old one passed in
			loc.beforeWhere = "SELECT " & loc.firstSelect & " FROM (SELECT TOP " & arguments.limit & " " & loc.secondSelect & " FROM (SELECT ";
			if (ListLast(arguments.sql[2], " ") Contains " ")
				loc.beforeWhere = loc.beforeWhere & "DISTINCT ";
			loc.beforeWhere = loc.beforeWhere & "TOP " & arguments.limit+arguments.offset & " " & loc.thirdSelect & " " & arguments.sql[2];
			loc.afterWhere = "ORDER BY " & loc.qualifiedOrder & ") AS tmp1 ORDER BY " & loc.simpleOrderReversed & ") AS tmp2 ORDER BY " & loc.simpleOrder;
			ArrayDeleteAt(arguments.sql, 1);
			ArrayDeleteAt(arguments.sql, 1);
			ArrayDeleteAt(arguments.sql, ArrayLen(arguments.sql));
			ArrayPrepend(arguments.sql, loc.beforeWhere);
			ArrayAppend(arguments.sql, loc.afterWhere);
		}
		arguments.name = "query.name";
		arguments.result = "loc.result";
		arguments.datasource = variables.instance.connection.datasource;
		arguments.username = variables.instance.connection.username;
		arguments.password = variables.instance.connection.password;
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
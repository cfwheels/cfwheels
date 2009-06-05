<cffunction name="$generatedKey" returntype="string" access="public" output="false">
	<cfreturn "">
</cffunction>

<cffunction name="$randomOrder" returntype="string" access="public" output="false">
	<cfreturn "random()">
</cffunction>

<cffunction name="$getType" returntype="string" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfscript>
		var loc = {};
		switch(arguments.type)
		{
			case "bigint": case "bigserial": {loc.returnValue = "cf_sql_bigint"; break;}
			case "bit": {loc.returnValue = "cf_sql_bit"; break;}
			case "bool": case "boolean": {loc.returnValue = "cf_sql_varchar"; break;}
			case "bytea": {loc.returnValue = "cf_sql_binary"; break;}
			case "char": case "character": {loc.returnValue = "cf_sql_char"; break;}
			case "date": case "timestamp": {loc.returnValue = "cf_sql_timestamp"; break;}
			case "decimal": case "double": case "precision": case "float": {loc.returnValue = "cf_sql_decimal"; break;}
			case "integer": case "int": case "int4": case "serial": case "oid": {loc.returnValue = "cf_sql_integer"; break;}  // oid cols should probably be avoided - placed here for completeness
			case "numeric": case "smallmoney": case "money": {loc.returnValue = "cf_sql_numeric"; break;}  // postgres has deprecated the money type: http://www.postgresql.org/docs/8.1/static/datatype-money.html
			case "real": {loc.returnValue = "cf_sql_real"; break;}
			case "smallint": {loc.returnValue = "cf_sql_smallint"; break;}
			case "text": {loc.returnValue = "cf_sql_longvarchar"; break;}
			case "varchar": case "character": case "varying": {loc.returnValue = "cf_sql_varchar"; break;}
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
			loc.beforeWhere = "SELECT * FROM (SELECT a.*, rownum rnum FROM (";
			loc.afterWhere = ") a WHERE rownum <=" & arguments.limit+arguments.offset & ")" & " WHERE rnum >" & arguments.offset;
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
	<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif IsBoolean(loc.parameterize) AND loc.parameterize><cfset loc.queryParamAttributes = StructNew()><cfset loc.queryParamAttributes.cfsqltype = loc.i.type><cfset loc.queryParamAttributes.value = loc.i.value><cfif StructKeyExists(loc.i, "null")><cfset loc.queryParamAttributes.null = loc.i.null></cfif><cfif StructKeyExists(loc.i, "scale") AND loc.i.scale GT 0><cfset loc.queryParamAttributes.scale = loc.i.scale></cfif><cfqueryparam attributeCollection="#loc.queryParamAttributes#"><cfelse>'#loc.i.value#'</cfif><cfelse>#preserveSingleQuotes(loc.i)#</cfif>#chr(13)##chr(10)#</cfloop></cfquery>
	<cfscript>
		loc.returnValue.result = loc.result;
		if (StructKeyExists(query, "name"))
			loc.returnValue.query = query.name;
	</cfscript>
	<cfif StructKeyExists(loc.result, "sql") AND Left(loc.result.sql, 12) IS "INSERT INTO ">
		<!--- the rowid value returned by ColdFusion is not the actual primary key value (unlike the way it works for sql server and mysql) so on insert statements we need to get that value out of the database using the rowid reference --->
		<cfset loc.tbl = SpanExcluding(Right(loc.result.sql, Len(loc.result.sql)-12), " ")>
		<cfquery attributeCollection="#arguments#">SELECT #loc.primaryKey# FROM #loc.tbl# WHERE ROWID = '#loc.result.rowid#'</cfquery>
		<cfset loc.returnValue.result.rowid = query.name[loc.primaryKey]>
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>
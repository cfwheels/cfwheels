<cfcomponent extends="Base" output="false">

	<cffunction name="$generatedKey" returntype="string" access="public" output="false">
		<cfscript>
			local.rv = "generated_key";
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$randomOrder" returntype="string" access="public" output="false">
		<cfscript>
			local.rv = "RAND()";
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$getType" returntype="string" access="public" output="false">
		<cfargument name="type" type="string" required="true">
		<cfscript>
			switch (arguments.type) {
				case "bigint": case "int8":
					local.rv = "cf_sql_bigint";
					break;
				case "binary": case "bytea": case "raw":
					local.rv = "cf_sql_binary";
					break;
				case "bit": case "bool": case "boolean":
					local.rv = "cf_sql_bit";
					break;
				case "blob": case "tinyblob": case "mediumblob": case "longblob": case "image": case "oid":
					local.rv = "cf_sql_blob";
					break;
				case "char": case "character": case "nchar":
					local.rv = "cf_sql_char";
					break;
				case "date":
					local.rv = "cf_sql_date";
					break;
				case "dec": case "decimal": case "number": case "numeric":
					local.rv = "cf_sql_decimal";
					break;
				case "double":
					local.rv = "cf_sql_double";
					break;
				case "float": case "float4": case "float8": case "real":
					local.rv = "cf_sql_float";
					break;
				case "int": case "int4": case "integer": case "mediumint": case "signed":
					local.rv = "cf_sql_integer";
					break;
				case "int2": case "smallint": case "year":
					local.rv = "cf_sql_smallint";
					break;
				case "time":
					local.rv = "cf_sql_time";
					break;
				case "datetime": case "smalldatetime": case "timestamp":
					local.rv = "cf_sql_timestamp";
					break;
				case "tinyint":
					local.rv = "cf_sql_tinyint";
					break;
				case "varbinary": case "longvarbinary":
					local.rv = "cf_sql_varbinary";
					break;
				case "varchar": case "varchar2": case "longvarchar": case "varchar_ignorecase": case "nvarchar": case "nvarchar2": case "clob": case "nclob": case "text": case "tinytext": case "mediumtext": case "longtext": case "ntext":
					local.rv = "cf_sql_varchar";
					break;
			}
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$query" returntype="struct" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfargument name="limit" type="numeric" required="false" default="0">
		<cfargument name="offset" type="numeric" required="false" default="0">
		<cfargument name="parameterize" type="boolean" required="true">
		<cfargument name="$primaryKey" type="string" required="false" default="">
		<cfscript>
			arguments = $convertMaxRowsToLimit(arguments);
			arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
			arguments.sql = $addColumnsToSelectAndGroupBy(arguments.sql);
			local.rv = $performQuery(argumentCollection=arguments);
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$identitySelect" returntype="any" access="public" output="false">
		<cfargument name="queryAttributes" type="struct" required="true">
		<cfargument name="result" type="struct" required="true">
		<cfargument name="primaryKey" type="string" required="true">
		<cfset var query = StructNew()>
		<cfset local.sql = Trim(arguments.result.sql)>
		<cfif Left(local.sql, 11) IS "INSERT INTO" AND NOT StructKeyExists(arguments.result, $generatedKey())>
			<cfset local.startPar = Find("(", local.sql) + 1>
			<cfset local.endPar = Find(")", local.sql)>
			<cfset local.columnList = ReplaceList(Mid(local.sql, local.startPar, (local.endPar-local.startPar)), "#Chr(10)#,#Chr(13)#, ", ",,")>
			<cfif NOT ListFindNoCase(local.columnList, ListFirst(arguments.primaryKey))>
				<cfset local.rv = StructNew()>
				<cfquery attributeCollection="#arguments.queryAttributes#">SELECT LAST_INSERT_ID() AS lastId</cfquery>
				<cfset local.rv[$generatedKey()] = query.name.lastId>
				<cfreturn local.rv>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="$getColumns" returntype="query" access="public" output="false">
		<cfscript>
			// get column details using cfdbinfo in the base adapter
			local.columns = super.$getColumns(argumentCollection=arguments);

			// since cfdbinfo incorrectly returns information_schema tables we need to create a new query result that excludes these tables
			local.rv = QueryNew(local.columns.columnList);
			local.iEnd = local.columns.recordCount;
			for (local.i=1; local.i <= local.iEnd; local.i++) {
				// yes, it should actually be "table_schem" below, not a typo
				if (local.columns["table_schem"][local.i] != "information_schema") {
					QueryAddRow(local.rv);
					local.jEnd = ListLen(local.columns.columnList);
					for (local.j=1; local.j <= local.jEnd; local.j++) {
						local.item = ListGetAt(local.columns.columnList, local.j);
						QuerySetCell(local.rv, local.item, local.columns[local.item][local.i]);
					}
				}
			}
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cfinclude template="../../plugins/injection.cfm">
</cfcomponent>
<cfcomponent extends="Base" output="false">

	<cffunction name="$generatedKey" returntype="string" access="public" output="false">
		<cfscript>
			local.rv = "rowid";
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$randomOrder" returntype="string" access="public" output="false">
		<cfscript>
			local.rv = "dbms_random.value()";
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$defaultValues" returntype="string" access="public" output="false">
		<cfargument name="$primaryKey" type="string" required="true" hint="the table primaryKey">
		<cfscript>
			local.rv = "(#arguments.$primaryKey#) VALUES(DEFAULT)";
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$tableAlias" returntype="string" access="public" output="false">
		<cfargument name="table" type="string" required="true">
		<cfargument name="alias" type="string" required="true">
		<cfscript>
			local.rv = arguments.table & " " & arguments.alias;
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$getType" returntype="string" access="public" output="false">
		<cfargument name="type" type="string" required="true">
		<cfargument name="scale" type="string" required="true">
		<cfscript>
			switch (arguments.type) {
				case "blob": case "bfile":
					local.rv = "cf_sql_blob";
					break;
				case "char": case "nchar":
					local.rv = "cf_sql_char";
					break;
				case "clob": case "nclob":
					local.rv = "cf_sql_clob";
					break;
				case "date": case "timestamp":
					local.rv = "cf_sql_timestamp";
					break;
				case "binary_double":
					local.rv = "cf_sql_double";
					break;
				case "number": case "float": case "binary_float":
					// integer datatypes are represented by number(38,0)
					if (Val(arguments.scale) == 0) {
						local.rv = "cf_sql_integer";
					} else {
						local.rv = "cf_sql_float";
					}
					break;
				case "long":
					local.rv = "cf_sql_longvarchar";
					break;
				case "raw":
					local.rv = "cf_sql_varbinary";
					break;
				case "varchar2": case "nvarchar2":
					local.rv = "cf_sql_varchar";
					break;
			}
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$query" returntype="struct" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfargument name="limit" type="numeric" required="false" default=0>
		<cfargument name="offset" type="numeric" required="false" default=0>
		<cfargument name="parameterize" type="boolean" required="true">
		<cfargument name="$primaryKey" type="string" required="false" default="">
		<cfscript>
			arguments = $convertMaxRowsToLimit(arguments);
			arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
			arguments.sql = $addColumnsToSelectAndGroupBy(arguments.sql);
			if (arguments.limit > 0) {
				local.select = ReplaceNoCase(ReplaceNoCase(arguments.sql[1], "SELECT DISTINCT ", ""), "SELECT ", "");
				local.select = $columnAlias(list=$tableName(list=local.select, action="remove"), action="keep");
				local.beforeWhere = "SELECT #local.select# FROM (SELECT * FROM (SELECT tmp.*, rownum rnum FROM (";
				local.afterWhere = ") tmp WHERE rownum <=" & arguments.limit+arguments.offset & ")" & " WHERE rnum >" & arguments.offset & ")";
				ArrayPrepend(arguments.sql, local.beforeWhere);
				ArrayAppend(arguments.sql, local.afterWhere);
			}

			// oracle doesn't support limit and offset in sql
			StructDelete(arguments, "limit");
			StructDelete(arguments, "offset");
			local.rv = $performQuery(argumentCollection=arguments);
			local.rv = $handleTimestampObject(local.rv);
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$identitySelect" returntype="any" access="public" output="false">
		<cfargument name="queryAttributes" type="struct" required="true">
		<cfargument name="result" type="struct" required="true">
		<cfargument name="primaryKey" type="string" required="true">
		<cfset var query = StructNew()>
		<cfset local.sql = Trim(arguments.result.sql)>
		<cfif Left(local.sql, 11) IS "INSERT INTO">
			<cfset local.startPar = Find("(", local.sql) + 1>
			<cfset local.endPar = Find(")", local.sql)>
			<cfset local.columnList = ReplaceList(Mid(local.sql, local.startPar, (local.endPar-local.startPar)), "#Chr(10)#,#Chr(13)#, ", ",,")>
			<cfif NOT ListFindNoCase(local.columnList, ListFirst(arguments.primaryKey))>
				<cfset local.rv = StructNew()>
				<cfset local.tbl = SpanExcluding(Right(local.sql, Len(local.sql)-12), " ")>
				<cfif NOT StructKeyExists(arguments.result, $generatedKey()) || application.wheels.serverName IS NOT "Adobe ColdFusion">
					<!---
					there isn't a way in oracle to tell what (if any) sequences exists
					on a table. hence we'll just have to perform a guess for now.
					TODO: in 1.2 we need to look at letting the developer specify the sequence
					name through a setting in the model
					--->
					<cftry>
						<cfquery attributeCollection="#arguments.queryAttributes#">SELECT #local.tbl#_seq.currval AS lastId FROM dual</cfquery>
						<cfcatch type="any">
							<!--- in case the sequence doesn't exists return a blank string for the expected value --->
							<cfset query.name.lastId = "">
						</cfcatch>
					</cftry>
				<cfelse>
					<cfquery attributeCollection="#arguments.queryAttributes#">SELECT #arguments.primaryKey# AS lastId FROM #local.tbl# WHERE ROWID = '#arguments.result[$generatedKey()]#'</cfquery>
				</cfif>
				<cfset local.lastId = Trim(query.name.lastId)>
				<cfif len(query.name.lastId)>
					<cfset local.rv[$generatedKey()] = Trim(local.lastid)>
					<cfreturn local.rv>
				</cfif>
			<cfelse>
				<!--- since Oracle always returns rowid we need to delete it in those cases where we have manually inserted the primary key, if we don't do this we'll end up setting the rowid value to the object --->
				<cfif StructKeyExists(arguments.result, "rowid")>
					<cfset StructDelete(arguments.result, "rowid")>
				</cfif>
				<cfif StructKeyExists(arguments.result, "generatedkey")>
					<cfset StructDelete(arguments.result, "generatedkey")>
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="$getColumnInfo" returntype="query" access="public" output="false">
		<cfargument name="table" type="string" required="true">
		<cfargument name="datasource" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfscript>
		local.args = Duplicate(arguments);
		StructDelete(local.args, "table");
		if (!Len(local.args.username)) {
			StructDelete(local.args, "username");
		}
		if (!Len(local.args.password)) {
			StructDelete(local.args, "password");
		}
		local.args.name = "local.rv";
		</cfscript>
		<cfquery attributeCollection="#local.args#">
		SELECT
			TC.COLUMN_NAME
			,TC.DATA_TYPE AS TYPE_NAME
			,TC.NULLABLE AS IS_NULLABLE
			,CASE WHEN PKC.COLUMN_NAME IS NULL THEN 0 ELSE 1 END AS IS_PRIMARYKEY
			,0 AS IS_FOREIGNKEY
			,'' AS REFERENCED_PRIMARYKEY
			,'' AS REFERENCED_PRIMARYKEY_TABLE
			,NVL(TC.DATA_PRECISION, TC.DATA_LENGTH) AS COLUMN_SIZE
			,TC.DATA_SCALE AS DECIMAL_DIGITS
			,TC.DATA_DEFAULT AS COLUMN_DEFAULT_VALUE
			,TC.DATA_LENGTH AS CHAR_OCTET_LENGTH
			,TC.COLUMN_ID AS ORDINAL_POSITION
			,'' AS REMARKS
		FROM
			ALL_TAB_COLUMNS TC
			LEFT JOIN ALL_CONSTRAINTS PK
				ON (PK.CONSTRAINT_TYPE = 'P'
				AND PK.TABLE_NAME = TC.TABLE_NAME
				AND TC.OWNER = PK.OWNER)
			LEFT JOIN ALL_CONS_COLUMNS PKC
				ON (PK.CONSTRAINT_NAME = PKC.CONSTRAINT_NAME
				AND TC.COLUMN_NAME = PKC.COLUMN_NAME
				AND TC.OWNER = PKC.OWNER)
		WHERE
			TC.TABLE_NAME = '#UCase(arguments.table)#'
		ORDER BY
			TC.COLUMN_ID
		</cfquery>
		<!---
		wheels catches the error and raises a Wheels.TableNotFound error
		to mimic this we will throw an error if the query result is empty
		 --->
		<cfif NOT local.rv.recordCount>
			<cfthrow>
		</cfif>
		<cfreturn local.rv>
	</cffunction>

	<cffunction name="$handleTimestampObject" hint="Oracle will return timestamp as an object. you need to call timestampValue() to get the string representation">
		<cfargument name="results" type="struct" required="true">
		<cfscript>
			// depending on the driver and engine used with oracle, timestamps can be returned as
			// objects instead of strings.
			if (StructKeyExists(arguments.results, "query")) {
				// look for all timestamp columns
				local.query = arguments.results.query;
				if (local.query.recordCount > 0) {
					local.metadata = GetMetaData(local.query);
					local.columns = [];
					local.iEnd = ArrayLen(local.metadata);
					for (local.i=1; local.i <= local.iEnd; local.i++) {
						local.column = local.metadata[local.i];
						if (local.column.typename == "timestamp") {
							ArrayAppend(local.columns, local.column.name);
						}
					}

					// if we have any timestamp columns
					if (!ArrayIsEmpty(local.columns)) {
						local.iEnd = ArrayLen(local.columns);
						for (local.i=1; local.i <= local.iEnd; local.i++) {
							local.column = local.columns[local.i];
							local.jEnd = local.query.recordCount;
							for (local.j=1; local.j <= local.jEnd; local.j++) {
								if (IsObject(local.query[local.column][local.j])) {
									// call timestampValue() on objects to convert to string
									local.query[local.column][local.j] = local.query[local.column][local.j].timestampValue();
								} else if (IsSimpleValue(local.query[local.column][local.j]) && Len(local.query[local.column][local.j])) {
									// if the driver does the conversion automatically, there is no need to continue
									break;
								}
							}
						}
					}
					arguments.results.query = local.query;
				}
			}
			local.rv = arguments.results;
		</cfscript>
		<cfreturn local.rv>
	</cffunction>

	<cfinclude template="../../plugins/injection.cfm">
</cfcomponent>
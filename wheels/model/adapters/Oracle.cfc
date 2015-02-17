<cfcomponent extends="Base" output="false">

	<cffunction name="$generatedKey" returntype="string" access="public" output="false">
		<cfscript>
			var loc = {};
			loc.rv = "rowid";
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$randomOrder" returntype="string" access="public" output="false">
		<cfscript>
			var loc = {};
			loc.rv = "dbms_random.value()";
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$defaultValues" returntype="string" access="public" output="false">
		<cfargument name="$primaryKey" type="string" required="true" hint="the table primaryKey">
		<cfscript>
			var loc = {};
			loc.rv = "(#arguments.$primaryKey#) VALUES(DEFAULT)";
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$tableAlias" returntype="string" access="public" output="false">
		<cfargument name="table" type="string" required="true">
		<cfargument name="alias" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.rv = arguments.table & " " & arguments.alias;
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$getType" returntype="string" access="public" output="false">
		<cfargument name="type" type="string" required="true">
		<cfargument name="scale" type="string" required="true">
		<cfscript>
			var loc = {};
			switch (arguments.type)
			{
				case "blob": case "bfile":
					loc.rv = "cf_sql_blob";
					break;
				case "char": case "nchar":
					loc.rv = "cf_sql_char";
					break;
				case "clob": case "nclob":
					loc.rv = "cf_sql_clob";
					break;
				case "date": case "timestamp":
					loc.rv = "cf_sql_timestamp";
					break;
				case "binary_double":
					loc.rv = "cf_sql_double";
					break;
				case "number": case "float": case "binary_float":
					// integer datatypes are represented by number(38,0)
					if (Val(arguments.scale) == 0)
					{
						loc.rv = "cf_sql_integer";
					}
					else
					{
						loc.rv = "cf_sql_float";
					}
					break;
				case "long":
					loc.rv = "cf_sql_longvarchar";
					break;
				case "raw":
					loc.rv = "cf_sql_varbinary";
					break;
				case "varchar2": case "nvarchar2":
					loc.rv = "cf_sql_varchar";
					break;
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$query" returntype="struct" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfargument name="limit" type="numeric" required="false" default=0>
		<cfargument name="offset" type="numeric" required="false" default=0>
		<cfargument name="parameterize" type="boolean" required="true">
		<cfargument name="$primaryKey" type="string" required="false" default="">
		<cfscript>
			var loc = {};
			arguments = $convertMaxRowsToLimit(arguments);
			arguments.sql = $removeColumnAliasesInOrderClause(arguments.sql);
			arguments.sql = $addColumnsToSelectAndGroupBy(arguments.sql);
			if (arguments.limit > 0)
			{
				loc.select = ReplaceNoCase(ReplaceNoCase(arguments.sql[1], "SELECT DISTINCT ", ""), "SELECT ", "");
				loc.select = $columnAlias(list=$tableName(list=loc.select, action="remove"), action="keep");
				loc.beforeWhere = "SELECT #loc.select# FROM (SELECT * FROM (SELECT tmp.*, rownum rnum FROM (";
				loc.afterWhere = ") tmp WHERE rownum <=" & arguments.limit+arguments.offset & ")" & " WHERE rnum >" & arguments.offset & ")";
				ArrayPrepend(arguments.sql, loc.beforeWhere);
				ArrayAppend(arguments.sql, loc.afterWhere);
			}

			// oracle doesn't support limit and offset in sql
			StructDelete(arguments, "limit");
			StructDelete(arguments, "offset");
			loc.rv = $performQuery(argumentCollection=arguments);
			loc.rv = $handleTimestampObject(loc.rv);
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$identitySelect" returntype="any" access="public" output="false">
		<cfargument name="queryAttributes" type="struct" required="true">
		<cfargument name="result" type="struct" required="true">
		<cfargument name="primaryKey" type="string" required="true">
		<cfset var loc = StructNew()>
		<cfset var query = StructNew()>
		<cfset loc.sql = Trim(arguments.result.sql)>
		<cfif Left(loc.sql, 11) IS "INSERT INTO">
			<cfset loc.startPar = Find("(", loc.sql) + 1>
			<cfset loc.endPar = Find(")", loc.sql)>
			<cfset loc.columnList = ReplaceList(Mid(loc.sql, loc.startPar, (loc.endPar-loc.startPar)), "#Chr(10)#,#Chr(13)#, ", ",,")>
			<cfif NOT ListFindNoCase(loc.columnList, ListFirst(arguments.primaryKey))>
				<cfset loc.rv = StructNew()>
				<cfset loc.tbl = SpanExcluding(Right(loc.sql, Len(loc.sql)-12), " ")>
				<cfif NOT StructKeyExists(arguments.result, $generatedKey()) || application.wheels.serverName IS NOT "Adobe ColdFusion">
					<!---
					there isn't a way in oracle to tell what (if any) sequences exists
					on a table. hence we'll just have to perform a guess for now.
					TODO: in 1.2 we need to look at letting the developer specify the sequence
					name through a setting in the model
					--->
					<cftry>
						<cfquery attributeCollection="#arguments.queryAttributes#">SELECT #loc.tbl#_seq.currval AS lastId FROM dual</cfquery>
						<cfcatch type="any">
							<!--- in case the sequence doesn't exists return a blank string for the expected value --->
							<cfset query.name.lastId = "">
						</cfcatch>
					</cftry>
				<cfelse>
					<cfquery attributeCollection="#arguments.queryAttributes#">SELECT #arguments.primaryKey# AS lastId FROM #loc.tbl# WHERE ROWID = '#arguments.result[$generatedKey()]#'</cfquery>
				</cfif>
				<cfset loc.lastId = Trim(query.name.lastId)>
				<cfif len(query.name.lastId)>
					<cfset loc.rv[$generatedKey()] = Trim(loc.lastid)>
					<cfreturn loc.rv>
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
		var loc = {};
		loc.args = Duplicate(arguments);
		StructDelete(loc.args, "table");
		if (!Len(loc.args.username))
		{
			StructDelete(loc.args, "username");
		}
		if (!Len(loc.args.password))
		{
			StructDelete(loc.args, "password");
		}
		loc.args.name = "loc.rv";
		</cfscript>
		<cfquery attributeCollection="#loc.args#">
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
		<cfif NOT loc.rv.recordCount>
			<cfthrow>
		</cfif>
		<cfreturn loc.rv>
	</cffunction>

	<cffunction name="$handleTimestampObject" hint="Oracle will return timestamp as an object. you need to call timestampValue() to get the string representation">
		<cfargument name="results" type="struct" required="true">
		<cfscript>
			var loc = {};

			// depending on the driver and engine used with oracle, timestamps can be returned as
			// objects instead of strings.
			if (StructKeyExists(arguments.results, "query"))
			{
				// look for all timestamp columns
				loc.query = arguments.results.query;
				if (loc.query.recordCount > 0)
				{
					loc.metadata = GetMetaData(loc.query);
					loc.columns = [];
					loc.iEnd = ArrayLen(loc.metadata);
					for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					{
						loc.column = loc.metadata[loc.i];
						if (loc.column.typename == "timestamp")
						{
							ArrayAppend(loc.columns, loc.column.name);
						}
					}

					// if we have any timestamp columns
					if (!ArrayIsEmpty(loc.columns))
					{
						loc.iEnd = ArrayLen(loc.columns);
						for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
						{
							loc.column = loc.columns[loc.i];
							loc.jEnd = loc.query.recordCount;
							for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
							{
								if (IsObject(loc.query[loc.column][loc.j]))
								{
									// call timestampValue() on objects to convert to string
									loc.query[loc.column][loc.j] = loc.query[loc.column][loc.j].timestampValue();
								}
								else if (IsSimpleValue(loc.query[loc.column][loc.j]) && Len(loc.query[loc.column][loc.j]))
								{
									// if the driver does the conversion automatically, there is no need to continue
									break;
								}
							}
						}
					}
					arguments.results.query = loc.query;
				}
			}
			loc.rv = arguments.results;
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

	<cfinclude template="../../plugins/injection.cfm">
</cfcomponent>
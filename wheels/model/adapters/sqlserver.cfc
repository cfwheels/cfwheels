<cfcomponent>

	<cffunction name="selectLastID" returntype="any" access="public" output="false">
		<cfset var local = structNew()>
		<cfset local.sql = "@@IDENTITY">
		<cfreturn local.sql>
	</cffunction>


	<cffunction name="getCFSQLType" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfset var local = structNew()>

		<cfswitch expression="#arguments.name#">

			<cfcase value="binary,timestamp">
				<cfset local.result = "cf_sql_binary">
			</cfcase>

			<cfcase value="bigint">
				<cfset local.result = "cf_sql_bigint">
			</cfcase>

			<cfcase value="bit">
				<cfset local.result = "cf_sql_bit">
			</cfcase>

			<cfcase value="char,nchar,uniqueidentifier">
				<cfset local.result = "cf_sql_char">
			</cfcase>

			<cfcase value="decimal,money,smallmoney">
				<cfset local.result = "cf_sql_decimal">
			</cfcase>

			<cfcase value="float">
				<cfset local.result = "cf_sql_float">
			</cfcase>

			<cfcase value="int">
				<cfset local.result = "cf_sql_integer">
			</cfcase>

			<cfcase value="image">
				<cfset local.result = "cf_sql_longvarbinary">
			</cfcase>

			<cfcase value="text,ntext">
				<cfset local.result = "cf_sql_longvarchar">
			</cfcase>

			<cfcase value="numeric">
				<cfset local.result = "cf_sql_numeric">
			</cfcase>

			<cfcase value="real">
				<cfset local.result = "cf_sql_real">
			</cfcase>

			<cfcase value="smallint">
				<cfset local.result = "cf_sql_smallint">
			</cfcase>

			<cfcase value="datetime,smalldatetime">
				<cfset local.result = "cf_sql_timestamp">
			</cfcase>

			<cfcase value="tinyint">
				<cfset local.result = "cf_sql_tinyint">
			</cfcase>

			<cfcase value="varbinary">
				<cfset local.result = "cf_sql_varbinary">
			</cfcase>

			<cfcase value="varchar,nvarchar">
				<cfset local.result = "cf_sql_varchar">
			</cfcase>

			<!--- unknown: sysname, sql_variant --->

		</cfswitch>

		<cfreturn local.result>
	</cffunction>

</cfcomponent>
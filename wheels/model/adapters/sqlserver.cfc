<cfcomponent>

	<cffunction name="selectLastID" returntype="any" access="public" output="false">
		<cfset var locals = structNew()>
		<cfset locals.sql = "@@IDENTITY">
		<cfreturn locals.sql>
	</cffunction>


	<cffunction name="getCFSQLType" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfset var locals = structNew()>

		<cfswitch expression="#arguments.name#">

			<cfcase value="binary,timestamp">
				<cfset locals.result = "cf_sql_binary">
			</cfcase>

			<cfcase value="bigint">
				<cfset locals.result = "cf_sql_bigint">
			</cfcase>

			<cfcase value="bit">
				<cfset locals.result = "cf_sql_bit">
			</cfcase>

			<cfcase value="char,nchar,uniqueidentifier">
				<cfset locals.result = "cf_sql_char">
			</cfcase>

			<cfcase value="decimal,money,smallmoney">
				<cfset locals.result = "cf_sql_decimal">
			</cfcase>

			<cfcase value="float">
				<cfset locals.result = "cf_sql_float">
			</cfcase>

			<cfcase value="int,integer">
				<cfset locals.result = "cf_sql_integer">
			</cfcase>

			<cfcase value="image">
				<cfset locals.result = "cf_sql_longvarbinary">
			</cfcase>

			<cfcase value="text,ntext">
				<cfset locals.result = "cf_sql_longvarchar">
			</cfcase>

			<cfcase value="numeric">
				<cfset locals.result = "cf_sql_numeric">
			</cfcase>

			<cfcase value="real">
				<cfset locals.result = "cf_sql_real">
			</cfcase>

			<cfcase value="smallint">
				<cfset locals.result = "cf_sql_smallint">
			</cfcase>

			<cfcase value="datetime,smalldatetime">
				<cfset locals.result = "cf_sql_timestamp">
			</cfcase>

			<cfcase value="tinyint">
				<cfset locals.result = "cf_sql_tinyint">
			</cfcase>

			<cfcase value="varbinary">
				<cfset locals.result = "cf_sql_varbinary">
			</cfcase>

			<cfcase value="varchar,nvarchar">
				<cfset locals.result = "cf_sql_varchar">
			</cfcase>

			<!--- unknown: sysname, sql_variant --->

		</cfswitch>

		<cfreturn locals.result>
	</cffunction>

</cfcomponent>
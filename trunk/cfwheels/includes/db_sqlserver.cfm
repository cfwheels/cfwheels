<cfswitch expression="#arguments.db_sql_type#">

	<cfcase value="binary,timestamp">
		<cfset result = "cf_sql_binary">
	</cfcase>

	<cfcase value="bigint">
		<cfset result = "cf_sql_bigint">
	</cfcase>

	<cfcase value="bit">
		<cfset result = "cf_sql_bit">
	</cfcase>

	<cfcase value="char,nchar,uniqueidentifier">
		<cfset result = "cf_sql_char">
	</cfcase>

	<cfcase value="decimal,money,smallmoney">
		<cfset result = "cf_sql_decimal">
	</cfcase>

	<cfcase value="float">
		<cfset result = "cf_sql_float">
	</cfcase>

	<cfcase value="int">
		<cfset result = "cf_sql_integer">
	</cfcase>

	<cfcase value="image">
		<cfset result = "cf_sql_longvarbinary">
	</cfcase>

	<cfcase value="text,ntext">
		<cfset result = "cf_sql_longvarchar">
	</cfcase>

	<cfcase value="numeric">
		<cfset result = "cf_sql_numeric">
	</cfcase>

	<cfcase value="real">
		<cfset result = "cf_sql_real">
	</cfcase>

	<cfcase value="smallint">
		<cfset result = "cf_sql_smallint">
	</cfcase>

	<cfcase value="datetime,smalldatetime">
		<cfset result = "cf_sql_timestamp">
	</cfcase>

	<cfcase value="tinyint"> 
		<cfset result = "cf_sql_tinyint">
	</cfcase>

	<cfcase value="varbinary"> 
		<cfset result = "cf_sql_varbinary">
	</cfcase>

	<cfcase value="varchar,nvarchar"> 
		<cfset result = "cf_sql_varchar">
	</cfcase>
	
	<!--- unknown: sysname, sql_variant --->

</cfswitch>

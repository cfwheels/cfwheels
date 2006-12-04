<cfswitch expression="#arguments.db_sql_type#">

	<cfcase value="bigint">
		<cfset result = "cf_sql_bigint">
	</cfcase>

	<cfcase value="binary">
		<cfset result = "cf_sql_binary">
	</cfcase>

	<cfcase value="bit,bool,boolean">
		<cfset result = "cf_sql_bit">
	</cfcase>

	<cfcase value="tinyblob,blob,mediumblob,longblob">
		<cfset result = "cf_sql_blob">
	</cfcase>

	<cfcase value="char">
		<cfset result = "cf_sql_char">
	</cfcase>

	<cfcase value="date">
		<cfset result = "cf_sql_date">
	</cfcase>

	<cfcase value="double,decimal">
		<cfset result = "cf_sql_double">
	</cfcase>

	<cfcase value="float,real">
		<cfset result = "cf_sql_float">
	</cfcase>

	<cfcase value="mediumint,int">
		<cfset result = "cf_sql_integer">
	</cfcase>

	<cfcase value="tinytext,text,mediumtext,longtext">
		<cfset result = "cf_sql_longvarchar">
	</cfcase>

	<cfcase value="numeric">
		<cfset result = "cf_sql_numeric">
	</cfcase>

	<cfcase value="smallint,year">
		<cfset result = "cf_sql_smallint">
	</cfcase>

	<cfcase value="time">
		<cfset result = "cf_sql_time">
	</cfcase>

	<cfcase value="datetime,timestamp">
		<cfset result = "cf_sql_timestamp">
	</cfcase>

	<cfcase value="tinyint">
		<cfset result = "cf_sql_tinyint">
	</cfcase>

	<cfcase value="varbinary">
		<cfset result = "cf_sql_varbinary">
	</cfcase>

	<cfcase value="varchar">
		<cfset result = "cf_sql_varchar">
	</cfcase>

	<!--- unknown: enum, set --->
	
</cfswitch>

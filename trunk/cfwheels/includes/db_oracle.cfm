<cfswitch expression="#arguments.db_sql_type#">

	<cfcase value="blob,bfile">
		<cfset result = "cf_sql_blob">
	</cfcase>

	<cfcase value="char,nchar">
		<cfset result = "cf_sql_char">
	</cfcase>

	<cfcase value="clob,nclob">
		<cfset result = "cf_sql_clob">
	</cfcase>

	<cfcase value="number">
		<cfset result = "cf_sql_decimal">
	</cfcase>

	<cfcase value="long raw">
		<cfset result = "cf_sql_longvarbinary">
	</cfcase>

	<cfcase value="date">
		<cfset result = "cf_sql_timestamp">
	</cfcase>

	<cfcase value="raw">
		<cfset result = "cf_sql_varbinary">
	</cfcase>

	<cfcase value="varchar2,nvarchar2">
		<cfset result = "cf_sql_varchar">
	</cfcase>

	<!--- unknown: pls_integer, binary_integer, timestamp, interval year, interval day, rowid, urowid, mlslabel, xmltype --->
	
</cfswitch>
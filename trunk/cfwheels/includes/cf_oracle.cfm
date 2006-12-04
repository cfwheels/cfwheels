<cfswitch expression="#arguments.db_sql_type#">

	<cfcase value="blob,bfile,clob,nclob,long raw,raw">
		<cfset result = "binary">
	</cfcase>			

	<cfcase value="date">
		<cfset result = "date">
	</cfcase>

	<cfcase value="number">
		<cfset result = "numeric">
	</cfcase>
	
	<cfcase value="char,nchar,varchar2,nvarchar2">
		<cfset result = "string">
	</cfcase>
	
</cfswitch>

<cfswitch expression="#arguments.db_sql_type#">

	<cfcase value="binary,timestamp,image,varbinary">
		<cfset result = "binary">
	</cfcase>			

	<cfcase value="bit">
		<cfset result = "boolean">
	</cfcase>

	<cfcase value="datetime,smalldatetime">
		<cfset result = "date">
	</cfcase>

	<cfcase value="bigint,decimal,money,smallmoney,float,int,numeric,real,smallint,tinyint">
		<cfset result = "numeric">
	</cfcase>
	
	<cfcase value="char,nchar,uniqueidentifier,text,ntext,varchar,nvarchar">
		<cfset result = "string">
	</cfcase>
	
</cfswitch>

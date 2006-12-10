<cfswitch expression="#arguments.db_sql_type#">

	<cfcase value="binary,varbinary,tinyblob,blob,mediumblob,longblob">
		<cfset result = "binary">
	</cfcase>			

	<cfcase value="bit,bool,boolean">
		<cfset result = "boolean">
	</cfcase>

	<cfcase value="date,time,datetime,timestamp">
		<cfset result = "date">
	</cfcase>

	<cfcase value="double,decimal,float,real,mediumint,int,numeric,smallint,year,tinyint">
		<cfset result = "numeric">
	</cfcase>
	
	<cfcase value="char,tinytext,text,mediumtext,longtext,varchar">
		<cfset result = "string">
	</cfcase>
	
</cfswitch>

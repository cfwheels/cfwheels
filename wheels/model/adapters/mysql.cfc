<cfcomponent>

	<cffunction name="selectLastID" returntype="any" access="public" output="false">
		<cfset var locals = structNew()>
		<cfset locals.sql = "LAST_INSERT_ID()">
		<cfreturn locals.sql>
	</cffunction>


	<cffunction name="getCFSQLType" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfset var locals = structNew()>

		<cfswitch expression="#arguments.name#">

			<cfcase value="bigint">
				<cfset locals.result = "cf_sql_bigint">
			</cfcase>

			<cfcase value="binary">
				<cfset locals.result = "cf_sql_binary">
			</cfcase>

			<cfcase value="bit,bool,boolean">
				<cfset locals.result = "cf_sql_bit">
			</cfcase>

			<cfcase value="tinyblob,blob,mediumblob,longblob">
				<cfset locals.result = "cf_sql_blob">
			</cfcase>

			<cfcase value="char">
				<cfset locals.result = "cf_sql_char">
			</cfcase>

			<cfcase value="date">
				<cfset locals.result = "cf_sql_date">
			</cfcase>

			<cfcase value="double,decimal">
				<cfset locals.result = "cf_sql_double">
			</cfcase>

			<cfcase value="float,real">
				<cfset locals.result = "cf_sql_float">
			</cfcase>

			<cfcase value="mediumint,int,integer">
				<cfset locals.result = "cf_sql_integer">
			</cfcase>

			<cfcase value="tinytext,text,mediumtext,longtext">
				<cfset locals.result = "cf_sql_longvarchar">
			</cfcase>

			<cfcase value="numeric">
				<cfset locals.result = "cf_sql_numeric">
			</cfcase>

			<cfcase value="smallint,year">
				<cfset locals.result = "cf_sql_smallint">
			</cfcase>

			<cfcase value="time">
				<cfset locals.result = "cf_sql_time">
			</cfcase>

			<cfcase value="datetime,timestamp">
				<cfset locals.result = "cf_sql_timestamp">
			</cfcase>

			<cfcase value="tinyint">
				<cfset locals.result = "cf_sql_tinyint">
			</cfcase>

			<cfcase value="varbinary">
				<cfset locals.result = "cf_sql_varbinary">
			</cfcase>

			<cfcase value="varchar">
				<cfset locals.result = "cf_sql_varchar">
			</cfcase>

			<!--- unknown: enum, set --->

		</cfswitch>

		<cfreturn locals.result>
	</cffunction>

</cfcomponent>
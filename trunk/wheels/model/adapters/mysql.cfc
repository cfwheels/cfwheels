<cfcomponent>

	<cffunction name="selectLastID" returntype="any" access="public" output="false">
		<cfset var local = structNew()>
		<cfset local.sql = "LAST_INSERT_ID()">
		<cfreturn local.sql>
	</cffunction>


	<cffunction name="getCFSQLType" returntype="any" access="public" output="false">
		<cfargument name="name" type="any" required="true">
		<cfset var local = structNew()>

		<cfswitch expression="#arguments.name#">

			<cfcase value="bigint">
				<cfset local.result = "cf_sql_bigint">
			</cfcase>

			<cfcase value="binary">
				<cfset local.result = "cf_sql_binary">
			</cfcase>

			<cfcase value="bit,bool,boolean">
				<cfset local.result = "cf_sql_bit">
			</cfcase>

			<cfcase value="tinyblob,blob,mediumblob,longblob">
				<cfset local.result = "cf_sql_blob">
			</cfcase>

			<cfcase value="char">
				<cfset local.result = "cf_sql_char">
			</cfcase>

			<cfcase value="date">
				<cfset local.result = "cf_sql_date">
			</cfcase>

			<cfcase value="double,decimal">
				<cfset local.result = "cf_sql_double">
			</cfcase>

			<cfcase value="float,real">
				<cfset local.result = "cf_sql_float">
			</cfcase>

			<cfcase value="mediumint,int,integer">
				<cfset local.result = "cf_sql_integer">
			</cfcase>

			<cfcase value="tinytext,text,mediumtext,longtext">
				<cfset local.result = "cf_sql_longvarchar">
			</cfcase>

			<cfcase value="numeric">
				<cfset local.result = "cf_sql_numeric">
			</cfcase>

			<cfcase value="smallint,year">
				<cfset local.result = "cf_sql_smallint">
			</cfcase>

			<cfcase value="time">
				<cfset local.result = "cf_sql_time">
			</cfcase>

			<cfcase value="datetime,timestamp">
				<cfset local.result = "cf_sql_timestamp">
			</cfcase>

			<cfcase value="tinyint">
				<cfset local.result = "cf_sql_tinyint">
			</cfcase>

			<cfcase value="varbinary">
				<cfset local.result = "cf_sql_varbinary">
			</cfcase>

			<cfcase value="varchar">
				<cfset local.result = "cf_sql_varchar">
			</cfcase>

			<!--- unknown: enum, set --->

		</cfswitch>

		<cfreturn local.result>
	</cffunction>

</cfcomponent>
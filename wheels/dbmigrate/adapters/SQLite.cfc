<cfcomponent extends="Abstract">

	<cfset variables.sqlTypes = {}>
	<cfset variables.sqlTypes['binary'] = {name='blob'}>
	<cfset variables.sqlTypes['boolean'] = {name='integer',limit=1}>
	<cfset variables.sqlTypes['date'] = {name='integer'}>
	<cfset variables.sqlTypes['datetime'] = {name='integer'}>
	<cfset variables.sqlTypes['decimal'] = {name='real'}>
	<cfset variables.sqlTypes['float'] = {name='real'}>
	<cfset variables.sqlTypes['integer'] = {name='integer'}>
	<cfset variables.sqlTypes['string'] = {name='text',limit=255}>
	<cfset variables.sqlTypes['text'] = {name='text'}>
	<cfset variables.sqlTypes['time'] = {name='integer'}>
	<cfset variables.sqlTypes['timestamp'] = {name='integer'}>

	<cffunction name="adapterName" returntype="string" access="public" hint="name of database adapter">
		<cfreturn "SQLite">
	</cffunction>

	<cffunction name="addPrimaryKeyOptions" returntype="string" access="public">
		<cfargument name="sql" type="string" required="true" hint="column definition sql">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
		if (StructKeyExists(arguments.options, "null") && arguments.options.null)
			arguments.sql = arguments.sql & " NULL";
		else
			arguments.sql = arguments.sql & " NOT NULL";

		arguments.sql = arguments.sql & " PRIMARY KEY";

		if (StructKeyExists(arguments.options, "autoIncrement") && arguments.options.autoIncrement)
			arguments.sql = arguments.sql & " AUTOINCREMENT";
		</cfscript>
		<cfreturn arguments.sql>
	</cffunction>

	<!---  SQLite uses double quotes to escape table and column names --->
	<cffunction name="quoteColumnName" returntype="string" access="public" hint="surrounds column names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn '"#arguments.name#"'>
	</cffunction>

</cfcomponent>
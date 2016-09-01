<cfcomponent extends="Abstract">

	<cfset variables.sqlTypes = {}>
	<cfset variables.sqlTypes['biginteger'] = {name='BIGINT UNSIGNED'}>
	<cfset variables.sqlTypes['binary'] = {name='BLOB'}>
	<cfset variables.sqlTypes['boolean'] = {name='TINYINT',limit=1}>
	<cfset variables.sqlTypes['date'] = {name='DATE'}>
	<cfset variables.sqlTypes['datetime'] = {name='DATETIME'}>
	<cfset variables.sqlTypes['decimal'] = {name='DECIMAL'}>
	<cfset variables.sqlTypes['float'] = {name='FLOAT'}>
	<cfset variables.sqlTypes['integer'] = {name='INT'}>
	<cfset variables.sqlTypes['string'] = {name='VARCHAR',limit=255}>
	<cfset variables.sqlTypes['text'] = {name='TEXT'}>
	<cfset variables.sqlTypes['time'] = {name='TIME'}>
	<cfset variables.sqlTypes['timestamp'] = {name='TIMESTAMP'}>
	<cfset variables.sqlTypes['uuid'] = {name='VARBINARY', limit=16}>

	<cffunction name="adapterName" returntype="string" access="public" hint="name of database adapter">
		<cfreturn "H2">
	</cffunction>

	<cffunction name="addPrimaryKeyOptions" returntype="string" access="public">
		<cfargument name="sql" type="string" required="true" hint="column definition sql">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
		if (StructKeyExists(arguments.options, "null") && arguments.options.null)
			arguments.sql = arguments.sql & " NULL";
		else
			arguments.sql = arguments.sql & " NOT NULL";

		if (StructKeyExists(arguments.options, "autoIncrement") && arguments.options.autoIncrement)
			arguments.sql = arguments.sql & " AUTO_INCREMENT";

		arguments.sql = arguments.sql & " PRIMARY KEY";
		</cfscript>
		<cfreturn arguments.sql>
	</cffunction>

	<!--- no quotes for H2 --->
	<cffunction name="quoteTableName" returntype="string" access="public" hint="surrounds table or index names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn arguments.name>
	</cffunction>

	<cffunction name="quoteColumnName" returntype="string" access="public" hint="surrounds column names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn arguments.name>
	</cffunction>

	<cffunction name="renameTable" returntype="string" access="public" hint="generates sql to rename a table">
		<cfargument name="oldName" type="string" required="true" hint="old table name">
		<cfargument name="newName" type="string" required="true" hint="new table name">
		<cfreturn "ALTER TABLE #arguments.oldName# RENAME TO #arguments.newName#">
	</cffunction>

	<cffunction name="renameColumnInTable" returntype="string" access="public" hint="generates sql to rename an existing column in a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="columnName" type="string" required="true" hint="old column name">
		<cfargument name="newColumnName" type="string" required="true" hint="new column name">
		<cfreturn "ALTER TABLE #arguments.name# ALTER COLUMN #arguments.columnName# RENAME TO #arguments.newColumnName#">
	</cffunction>

</cfcomponent>

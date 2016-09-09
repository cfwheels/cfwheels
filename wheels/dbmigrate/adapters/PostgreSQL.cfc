<cfcomponent extends="Abstract">

	<cfset variables.sqlTypes = {}>
	<cfset variables.sqlTypes['binary'] = {name='BYTEA'}>
	<cfset variables.sqlTypes['boolean'] = {name='BOOLEAN'}>
	<cfset variables.sqlTypes['date'] = {name='DATE'}>
	<cfset variables.sqlTypes['datetime'] = {name='TIMESTAMP'}>
	<cfset variables.sqlTypes['decimal'] = {name='DECIMAL'}>
	<cfset variables.sqlTypes['float'] = {name='FLOAT'}>
	<cfset variables.sqlTypes['integer'] = {name='INTEGER'}>
	<cfset variables.sqlTypes['string'] = {name='VARCHAR', limit=255}>
	<cfset variables.sqlTypes['text'] = {name='TEXT'}>
	<cfset variables.sqlTypes['time'] = {name='TIME'}>
	<cfset variables.sqlTypes['timestamp'] = {name='TIMESTAMP'}>

	<cffunction name="adapterName" returntype="string" access="public" hint="name of database adapter">
		<cfreturn "PostgreSQL">
	</cffunction>

	<cffunction name="addPrimaryKeyOptions" returntype="string" access="public">
		<cfargument name="sql" type="string" required="true" hint="column definition sql">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
		if (StructKeyExists(arguments.options, "autoIncrement") && arguments.options.autoIncrement) {
			arguments.sql = ReplaceNoCase(arguments.sql, "INTEGER", "SERIAL", "all");
		}
		arguments.sql = arguments.sql & " PRIMARY KEY";
		</cfscript>
		<cfreturn arguments.sql>
	</cffunction>

	<!--- PostgreSQL alter column statements use extended SQL --->
	<cffunction name="addColumnOptions" returntype="string" access="public">
		<cfargument name="sql" type="string" required="true" hint="column definition sql">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfargument name="alter" type="boolean" required="false" default="false" hint="generate create or alter flavoured sql">
		<cfscript>
			if(StructKeyExists(arguments.options,'type') && arguments.options.type != 'primaryKey') {
				if(StructKeyExists(arguments.options,'default') && optionsIncludeDefault(argumentCollection=arguments.options)) {
					if (arguments.alter) {
						arguments.sql = arguments.sql & " SET";
					}
					if(arguments.options.default eq "NULL" || (arguments.options.default eq "" && ListFindNoCase("boolean,date,datetime,time,timestamp,decimal,float,integer", arguments.options.type))) {
						arguments.sql = arguments.sql & " DEFAULT NULL";
					} else if(arguments.options.type == 'boolean') {
						arguments.sql = arguments.sql & " DEFAULT #IIf(arguments.options.default,true,false)#";
					} else if(arguments.options.type == 'string' && arguments.options.default eq "") {
						arguments.sql = arguments.sql & "DEFAULT ''";
					} else {
						arguments.sql = arguments.sql & " DEFAULT #quote(value=arguments.options.default,options=arguments.options)#";
					}
				}
				if(StructKeyExists(arguments.options,'null')) {
					if (arguments.alter) {
						if (arguments.options.null) {
							arguments.sql = arguments.sql & " DROP NOT NULL";
						} else {
							arguments.sql = arguments.sql & " SET NOT NULL";
						}
					} else if (!arguments.options.null) {
						arguments.sql = arguments.sql & " NOT NULL";
					}
				}
			}
		</cfscript>
		<cfif structKeyExists(arguments.options, "afterColumn") And Len(Trim(arguments.options.afterColumn)) GT 0>
			<cfset arguments.sql = arguments.sql & " AFTER #arguments.options.afterColumn#">
		</cfif>
		<cfreturn arguments.sql>
	</cffunction>

	<!--- don't quote tables --->
	<cffunction name="quoteTableName" returntype="string" access="public" hint="surrounds table or index names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn arguments.name>
	</cffunction>

	<!--- postgres uses double quotes --->
	<cffunction name="quoteColumnName" returntype="string" access="public" hint="surrounds column names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<!--- <cfreturn '"#arguments.name#"'> --->
		<cfreturn arguments.name>
	</cffunction>

	<!--- createTable - use default --->

	<cffunction name="renameTable" returntype="string" access="public" hint="generates sql to rename a table">
		<cfargument name="oldName" type="string" required="true" hint="old table name">
		<cfargument name="newName" type="string" required="true" hint="new table name">
		<cfreturn "ALTER TABLE #quoteTableName(arguments.oldName)# RENAME TO #quoteTableName(arguments.newName)#">
	</cffunction>

	<!--- dropTable - use default --->

	<!--- addColumnToTable - ? --->

	<!--- NOTE FOR addColumnToTable & changeColumnInTable
		  Rails adaptor appears to be applying default/nulls in separate queries
		  Need to check if that is necessary --->

	<cffunction name="changeColumnInTable" returntype="string" access="public" hint="generates sql to change an existing column in a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="column" type="any" required="true" hint="column definition object">
		<cfscript>
		for (local.i in ["default","null","afterColumn"]) {
			if (StructKeyExists(arguments.column, local.i)) {
				local.opts = {};
				local.opts.type = arguments.column.type;
				local.opts[local.i] = arguments.column[local.i];
				local.columnSQL = addColumnOptions(sql=" ALTER COLUMN #arguments.column.name#", options=local.opts, alter=true);
				if (! StructKeyExists(local, "sql")) {
					local.sql = "ALTER TABLE #quoteTableName(LCase(arguments.name))# ALTER COLUMN #arguments.column.name# TYPE #arguments.column.sqlType()#";
				}
				if (Len(arguments.column[local.i])) {
					local.sql = ListAppend(local.sql, local.columnSQL, ",#Chr(13)##Chr(10)#");
				}
			}
		}
		</cfscript>
		<cfreturn local.sql>
	</cffunction>

	<!--- renameColumnInTable - use default --->

	<!--- dropColumnFromTable - use default --->

	<!--- addForeignKeyToTable - use default --->

	<cffunction name="dropForeignKeyFromTable" returntype="string" access="public" hint="generates sql to add a foreign key constraint to a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="keyName" type="any" required="true" hint="foreign key name">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# DROP CONSTRAINT #quoteTableName(arguments.keyname)#">
	</cffunction>

	<!--- foreignKeySQL - use default --->

	<!--- addIndex - use default --->

	<!--- removeIndex - use default --->

</cfcomponent>

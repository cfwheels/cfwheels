<cfcomponent>
	<cfinclude template="../basefunctions.cfm">

	<cffunction name="typeToSQL" returntype="string">
		<cfargument name="type" type="string" required="true" hint="column type">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
		var sql = '';
		if(IsDefined("variables.sqlTypes") && structKeyExists(variables.sqlTypes,arguments.type)) {
			if(IsStruct(variables.sqlTypes[arguments.type])) {
				sql = variables.sqlTypes[arguments.type]['name'];
				if(arguments.type == 'decimal') {
					if(!StructKeyExists(arguments.options,'precision') && StructKeyExists(variables.sqlTypes[arguments.type],'precision')) {
						arguments.options.precision = variables.sqlTypes[arguments.type]['precision'];
					}
					if(!StructKeyExists(arguments.options,'scale') && StructKeyExists(variables.sqlTypes[arguments.type],'scale')) {
						arguments.options.scale = variables.sqlTypes[arguments.type]['scale'];
					}
					if(StructKeyExists(arguments.options,'precision')) {
						if(StructKeyExists(arguments.options,'scale')) {
							sql = sql & '(#arguments.options.precision#,#arguments.options.scale#)';
						} else {
							sql = sql & '(#arguments.options.precision#)';
						}
					}
				} else {
					if(!StructKeyExists(arguments.options,'limit') && StructKeyExists(variables.sqlTypes[arguments.type],'limit')) {
						arguments.options.limit = variables.sqlTypes[arguments.type]['limit'];
					}
					if(StructKeyExists(arguments.options,'limit')) {
						sql = sql & '(#arguments.options.limit#)';
					}
				}
			} else {
				sql = variables.sqlTypes[arguments.type];
			}
		}
		</cfscript>
		<cfreturn sql>
	</cffunction>

	<cffunction name="addPrimaryKeyOptions" returntype="string" access="public">
		<cfthrow message="The `addPrimaryKeyOptions` must be implented in the storage specific adapter." />
	</cffunction>

    <cffunction name="primaryKeyConstraint" returntype="string" access="public">
    	<cfargument name="name" type="string" required="true">
        <cfargument name="primaryKeys" type="array" required="true">
        <cfscript>
        var loc = {};

		loc.sql = "PRIMARY KEY (";

		for (loc.i = 1; loc.i lte ArrayLen(arguments.primaryKeys); loc.i++)
		{
			if (loc.i != 1)
				loc.sql = loc.sql & ", ";
			loc.sql = loc.sql & arguments.primaryKeys[loc.i].toColumnNameSQL();
		}

		loc.sql = loc.sql & ")";
        </cfscript>
        <cfreturn loc.sql />
    </cffunction>

	<cffunction name="addColumnOptions" returntype="string" access="public">
		<cfargument name="sql" type="string" required="true" hint="column definition sql">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
			if(StructKeyExists(arguments.options,'type') && arguments.options.type != 'primaryKey') {
				if(StructKeyExists(arguments.options,'default') && optionsIncludeDefault(argumentCollection=arguments.options)) {
					if(arguments.options.default eq "NULL" || (arguments.options.default eq "" && ListFindNoCase("boolean,date,datetime,time,timestamp,decimal,float,integer",arguments.options.type))) {
						arguments.sql = arguments.sql & " DEFAULT NULL";
					} else if(arguments.options.type == 'boolean') {
						arguments.sql = arguments.sql & " DEFAULT #IIf(arguments.options.default,1,0)#";
					} else if(arguments.options.type == 'string' && arguments.options.default eq "") {
						arguments.sql = arguments.sql;
					} else {
						arguments.sql = arguments.sql & " DEFAULT #quote(value=arguments.options.default,options=arguments.options)#";
					}
				}
				if(StructKeyExists(arguments.options,'null')) {
					if (arguments.options.null) {
						arguments.sql = arguments.sql & " NULL";
					} else {
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

	<cffunction name="optionsIncludeDefault" returntype="boolean">
		<cfargument name="type" type="string" required="false" hint="column type">
		<cfargument name="default" type="string" required="false" default="" hint="default value">
		<cfargument name="null" type="boolean" required="false" default="true" hint="whether nulls are allowed">
		<cfreturn true>
	</cffunction>

	<cffunction name="quote" returntype="string" access="public" hint="quote value if required">
		<cfargument name="value" type="string" required="true" hint="value to be quoted">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
			if (listFindNoCase("CURRENT_TIMESTAMP", arguments.value))
				return arguments.value;

			if(StructKeyExists(arguments.options,'type') && ListFindNoCase("binary,date,datetime,time,timestamp",arguments.options.type)) {
				arguments.value = "'#arguments.value#'";
			}
			else if(StructKeyExists(arguments.options,'type') && ListFindNoCase("text,string",arguments.options.type)) {
				arguments.value = "'#ReplaceNoCase(arguments.value,"'","''")#'";
			}
		</cfscript>
		<cfreturn arguments.value>
	</cffunction>

	<cffunction name="quoteTableName" returntype="string" access="public" hint="surrounds table or index names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn "'#Replace(arguments.name,".","`.`","ALL")#'">
	</cffunction>

	<cffunction name="quoteColumnName" returntype="string" access="public" hint="surrounds column names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn "'#arguments.name#'">
	</cffunction>

	<cffunction name="createTable" returntype="string" access="public" hint="generates sql to create a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="columns" type="array" required="true" hint="array of column definitions">
		<cfargument name="primaryKeys" type="array" required="false" default="#ArrayNew(1)#" hint="array of primary key definitions">
		<cfargument name="foreignKeys" type="array" required="false" default="#ArrayNew(1)#" hint="array of foreign key definitions">
		<cfscript>
		var loc = {};
		loc.sql = "CREATE TABLE #quoteTableName(LCase(arguments.name))# (#chr(13)##chr(10)#";

		loc.iEnd = ArrayLen(arguments.primaryKeys);

		if (loc.iEnd == 1)
		{
			// if we have a single primary key, define the column with the primaryKey adapter method
			loc.sql = loc.sql & " " & arguments.primaryKeys[1].toPrimaryKeySQL() & ",#chr(13)##chr(10)#";
		}
		else if (loc.iEnd > 1)
		{
			// add the primary key columns like we would normal columns
			for (loc.i = 1; loc.i <= loc.iEnd; loc.i++) {
				loc.sql = loc.sql & " " & arguments.primaryKeys[loc.i].toSQL();
				if (loc.i != loc.iEnd || ArrayLen(arguments.columns))
					loc.sql = loc.sql & ",#chr(13)##chr(10)#";
			}
		}

		// define the columns in the sql
		loc.iEnd = ArrayLen(arguments.columns);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
			loc.sql = loc.sql & " " & arguments.columns[loc.i].toSQL();
			if(loc.i != loc.iEnd) { loc.sql = loc.sql & ",#chr(13)##chr(10)#"; }
		}

		// if we have multiple primarykeys the adapater might need to add a constraint here
		if (ArrayLen(arguments.primaryKeys) > 1)
			loc.sql = loc.sql & ",#chr(13)##chr(10)# " & primaryKeyConstraint(argumentCollection=arguments);

		// define the foreign keys
		loc.iEnd = ArrayLen(arguments.foreignKeys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
			loc.sql = loc.sql & ",#chr(13)##chr(10)# " & arguments.foreignKeys[loc.i].toForeignKeySQL();
		}
		loc.sql = loc.sql & "#chr(13)##chr(10)#)";
		</cfscript>
		<cfreturn loc.sql>
	</cffunction>

	<cffunction name="renameTable" returntype="string" access="public" hint="generates sql to rename a table">
		<cfargument name="oldName" type="string" required="true" hint="old table name">
		<cfargument name="newName" type="string" required="true" hint="new table name">
		<cfreturn "ALTER TABLE #quoteTableName(arguments.oldName)# RENAME #quoteTableName(arguments.newName)#">
	</cffunction>

	<cffunction name="dropTable" returntype="string" access="public" hint="generates sql to drop a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfreturn "DROP TABLE IF EXISTS #quoteTableName(LCase(arguments.name))#">
	</cffunction>

	<cffunction name="addColumnToTable" returntype="string" access="public" hint="generates sql to add a new column to a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="column" type="any" required="true" hint="column definition object">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# ADD COLUMN #arguments.column.toSQL()#" />
	</cffunction>

	<cffunction name="changeColumnInTable" returntype="string" access="public" hint="generates sql to change an existing column in a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="column" type="any" required="true" hint="column definition object">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# CHANGE #quoteColumnName(arguments.column.name)# #arguments.column.toSQL()#">
	</cffunction>

	<cffunction name="renameColumnInTable" returntype="string" access="public" hint="generates sql to rename an existing column in a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="columnName" type="string" required="true" hint="old column name">
		<cfargument name="newColumnName" type="string" required="true" hint="new column name">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# RENAME COLUMN #quoteColumnName(arguments.columnName)# TO #quoteColumnName(arguments.newColumnName)#">
	</cffunction>

	<cffunction name="dropColumnFromTable" returntype="string" access="public" hint="generates sql to add a foreign key constraint to a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="columnName" type="any" required="true" hint="column name">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# DROP COLUMN #quoteColumnName(arguments.columnName)#">
	</cffunction>

	<cffunction name="addForeignKeyToTable" returntype="string" access="public" hint="generates sql to add a foreign key constraint to a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="foreignKey" type="any" required="true" hint="foreign key definition object">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# ADD #arguments.foreignKey.toSQL()#">
	</cffunction>

	<cffunction name="dropForeignKeyFromTable" returntype="string" access="public" hint="generates sql to add a foreign key constraint to a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="keyName" type="any" required="true" hint="foreign key name">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# DROP FOREIGN KEY #quoteTableName(arguments.keyname)#">
	</cffunction>

	<cffunction name="foreignKeySQL" returntype="string" access="public" hint="generates sql for foreign key constraint">
		<cfargument name="name" type="string" required="true" hint="foreign key name">
		<cfargument name="table" type="string" required="yes" hint="table name">
		<cfargument name="referenceTable" type="string" required="yes" hint="referenced table name">
		<cfargument name="column" type="string" required="yes" hint="column name">
		<cfargument name="referenceColumn" type="string" required="yes" hint="referenced column name">
		<cfargument name="onUpdate" type="string" required="false" default="">
		<cfargument name="onDelete" type="string" required="false" default="">

		<cfscript>
			var loc = { sql = "CONSTRAINT #quoteTableName(arguments.name)# FOREIGN KEY (#quoteColumnName(arguments.column)#) REFERENCES #LCase(arguments.referenceTable)#(#quoteColumnName(arguments.referenceColumn)#)" };
			for (loc.item in listToArray("onUpdate,onDelete"))
				{
					if (len(arguments[loc.item]))
					{
						switch (arguments[loc.item])
						{
							case "none":
								loc.sql = loc.sql & " " & uCase(humanize(loc.item)) & " NO ACTION";
								break;

							case "null":
								loc.sql = loc.sql & " " & uCase(humanize(loc.item)) & " SET NULL";
								break;

							default:
								loc.sql = loc.sql & " " & uCase(humanize(loc.item)) & " CASCADE";
								break;
						}
					}
				}
		</cfscript>
		<cfreturn loc.sql>
	</cffunction>

	<cffunction name="addIndex" returntype="string" access="public" hint="generates sql to add database index on a table column">
		<cfargument name="table" type="string" required="true" hint="table name">
		<cfargument name="columnNames" type="string" required="true" hint="column names to index">
		<cfargument name="unique" type="boolean" required="false" default="false" hint="create unique index">
		<cfargument name="indexName" type="string" required="false" default="#LCase(arguments.table)#_#ListFirst(arguments.columnNames)#" hint="override the default index name">
		<cfscript>
		var sql = "CREATE ";
		if(arguments.unique) { sql = sql & "UNIQUE "; }
		sql = sql & "INDEX #quoteTableName(arguments.indexName)# ON #quoteTableName(arguments.table)#(";

		loc.iEnd = ListLen(arguments.columnNames);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++) {
			sql = sql & quoteColumnName(ListGetAt(arguments.columnNames,loc.i));
			if(loc.i != loc.iEnd) { sql = sql & ","; }
		}
		sql = sql & ")";
		</cfscript>
		<cfreturn sql>
	</cffunction>

	<cffunction name="removeIndex" returntype="string" access="public" hint="generates sql to remove a database index">
		<cfargument name="table" type="string" required="true" hint="table name">
		<cfargument name="indexName" type="string" required="false" default="" hint="index name">
		<cfreturn "DROP INDEX #quoteTableName(arguments.indexName)#">
	</cffunction>

	<cffunction name="addRecordPrefix" returntype="string" access="public" hint="generates sql to remove a database index">
		<cfreturn "">
	</cffunction>

	<cffunction name="addRecordSuffix" returntype="string" access="public" hint="generates sql to remove a database index">
		<cfreturn "">
	</cffunction>

</cfcomponent>

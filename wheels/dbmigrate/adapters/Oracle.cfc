component extends="Abstract" {

	/*
		NOTE: for oracle primary keys we add sequences [tablename_seq]
		but we leave it up to the model to implement a beforeCreate() callback
		that sets the id value based on the next value in the sequence
	*/

	variables.sqlTypes = {};
	variables.sqlTypes['binary'] = {name='BLOB'};
	variables.sqlTypes['boolean'] = {name='NUMBER',limit=1};
	variables.sqlTypes['date'] = {name='DATE'};
	variables.sqlTypes['datetime'] = {name='DATE'};
	variables.sqlTypes['decimal'] = {name='DECIMAL'};
	variables.sqlTypes['float'] = {name='NUMBER'};
	variables.sqlTypes['integer'] = {name='NUMBER',limit=38};
	variables.sqlTypes['string'] = {name='VARCHAR2',limit=255};
	variables.sqlTypes['text'] = {name='CLOB'};
	variables.sqlTypes['time'] = {name='DATE'};
	variables.sqlTypes['timestamp'] = {name='DATE'};

	/**
  * name of database adapter
  */
	public string function adapterName() {
		return "Oracle";
	}

	/**
	* generates sql for primary key options
	*/
	public string function addPrimaryKeyOptions(required string sql, struct options = {}) {
		if (StructKeyExists(arguments.options, "null") && arguments.options.null) {
			arguments.sql = arguments.sql & " NULL";
		} else {
			arguments.sql = arguments.sql & " NOT NULL";
		}
		arguments.sql = arguments.sql & " PRIMARY KEY";
		return arguments.sql;
	}

	/**
	* generates sql for primary key constraint
	*/
	public string function primaryKeyConstraint(required string name, required array primaryKeys) {
		local.sql = "CONSTRAINT PK_#objectCase(arguments.name)# PRIMARY KEY (";
		for (local.i = 1; local.i lte local.iEnd; local.i++) {
			if (local.i != 1) {
				local.sql = local.sql & ", ";
			}
			local.sql = local.sql & arguments.primaryKeys[local.i].toColumnNameSQL();
		}
		local.sql = local.sql & ")";
		return local.sql;
	}

	/**
  * leaving table names and columns unquoted
  * my understanding is that if you use quotes when creating the tables,
  * it becomes case sensitive & maybe you also need to use quotes in your queries
  */
	public string function quoteTableName(required string name) {
		return objectCase(arguments.name);
	}

	public string function quoteColumnName(required string name) {
		return objectCase(arguments.name);
	}

	/**
  * generates sql to create a table and sequence
  */
	public string function createTable(
	  required string name,
	  required array columns,
	  array foreignKeys = []
	) {
		$execute("CREATE SEQUENCE #quoteTableName(arguments.name & "_seq")# START WITH 1 INCREMENT BY 1");
		announce("Created sequence #objectCase(arguments.name)#_seq");
		return super.createTable(argumentCollection=arguments);
	}

	/**
  * generates sql to rename a table sequence
  */
	public string function renameTable(required string oldName, required string newName) {
		$execute("RENAME #quoteTableName(arguments.oldName & "_seq")# TO #quoteTableName(arguments.newName & "_seq")#");
		announce("Renamed sequence #objectCase(arguments.oldName)#_seq to #objectCase(arguments.newName)#_seq");
		return super.renameTable(argumentCollection=arguments);
	}

	/**
	* Look to see if a specific table exists in Oracle
	* Filter by pattern (tablename) as otherwise Oracle returns c. 30,000 tables...
	*/
	public boolean function tableExists(required string tableName){
		local.check= $dbinfo(
			type="tables",
			datasource=application.wheels.dataSourceName,
			username=application.wheels.dataSourceUserName,
			password=application.wheels.dataSourcePassword,
			pattern=objectCase(arguments.tableName)
		);
		if(local.check.recordcount){
			return true;
		} else {
			return false;
		}
	}

	/**
  * generates sql to drop a table ad sequence
  */
	public string function dropTable(required string name) {
		// TODO: delete sequence if exists
		try {
			$execute("DROP SEQUENCE #quoteTableName(arguments.name & "_seq")#");
		} catch(database e) {
			// catch exception if sequence doesn't exist
		}
		announce("Dropped sequence #objectCase(arguments.name)#_seq");

		if( tableExists( quoteTableName(arguments.name) ) ){
			return "DROP TABLE #quoteTableName(arguments.name)# PURGE";
		} else {
			// We can't drop an non existing table, but the way dbmigrate is written means whatever is
			// returned from this adapter is going to be executed, so here's some dummy SQL.
			return "SELECT 'I Hate Oracle' FROM dual";
		}
	}

	/**
  * generates sql to add a new column to a table
  */
	public string function addColumnToTable(required string name, required any column) {
		return "ALTER TABLE #quoteTableName(arguments.name)# ADD #arguments.column.toSQL()#";
	}

	/**
  * generates sql to change an existing column in a table
  */
	public string function changeColumnInTable(required string name, required any column) {
		return "ALTER TABLE #quoteTableName(arguments.name)# MODIFY #arguments.column.toSQL()#";
	}

	/**
  * generates sql to add a foreign key constraint to a table
  */
	public string function dropForeignKeyFromTable(required string name, required any keyName) {
		return "ALTER TABLE #quoteTableName(arguments.name)# DROP CONSTRAINT #quoteTableName(arguments.keyname)#";
	}
}

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

		local.sql = "CONSTRAINT PK_#arguments.name# PRIMARY KEY (";

		for (local.i = 1; local.i lte local.iEnd; local.i++)
		{
			if (local.i != 1)
				local.sql = local.sql & ", ";
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
		return arguments.name;
	}

	public string function quoteColumnName(required string name) {
		return arguments.name;
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
		announce("Created sequence #arguments.name#_seq");
		return Super.createTable(argumentCollection=arguments);
	}

	/**
	* generates sql to rename a table sequence
	*/
	public string function renameTable(required string oldName, required string newName) {
		$execute("drop trigger #arguments.oldName#_trg");
		announce("Dropping old trigger #arguments.oldName#_trg");
		$execute("RENAME #quoteTableName(arguments.oldName & "_seq")# TO #quoteTableName(arguments.newName & "_seq")#");
		announce("Renamed sequence #arguments.oldName#_seq to #arguments.newName#_seq");
		$execute("ALTER TABLE #quoteTableName(arguments.oldName)# RENAME TO #quoteTableName(arguments.newName)#");
		return "CREATE TRIGGER #arguments.newName#_trg BEFORE INSERT ON #arguments.newName# REFERENCING NEW AS New OLD AS Old FOR EACH ROW BEGIN :new.ID := #arguments.newName#_seq.nextval; END #arguments.newName#_trg;;";
	}

	/**
	* generates sql to drop a table ad sequence
	*/
	public string function dropTable(required string name) {
		$execute("BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE cfwheels.#quoteTableName(arguments.name & "_seq")#'; EXCEPTION	WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF; END;;");
		announce("Dropped sequence #arguments.name#_seq");
		return "BEGIN EXECUTE IMMEDIATE 'DROP TABLE #quoteTableName(LCase(arguments.name))# PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;;";
	}

	/**
	* generates sql to add a new column to a table
	*/
	public string function addColumnToTable(required string name, required any column) {
		return "ALTER TABLE #quoteTableName(LCase(arguments.name))# ADD #arguments.column.toSQL()#";
	}

	/**
	* generates sql to change an existing column in a table
	*/
	public string function changeColumnInTable(required string name, required any column) {
		return "ALTER TABLE #quoteTableName(LCase(arguments.name))# MODIFY #arguments.column.toSQL()#";
	}

	/**
	* generates sql to add a foreign key constraint to a table
	*/
	public string function dropForeignKeyFromTable(required string name, required any keyName) {
		return "ALTER TABLE #quoteTableName(LCase(arguments.name))# DROP CONSTRAINT #quoteTableName(arguments.keyname)#";
	}
}

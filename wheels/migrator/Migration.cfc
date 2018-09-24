component extends="Base" {

	public Migration function init() {
		var dbType = $getDBType();
		if(dbType == '') {
			Throw(type="wheels.model.migrate.DatabaseNotSupported", message="#dbType# is not supported by CFWheels.", extendedInfo="Use SQL Server, MySQL, MariaDB, PostgreSQL or H2.");
		} else {
			this.adapter = CreateObject("component","adapters.#dbType#");
		}
		return this;
	}

	/**
	* Migrates up
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	*/
	public void function up() {
		announce("UP MIGRATION NOT IMPLEMENTED");
	}

	/**
	* Migrates down
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	*/ 
	public void function down() {
		announce("DOWN MIGRATION NOT IMPLEMENTED");
	}

	/**
    * creates a table definition object to store table properties
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
    */
	public TableDefinition function createTable(
		required string name,
		boolean force="false",
		boolean id="true",
		string primaryKey="id"
	) {
		arguments.adapter = this.adapter;
		return CreateObject("component","TableDefinition").init(argumentCollection=arguments);
	}

	/**
    * creates a view definition object to store view properties
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
    */
	public ViewDefinition function createView(required string name) {
		arguments.adapter = this.adapter;
		return CreateObject("component","ViewDefinition").init(argumentCollection=arguments);
	}

	/**
    * creates a table definition object to store modifications to table properties
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
    */
	public TableDefinition function changeTable(required string name) {
		return CreateObject("component","TableDefinition").init(adapter=this.adapter,name=arguments.name);
	}
	/**
    * renames a table
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
    */
	public void function renameTable(required string oldName, required string newName) {
		$execute(this.adapter.renameTable(argumentCollection=arguments));
		announce("Renamed table #arguments.oldName# to #arguments.newName#");
	}

	/**
    * drops a table from the database
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
    */
	public void function dropTable(required string name) {
	  	if (application.wheels.serverName != "lucee") {
				local.foreignKeys = $getForeignKeys(arguments.name);
				local.iEnd = ListLen(local.foreignKeys);
	  		for (local.i = 1; local.i <= local.iEnd; local.i++) {
	  			local.foreignKeyName = ListGetAt(local.foreignKeys,local.i);
	  			dropForeignKey(table=arguments.name,keyname=local.foreignKeyName);
	  		}
	  	}
	    $execute(this.adapter.dropTable(name=arguments.name));
	    announce("Dropped table #arguments.name#");
	}

	/**
	* drops a view from the database
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	*/
	public void function dropView(required string name) {
	    $execute(this.adapter.dropView(name=arguments.name));
	    announce("Dropped view #arguments.name#");
	}

	/**
    * adds a column to existing table
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
    */
	public void function addColumn(
		required string table,
		required string columnType,
		string afterColumn="",
		string columnName="",
		string referenceName="",
		string default,
		boolean null,
		numeric limit,
		numeric precision,
		numeric scale
	) {
		arguments.addColumns = true;
		changeColumn(argumentCollection=arguments);
	}

	/**
    * changes a column definition
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
    */
	public void function changeColumn(
		required string table,
		required string columnName,
		required string columnType,
		string afterColumn="",
		string referenceName="",
		string default,
		boolean null,
		numeric limit,
		numeric precision,
		numeric scale,
		boolean addColumns="false"
	) {
		var t = changeTable(arguments.table);
		if(arguments.columnType == "reference") {
			arguments.columnType = "references";
			arguments.referenceNames = arguments.referenceName;
		} else {
			arguments.columnNames = arguments.columnName;
		}
		Evaluate("t.#arguments.columnType#(argumentCollection=arguments)");
		t.change(addColumns=arguments.addColumns);
	}

	/**
    * Renames a table column
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table containing the column to rename
	* @columnName The column name to rename
	* @newColumnName The new column name
    */
	public void function renameColumn(
		required string table,
		required string columnName,
		required string newColumnName
	) {
		$execute(this.adapter.renameColumnInTable(name=arguments.table,columnName=arguments.columnName,newColumnName=arguments.newColumnName));
		announce("Renamed column #arguments.columnName# to #arguments.newColumnName# in table #arguments.table#");
	}

	/**
    * Removes a column from a database table
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table containing the column to remove
	* @columnName The column name to remove
	* @referenceName optional reference name
    */
	public void function removeColumn(
		required string table,
		string columnName="",
		string referenceName=""
	) {
		if(arguments.referenceName != "") {
			arguments.columnName = arguments.referenceName & "id";
		}
		$execute(this.adapter.dropColumnFromTable(name=arguments.table,columnName=arguments.columnName));
		announce("Removed column #arguments.columnName# from #arguments.table#");
	}

	/**
    * Add a foreign key constraint to the database, using the reference name that was used to create it
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table name to perform the operation on
	* @referenceTable The reference table name to perform the operation on
	*/
	public void function addReference(required string table, required string referenceName) {
		addForeignKey(table=arguments.table, referenceTable=pluralize(arguments.referenceName), column="#arguments.referenceName#id", referenceColumn="id");
	}

	/**
    * Add a foreign key constraint to the database, using the reference name that was used to create it
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table name to perform the operation on
	* @referenceTable The reference table name to perform the operation on
	* @column The column name to perform the operation on
	* @referenceColumn The reference column name to perform the operation on
    */
	public void function addForeignKey(
		required string table,
		required string referenceTable,
		required string column,
		required string referenceColumn
	) {
		var foreignKey = CreateObject("component","ForeignKeyDefinition").init(adapter=this.adapter, argumentCollection=arguments);
		$execute(this.adapter.addForeignKeyToTable(name=arguments.table, foreignKey=foreignKey));
		announce("Added foreign key #foreignKey.name#");
	}

	/**
    * Drop a foreign key constraint from the database, using the reference name that was used to create it
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table name to perform the operation on
	* @referenceName the name of the reference to drop
	*
    */
	public void function dropReference(required string table, required string referenceName) {
		dropForeignKey(arguments.table,"FK_#arguments.table#_#pluralize(arguments.referenceName)#");
	}

	/**
    * Drops a foreign key constraint from the database
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table name to perform the operation on
	* @keyName the name of the key to drop
	*
    */
	public void function dropForeignKey(required string table, required string keyName) {
		$execute(this.adapter.dropForeignKeyFromTable(name=arguments.table,keyName=arguments.keyName));
		announce("Dropped foreign key #arguments.keyName#");
	}

	/**
    * Add database index on a table column
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table name to perform the index operation on
	* @indexName the name of the index to add
    */
	public void function addIndex(
		required string table,
		required string columnNames,
		boolean unique = "false",
		string indexName = objectCase("#arguments.table#_#ListFirst(arguments.columnNames)#")
	) {
		$execute(this.adapter.addIndex(argumentCollection=arguments));
		announce("Added index to column(s) #arguments.columnNames# in table #arguments.table#");
	}

	/**
    * Remove a database index
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table name to perform the index operation on
	* @indexName the name of the index to remove
	*/
	public void function removeIndex(required string table, required string indexName) {
		$execute(this.adapter.removeIndex(argumentCollection=arguments));
		announce("Removed index #arguments.indexName# from table #arguments.table#");
	}

	/**
    * Executes a raw sql query
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @sql Arbitary SQL String
	*/
	public void function execute(required string sql) {
		$execute(arguments.sql);
		announce("Executed SQL: #arguments.sql#");
	}

	/**
    * Adds a record to a table
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table name to add the record to
	*/
	public void function addRecord(required string table) {
		local.columnNames = "";
		local.columnValues = "";
		if(!StructKeyExists(arguments, application.wheels.timeStampOnCreateProperty) && ListFindNoCase($getColumns(arguments.table), application.wheels.timeStampOnCreateProperty)) {
			arguments[application.wheels.timeStampOnCreateProperty] = $timestamp();
		}
		if(application.wheels.setUpdatedAtOnCreate && !StructKeyExists(arguments, application.wheels.timeStampOnUpdateProperty) && ListFindNoCase($getColumns(arguments.table), application.wheels.timeStampOnUpdateProperty)) {
			announce(application.wheels.setUpdatedAtOnCreate);
			arguments[application.wheels.timeStampOnUpdateProperty] = $timestamp();
		}

		for (local.key in arguments) {
			if(local.key neq "table") {
				local.columnNames = ListAppend(local.columnNames,this.adapter.quoteColumnName(local.key));
				if(IsNumeric(arguments[local.key])) {
					local.columnValues = ListAppend(local.columnValues,arguments[local.key]);
				} else if(IsBoolean(arguments[local.key])) {
					local.columnValues = ListAppend(local.columnValues,IIf(arguments[local.key],1,0));
				} else if(IsDate(arguments[local.key])) {
					local.columnValues = ListAppend(local.columnValues,"#arguments[local.key]#");
				} else {
					local.columnValues = ListAppend(local.columnValues,"'#ReplaceNoCase(arguments[local.key],"'","''","all")#'");
				}
			}
		}
		if(local.columnNames != '') {
			if(ListContainsNoCase(local.columnnames, "[id]")) {
				$execute(this.adapter.addRecordPrefix(arguments.table));
			}
			$execute("INSERT INTO #this.adapter.quoteTableName(arguments.table)# ( #local.columnNames# ) VALUES ( #local.columnValues# )");
			if(ListContainsNoCase(local.columnnames, "[id]")) {
				$execute(this.adapter.addRecordSuffix(arguments.table));
			}
			announce("Added record to table #arguments.table#");
		}
	}

	/**
    * Updates an existing record in a table
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table name where the record is
	* @where The where clause, i.e admin = 1
    */
	public void function updateRecord(required string table, string where="") {
		local.columnUpdates = "";
		if (!StructKeyExists(arguments, application.wheels.timeStampOnUpdateProperty) && ListFindNoCase($getColumns(arguments.table), application.wheels.timeStampOnUpdateProperty)) {
			arguments[application.wheels.timeStampOnUpdateProperty] = $timestamp();
		}
		for (local.key in arguments) {
			if(local.key neq "table" && local.key neq "where") {
				local.update = "#this.adapter.quoteColumnName(local.key)# = ";
				if(IsNumeric(arguments[local.key])) {
					local.update = local.update & "#arguments[local.key]#";
				} else if(IsBoolean(arguments[local.key])) {
					local.update = local.update & "#IIf(arguments[local.key],1,0)#";
				} else if(IsDate(arguments[local.key])) {
					local.update = local.update & "#arguments[local.key]#";
				} else {
					arguments[local.key] = ReplaceNoCase(arguments[local.key], "'", "''", "all");
					local.update = local.update & "'#arguments[local.key]#'";
				}
				local.columnUpdates = ListAppend(local.columnUpdates,local.update);
			}
		}
		if(local.columnUpdates != '') {
			local.sql = 'UPDATE #this.adapter.quoteTableName(arguments.table)# SET #local.columnUpdates#';
			local.message = 'Updated record(s) in table #arguments.table#';
			if(arguments.where != '') {
				local.sql = local.sql & ' WHERE #arguments.where#';
				local.message = local.message & ' where #arguments.where#';
			}
			$execute(local.sql);
			announce(local.message);
		}
	}

	/**
    * Removes existing records from a table
	* Only available in a migration CFC
	*
	* [section: Configuration]
	* [category: Migration Reference]
	*
	* @table The table name to remove the record from
	* @where The where clause, i.e id = 123
    */
	public void function removeRecord(required string table, string where="") {
		local.sql = 'DELETE FROM #this.adapter.quoteTableName(arguments.table)#';
		local.message = 'Removed record(s) from table #arguments.table#';
		if(arguments.where != '') {
			local.sql = local.sql & ' WHERE #arguments.where#';
			local.message = local.message & ' where #arguments.where#';
		}
		$execute(local.sql);
		announce(local.message);
	}
}

component extends="Base" {

	public any function init(
		required any adapter,
		required string name,
		boolean force = "true",
		boolean id = "true",
		string primaryKey = "id"
	) {
		local.args = "adapter,name,force";
		this.primaryKeys = [];
		this.foreignKeys = [];
		this.columns = [];
		local.iEnd = ListLen(local.args);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.argumentName = ListGetAt(local.args, local.i);
			if (StructKeyExists(arguments, local.argumentName)) {
				this[local.argumentName] = arguments[local.argumentName];
			}
		}
		if (arguments.id && Len(arguments.primaryKey)) {
			this.primaryKey(name = arguments.primaryKey, autoIncrement = true);
		}
		return this;
	}

	/**
	 * Adds a primary key definition to the table. this method also allows for multiple primary keys.
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function primaryKey(
		required string name,
		string type = "integer",
		boolean autoIncrement = "false",
		numeric limit,
		numeric precision,
		numeric scale,
		string references,
		string onUpdate = "",
		string onDelete = ""
	) {
		arguments.null = false;
		arguments.adapter = this.adapter;

		// don't allow multiple autoIncrement primarykeys
		if (ArrayLen(this.primaryKeys) && arguments.autoIncrement) {
			Throw(message = "You cannot have multiple auto increment primary keys.");
		}

		local.column = CreateObject("component", "ColumnDefinition").init(argumentCollection = arguments);
		ArrayAppend(this.primaryKeys, local.column);

		if (StructKeyExists(arguments, "references")) {
			local.referenceTable = pluralize(arguments.references);
			local.foreignKey = CreateObject("component", "ForeignKeyDefinition").init(
				adapter = this.adapter,
				table = this.name,
				referenceTable = local.referenceTable,
				column = arguments.name,
				referenceColumn = "id",
				onUpdate = arguments.onUpdate,
				onDelete = arguments.onDelete
			);
			ArrayAppend(this.foreignKeys, local.foreignKey);
		}
		return this;
	}

	/**
	 * Adds a column to table definition.
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function column(
		required string columnName,
		required string columnType,
		string default,
		boolean null,
		any limit,
		numeric precision,
		numeric scale
	) {
		arguments.adapter = this.adapter;
		arguments.name = arguments.columnName;
		arguments.type = arguments.columnType;
		local.column = CreateObject("component", "ColumnDefinition").init(argumentCollection = arguments);
		ArrayAppend(this.columns, local.column);
		return this;
	}

	/**
	 * Adds integer columns to table definition.
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function bigInteger(string columnNames, numeric limit, string default, boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "biginteger";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * Adds binary columns to table definition.
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function binary(string columnNames, string default, boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "binary";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * Adds boolean columns to table definition.
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function boolean(string columnNames, string default, boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "boolean";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * Adds date columns to table definition.
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function date(string columnNames, string default, boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "date";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds datetime columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function datetime(string columnNames, string default, boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "datetime";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds decimal columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function decimal(string columnNames, string default, boolean null, numeric precision, numeric scale) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "decimal";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds float columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function float(string columnNames, string default = "", boolean null = "true") {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "float";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds integer columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function integer(string columnNames, numeric limit, string default, boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "integer";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds string columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function string(string columnNames, any limit, string default, boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "string";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds char columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function char(string columnNames, any limit, string default, boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "char";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds text columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function text(string columnNames, string default, boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "text";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds UUID columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function uniqueidentifier(string columnNames, string default = "newid()", boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "uniqueidentifier";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds time columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function time(string columnNames, string default, boolean null) {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		arguments.columnType = "time";
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds timestamp columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function timestamp(string columnNames, string default, boolean null, string columnType = "datetime") {
		$combineArguments(args = arguments, combine = "columnNames,columnName", required = true);
		local.iEnd = ListLen(arguments.columnNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			arguments.columnName = Trim(ListGetAt(arguments.columnNames, local.i));
			column(argumentCollection = arguments);
		}
		return this;
	}

	/**
	 * adds CFWheels convention automatic timestamp and soft delete columns to table definition
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function timestamps() {
		local.columnNames = ArrayToList([$get("timeStampOnCreateProperty"), $get("timeStampOnUpdateProperty"), $get("softDeleteProperty")]);
		timestamp(columnNames = local.columnNames, null = true);
		return this;
	}

	/**
	 * adds integer reference columns to table definition and creates foreign key constraints
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public any function references(
		required string referenceNames,
		string default,
		boolean null = "false",
		boolean polymorphic = "false",
		boolean foreignKey = "true",
		string onUpdate = "",
		string onDelete = ""
	) {
		local.iEnd = ListLen(arguments.referenceNames);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			local.referenceName = ListGetAt(arguments.referenceNames, local.i);

			// get all possible arguments for the column
			local.columnArgs = {};
			for (local.arg in ListToArray("columnType,default,null,limit,precision,scale"))
				if (StructKeyExists(arguments, local.arg)) local.columnArgs[local.arg] = arguments[local.arg];

			// default the column to an integer if not provided
			if (!StructKeyExists(local.columnArgs, "columnType")) local.columnArgs.columnType = "integer";

			column(columnName = local.referenceName & "id", argumentCollection = local.columnArgs);

			if (arguments.polymorphic) column(columnName = local.referenceName & "type", columnType = "string");

			if (arguments.foreignKey && !arguments.polymorphic) {
				local.referenceTable = pluralize(local.referenceName);
				local.foreignKey = CreateObject("component", "ForeignKeyDefinition").init(
					adapter = this.adapter,
					table = this.name,
					referenceTable = local.referenceTable,
					column = "#local.referenceName#id",
					referenceColumn = "id",
					onUpdate = arguments.onUpdate,
					onDelete = arguments.onDelete
				);
				ArrayAppend(this.foreignKeys, local.foreignKey);
			}
		}
		return this;
	}

	/**
	 * creates the table in the database
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public void function create() {
		if (this.force) {
			$execute(this.adapter.dropTable(this.name));
			announce("Dropped table #objectCase(this.name)#");
		}
		$execute(
			this.adapter.createTable(
				name = this.name,
				primaryKeys = this.primaryKeys,
				columns = this.columns,
				foreignKeys = this.foreignKeys
			)
		);
		announce("Created table #objectCase(this.name)#");
		local.iEnd = ArrayLen(this.foreignKeys);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			announce("--> added foreign key #this.foreignKeys[local.i].name#");
		}
	}

	/**
	 * alters existing table in the database
	 *
	 * [section: Migrator]
	 * [category: Table Definition Functions]
	 */
	public void function change(boolean addColumns = "false") {
		local.existingColumns = $getColumns(this.name);
		local.iEnd = ArrayLen(this.columns);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			if (arguments.addColumns || !ListFindNoCase(local.existingColumns, this.columns[local.i].name)) {
				$execute(this.adapter.addColumnToTable(name = this.name, column = this.columns[local.i]));
				announce("Added column #this.columns[local.i].name# to table #this.name#");
			} else {
				$execute(this.adapter.changeColumnInTable(name = this.name, column = this.columns[local.i]));
				announce("Changed column #this.columns[local.i].name# in table #this.name#");
			}
		}
		local.iEnd = ArrayLen(this.foreignKeys);
		for (local.i = 1; local.i <= local.iEnd; local.i++) {
			$execute(this.adapter.addForeignKeyToTable(name = this.name, foreignKey = this.foreignKeys[local.i]));
			announce("Added foreign key #this.foreignKeys[local.i].name# to table #this.name#");
		}
	}

}

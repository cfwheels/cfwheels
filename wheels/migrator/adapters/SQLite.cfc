component extends="Abstract" {

	variables.sqlTypes = {};
	variables.sqlTypes['binary'] = {name='blob'};
	variables.sqlTypes['boolean'] = {name='integer',limit=1};
	variables.sqlTypes['date'] = {name='integer'};
	variables.sqlTypes['datetime'] = {name='integer'};
	variables.sqlTypes['decimal'] = {name='real'};
	variables.sqlTypes['float'] = {name='real'};
	variables.sqlTypes['integer'] = {name='integer'};
	variables.sqlTypes['string'] = {name='text',limit=255};
	variables.sqlTypes['text'] = {name='text'};
	variables.sqlTypes['time'] = {name='integer'};
	variables.sqlTypes['timestamp'] = {name='integer'};

	/**
  * name of database adapter
  */
	public string function adapterName() {
		return "SQLite";
	}

	public string function addPrimaryKeyOptions(required string sql, struct options = {}) {
		if (StructKeyExists(arguments.options, "null") && arguments.options.null) {
			arguments.sql = arguments.sql & " NULL";
		} else {
			arguments.sql = arguments.sql & " NOT NULL";
		}
		arguments.sql = arguments.sql & " PRIMARY KEY";
		if (StructKeyExists(arguments.options, "autoIncrement") && arguments.options.autoIncrement) {
			arguments.sql = arguments.sql & " AUTOINCREMENT";
		}
		return arguments.sql;
	}

	/**
  * surrounds column names with quotes
	* SQLite uses double quotes to escape table and column names
  */
	public string function quoteColumnName(required string name) {
		return '"#objectCase(arguments.name)#"';
	}
}

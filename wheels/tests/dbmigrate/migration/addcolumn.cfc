component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
		originalDbmigrateObjectCase = Duplicate(application.wheels.dbmigrateObjectCase);
	}

	function teardown() {
		application.wheels.dbmigrateObjectCase = originalDbmigrateObjectCase;
	}

	// it's tricky to test the objectCase as some db engines support mixed case database object names (MSSQL does)
	function test_addColumn_creates_new_column() {
		application.wheels.dbmigrateObjectCase = ""; // keep the specified case
		if(!application.testenv.isOracle){
		tableName = "dbm_addcolumn_tests";
		columnName = "integerCOLUMN";
		t = migration.createTable(name=tableName, force=true);
		t.string(columnNames="stringcolumn");
		t.create();

		migration.addColumn(table=tableName, columnType='integer', columnName=columnName, null=true);
		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		actual = ValueList(info.column_name);
		expected = columnName;
		migration.dropTable(tableName);

	  assert("ListFindNoCase(actual, expected)", "expected", "actual");
	}
	}
}

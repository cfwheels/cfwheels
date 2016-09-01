component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
	}

	function test_addColumn_creates_new_column() {
		tableName = "dbm_addcolumn_tests";
		t = migration.createTable(name=tableName);
		t.string(columnNames="stringcolumn");
		t.create();

		migration.addColumn(table=tableName, columnType='integer', columnName='integercolumn', null=true);
		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		actual = ValueList(info.column_name);
		expected = "integercolumn";
		migration.dropTable(tableName);

	  assert("ListFindNoCase(actual, expected)", "expected", "actual");
	}
}

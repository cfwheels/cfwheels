component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
	}

	function test_changeTable_changes_table_column_definitions() {
		tableName = "dbm_changetable_tests";
		t = migration.createTable(name=tableName, force=true);
		t.string(columnNames='stringcolumn', limit=255);
		t.integer(columnNames='integercolumn', default=0);
		t.create();

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		beforeString = $query(query=info, dbtype="query", sql="SELECT * FROM query WHERE column_name = 'stringcolumn'");
		beforeInteger = $query(query=info, dbtype="query", sql="SELECT * FROM query WHERE column_name = 'integercolumn'");

		t = migration.changeTable(name=tableName);
		t.string(columnNames='stringcolumn', limit=666);
		t.integer(columnNames='integercolumn', default=666);
		t.change();

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		afterString = $query(query=info, dbtype="query", sql="SELECT * FROM query WHERE column_name = 'stringcolumn'");
		afterInteger = $query(query=info, dbtype="query", sql="SELECT * FROM query WHERE column_name = 'integercolumn'");

		migration.dropTable(tableName);

		assert("beforeString.column_size eq 255");
		assert("beforeInteger.column_default_value eq 0");
		assert("afterString.column_size eq 666");
		assert("afterInteger.column_default_value eq 666");
	}
}

component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
	}

	// more tests needed.. changing datatypes.. etc

	function test_changeColumn_changes_column() {
		tableName = "dbm_changecolumn_tests";
		columnName = "stringcolumn";

		t = migration.createTable(name=tableName, force=true);
		t.string(columnNames=columnName, limit=10, null=false);
		t.create();

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);

		migration.changeColumn(
			table=tableName,
			columnName=columnName,
			columnType='string',
			limit=50,
			null=true,
			default="foo"
		);

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		migration.dropTable(tableName);

		actual = $query(query=info, dbtype="query", sql="SELECT * FROM query WHERE column_name = '#columnName#'");

		assert("actual.nullable");
		assert("actual.column_size eq 50");
		assert("actual.column_default_value eq 'foo'");
	}

}

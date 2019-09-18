component extends="wheels.tests.Test" {

	private boolean function isDbCompatible() {
		switch (migration.adapter.adapterName()) {
			case "H2":
			case "MicrosoftSQLServer":
			case "MySQL":
			case "PostgreSQL":
				return true;
			default:
				return false;
		}
	}

	private string function getStringType() {
		switch (migration.adapter.adapterName()) {
			case "H2":
			case "MicrosoftSQLServer":
			case "MySQL":
			case "PostgreSQL":
				return "VARCHAR";
			default:
				return "`addstring()` not supported for " & migration.adapter.adapterName();
		}
	}

	function setup() {
		migration = CreateObject("component", "wheels.migrator.Migration").init();
		originalMigratorObjectCase = Duplicate(application.wheels.migratorObjectCase);
	}

	function teardown() {
		application.wheels.migratorObjectCase = originalMigratorObjectCase;
	}

	function test_add_a_string_column() {
		if (!isDbCompatible()) {
			return;
		}

		tableName = "dbm_add_string_tests";
		columnName = "stringCOLUMN";
		t = migration.createTable(name=tableName, force=true);
		t.string(columnName=columnName);
		t.create();

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		actual = listToArray(valueList(info.TYPE_NAME))[2];
		migration.dropTable(tableName);

		expected = getStringType();

    	assert("actual eq expected");
	}

	function test_add_multiple_string_columns() {
		if (!isDbCompatible()) {
			return;
		}

		tableName = "dbm_add_string_tests";
		columnNames = "stringA,stringB";
		t = migration.createTable(name=tableName, force=true);
		t.string(columnNames=columnNames);
		t.create();

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		actual = listToArray(valueList(info.TYPE_NAME));
		migration.dropTable(tableName);

		expected = getStringType();

		assert("actual[2] eq expected");
    	assert("actual[3] eq expected");
	}
}

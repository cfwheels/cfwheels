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

	private string function getIntegerType() {
		switch (migration.adapter.adapterName()) {
			case "H2":
			case "MicrosoftSQLServer":
			case "MySQL":
				return "INT";
			case "PostgreSQL":
				return "INTEGER";
			default:
				return "`addinteger()` not supported for " & migration.adapter.adapterName();
		}
	}

	function setup() {
		migration = CreateObject("component", "wheels.migrator.Migration").init();
		originalMigratorObjectCase = Duplicate(application.wheels.migratorObjectCase);
	}

	function teardown() {
		application.wheels.migratorObjectCase = originalMigratorObjectCase;
	}

	function test_add_a_integer_column() {
		if (!isDbCompatible()) {
			return;
		}

		tableName = "dbm_add_integer_tests";
		columnName = "integerCOLUMN";
		t = migration.createTable(name=tableName, force=true);
		t.integer(columnName=columnName);
		t.create();

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		actual = listToArray(valueList(info.TYPE_NAME))[2];
		migration.dropTable(tableName);

		expected = getIntegerType();

    	assert("actual eq expected");
	}

	function test_add_multiple_integer_columns() {
		if (!isDbCompatible()) {
			return;
		}

		tableName = "dbm_add_integer_tests";
		columnNames = "integerA,integerB";
		t = migration.createTable(name=tableName, force=true);
		t.integer(columnNames=columnNames);
		t.create();

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		actual = listToArray(valueList(info.TYPE_NAME));
		migration.dropTable(tableName);

		expected = getIntegerType();

		assert("actual[2] eq expected");
    	assert("actual[3] eq expected");
	}
}

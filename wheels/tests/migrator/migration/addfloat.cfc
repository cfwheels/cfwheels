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

	private string function getFloatType() {
		switch (migration.adapter.adapterName()) {
			case "H2":
			case "MicrosoftSQLServer":
			case "MySQL":
			case "PostgreSQL":
				return "FLOAT";
			default:
				return "`addfloat()` not supported for " & migration.adapter.adapterName();
		}
	}

	function setup() {
		migration = CreateObject("component", "wheels.migrator.Migration").init();
		originalMigratorObjectCase = Duplicate(application.wheels.migratorObjectCase);
	}

	function teardown() {
		application.wheels.migratorObjectCase = originalMigratorObjectCase;
	}

	function test_add_a_float_column() {
		if (!isDbCompatible()) {
			return;
		}

		tableName = "dbm_add_float_tests";
		columnName = "floatCOLUMN";
		t = migration.createTable(name=tableName, force=true);
		t.float(columnName=columnName);
		t.create();

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		actual = listToArray(valueList(info.TYPE_NAME))[2];
		migration.dropTable(tableName);

		expected = getFloatType();

    	assert("actual eq expected");
	}

	function test_add_multiple_float_columns() {
		if (!isDbCompatible()) {
			return;
		}

		tableName = "dbm_add_float_tests";
		columnNames = "floatA,floatB";
		t = migration.createTable(name=tableName, force=true);
		t.float(columnNames=columnNames);
		t.create();

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="columns"
		);
		actual = listToArray(valueList(info.TYPE_NAME));
		migration.dropTable(tableName);

		expected = getFloatType();

		assert("actual[2] eq expected");
    	assert("actual[3] eq expected");
	}
}

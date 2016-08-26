component extends="wheels.tests.Test" {

	include "helpers.cfm";

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
		$createTable();
	}

	function teardown() {
		$dropTable();
	}

	function test_addColumn_creates_new_column() {
		migration.addColumn(table='dbmigrationtabletests', columnType='integer', columnName='somenumber', null=true);
		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table="dbmigrationtabletests",
			type="columns"
		);
		actual = ValueList(info.column_name);
		expected = "somenumber";
	  assert("ListFindNoCase(actual, expected)", "expected", "actual");
	}
}

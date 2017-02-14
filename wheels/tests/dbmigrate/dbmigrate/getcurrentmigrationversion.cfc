component extends="wheels.tests.Test" {

	include "helpers.cfm";

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
		dbmigrate = CreateObject("component", "wheels.dbmigrate.dbmigrate").init(
			migratePath="wheels/tests/_assets/db/migrate/",
			sqlPath="wheels/tests/_assets/db/sql/"
		);
		for (local.table in ["bunyips","dropbears","hoopsnakes","schemainfo"]) {
			migration.dropTable(local.table);
		};
	}

	function teardown() {
		$cleanSqlDirectory();
	}

	function test_getCurrentMigrationVersion_returns_expected_value() {
		if(!application.testenv.isOracle){
			expected = "002";
			dbmigrate.migrateTo(expected);
			actual = dbmigrate.getCurrentMigrationVersion();
			assert("actual eq expected");
		}
	}
}

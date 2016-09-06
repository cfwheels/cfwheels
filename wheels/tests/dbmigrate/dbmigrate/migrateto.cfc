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

	function test_migrateto_migrate_up_from_0_to_001() {
		dbmigrate.migrateTo(001);
		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			type="tables"
		);

		actual = ValueList(info.table_name);
		expected = "bunyips";

	  assert("ListFindNoCase(actual, expected)", "expected", "actual");
	}

	function test_migrateto_migrate_up_from_0_to_003() {
		dbmigrate.migrateTo(003);
		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			type="tables"
		);

		actual = ValueList(info.table_name);

	  assert("ListFindNoCase(actual, 'bunyips')");
		assert("ListFindNoCase(actual, 'dropbears')");
		assert("ListFindNoCase(actual, 'hoopsnakes')");
	}

	function test_migrateto_migrate_down_from_003_to_001() {
		dbmigrate.migrateTo(003);
		dbmigrate.migrateTo(001);
		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			type="tables"
		);

		actual = ValueList(info.table_name);

	  assert("ListFindNoCase(actual, 'bunyips')");
		assert("!ListFindNoCase(actual, 'dropbears')");
		assert("!ListFindNoCase(actual, 'hoopsnakes')");
	}

	// TODO: test that sql scripts have been written to dbmigrate.sqlPath

}

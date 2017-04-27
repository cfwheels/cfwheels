component extends="wheels.tests.Test" {

	include "helpers.cfm";

	function setup() {
		migrationPath =
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
		dbmigrate = CreateObject("component", "wheels.dbmigrate").init(
			migratePath="wheels/tests/_assets/db/migrate/",
			sqlPath="wheels/tests/_assets/db/sql/"
		);
		for (local.table in ["bunyips","dropbears","hoopsnakes","schemainfo","dbmigrateversions"]) {
			migration.dropTable(local.table);
		};
		$cleanSqlDirectory();
		originalDbmigrateWriteSQLFiles = Duplicate(application.wheels.dbmigrateWriteSQLFiles);
		originalDbmigrateTableName = Duplicate(application.wheels.dbmigrateTableName);
	}

	function teardown() {
		$cleanSqlDirectory();
		// revert to orginal values
		application.wheels.dbmigrateWriteSQLFiles = originalDbmigrateWriteSQLFiles;
		application.wheels.dbmigrateTableName = originalDbmigrateTableName;
	}

	function test_redomigration_001() {
		if(!application.testenv.isOracle){
			dbmigrate.migrateTo(001);

			// add a new column and redo the migration
			local.path = Expandpath("/wheels/tests/_assets/db/migrate/001_create_bunyips_table.cfc");
			local.content = FileRead(local.path);
			local.content = ReplaceNoCase(local.content, 'columnNames="name"', 'columnNames="name,hobbies"', "one");
			FileWrite(local.path,local.content);
			dbmigrate.redoMigration(001);

			info = $dbinfo(
				datasource=application.wheels.dataSourceName,
				type="columns",
				table="bunyips"
			);

			actual = ValueList(info.column_name);
			assert("ListFindNoCase(actual, 'name')", "actual");
			assert("ListFindNoCase(actual, 'hobbies')", "actual");
		}
	}

}

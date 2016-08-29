component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
	}

	function test_renameTable_renames_table() {
		oldTableName = "dbm_renametable_tests";
		newTableName = "dbm_renametable_new_tests";
		t = migration.createTable(oldTableName);
		t.string(columnNames="stringcolumn");
		t.create();
		migration.renameTable(oldName=oldTableName, newName=newTableName);
		try {
			model(newTableName).findAll();
			migration.dropTable(newTableName);
			assert("true");
		} catch(any e) {
			assert("false");
		}
	}

}

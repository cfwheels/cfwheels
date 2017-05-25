component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.migrator.Migration").init();
	}

	function test_renameTable_renames_table() {
		if(!application.testenv.isOracle){
		oldTableName = "dbm_renametable_tests";
		newTableName = "dbm_new_renametable_tests";
		t = migration.createTable(name=oldTableName, force=true);
		t.string(columnNames="stringcolumn");
		t.create();
		migration.renameTable(oldName=oldTableName, newName=newTableName);
		try {
			model(newTableName).findAll();
			migration.dropTable(newTableName);
			assert("true");
		} catch (any e) {
			assert("false");
		}
	}
	}

}

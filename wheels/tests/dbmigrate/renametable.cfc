component extends="wheels.tests.Test" {

	include "helpers.cfm";

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
		$createTable();
	}

	function teardown() {
		migration.dropTable("renamedbmigrationtabletests");
	}

	function test_renameTable_renames_table() {
		migration.renameTable(oldName='dbmigrationtabletests', newName='renamedbmigrationtabletests');
		try {
			model("renamedbmigrationtabletests").findAll();
			assert("true");
		} catch(any e) {
			assert("false");
		}
	}

}

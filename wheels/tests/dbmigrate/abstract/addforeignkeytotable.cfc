component extends="wheels.tests.Test" {

	function packageSetup() {
		abstract = CreateObject("component", "wheels.dbmigrate.adapters.abstract");
	}

	function _test_addForeignKeyToTable() {
	  // actual = abstract.addForeignKeyToTable();
	  // expected = "ALTER TABLE 'foos' RENAME 'bars'";
	  assert("false"); // TODO
	  assert("actual eq expected");
	}
}

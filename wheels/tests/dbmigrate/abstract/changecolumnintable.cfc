component extends="wheels.tests.Test" {

	function packageSetup() {
		abstract = CreateObject("component", "wheels.dbmigrate.adapters.abstract");
	}

	function _test_changeColumnInTable() {
	  // actual = abstract.changeColumnInTable();
	  // expected = "ALTER TABLE 'foos' RENAME 'bars'";
	  assert("false"); // TODO
	  assert("actual eq expected");
	}
}

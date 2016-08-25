component extends="wheels.tests.Test" {

	function packageSetup() {
		abstract = CreateObject("component", "wheels.dbmigrate.adapters.abstract");
	}

	function _test_cropColumnFromTable() {
	  // actual = abstract.cropColumnFromTable();
	  // expected = "ALTER TABLE 'foos' RENAME 'bars'";
	  assert("false"); // TODO
	  assert("actual eq expected");
	}
}

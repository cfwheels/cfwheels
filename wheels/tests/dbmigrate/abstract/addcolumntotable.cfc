component extends="wheels.tests.Test" {

	function packageSetup() {
		abstract = CreateObject("component", "wheels.dbmigrate.adapters.abstract");
	}

	function _test_abstract_addColumnToTable_returns_expected_sql_statement() {
	  actual = abstract.addColumnToTable(name="foos", newName="bars");
	  expected = "ALTER TABLE 'foos' RENAME 'bars'";
	  assert("actual eq expected");

	}
}

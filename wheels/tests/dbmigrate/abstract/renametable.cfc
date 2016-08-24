component extends="wheels.tests.Test" {

	function packageSetup() {
		abstract = CreateObject("component", "wheels.dbmigrate.adapters.abstract");
	}

	function test_abstract_renameTable_returns_expected_sql_statement() {
	  actual = abstract.renameTable(oldName="foos", newName="bars");
	  expected = "ALTER TABLE 'foos' RENAME 'bars'";
	  assert("actual eq expected");
	}
}

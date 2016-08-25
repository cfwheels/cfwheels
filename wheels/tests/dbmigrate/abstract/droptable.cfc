component extends="wheels.tests.Test" {

	function packageSetup() {
		abstract = CreateObject("component", "wheels.dbmigrate.adapters.abstract");
	}

	function test_abstract_dropTable_returns_expected_sql_statement() {
	  actual = abstract.dropTable(name="foos");
	  expected = "DROP TABLE IF EXISTS 'foos'";
	  assert("actual eq expected");
	}
}

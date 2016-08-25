component extends="wheels.tests.Test" {

	function packageSetup() {
		abstract = CreateObject("component", "wheels.dbmigrate.adapters.abstract");
	}

	function test_abstract_removeIndex_returns_expected_sql_statement() {
	  actual = abstract.removeIndex(table="foos", indexName="idx");
	  expected = "DROP INDEX 'idx'";
	  assert("actual eq expected");
	}
}

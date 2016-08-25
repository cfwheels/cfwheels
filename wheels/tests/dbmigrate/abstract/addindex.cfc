component extends="wheels.tests.Test" {

	function packageSetup() {
		abstract = CreateObject("component", "wheels.dbmigrate.adapters.abstract");
	}

	function test_addIndex_unique_returns_expected_sql_statement() {
	  actual = abstract.addIndex(table="foos", columnNames="firstname,lastname", unique=true);
	  expected = "CREATE UNIQUE INDEX 'foos_firstname' ON 'foos'('firstname','lastname')";
	  assert("actual eq expected");
	}

	function test_addIndex_with_indexName_returns_expected_sql_statement() {
	  actual = abstract.addIndex(table="foos", columnNames="firstname,lastname", indexName="idx_foo");
	  expected = "CREATE INDEX 'idx_foo' ON 'foos'('firstname','lastname')";
	  assert("actual eq expected");
	}
}

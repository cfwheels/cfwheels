component extends="wheels.tests.Test" {

	function packageSetup() {
		abstract = CreateObject("component", "wheels.dbmigrate.adapters.abstract");
	}

	function test_mysql_renameColumnInTable_returns_expected_sql_statement() {
	  actual = abstract.renameColumnInTable(name="foos", columnName="bazname", newColumnName="quxname");
	  expected = "ALTER TABLE 'foos' RENAME COLUMN 'bazname' TO 'quxname'";
	  assert("actual eq expected");
	}
}

component extends="wheels.tests.Test" {

	function packageSetup() {
		mysql = CreateObject("component", "wheels.dbmigrate.adapters.mysql");
	}

	function test_mysql_removeIndex_returns_expected_sql_statement() {
	  actual = mysql.removeIndex(table="foos", indexName="idx");
	  expected = "DROP INDEX `idx` ON `foos`";
	  assert("actual eq expected");
	}
}

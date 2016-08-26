component extends="wheels.tests.Test" {

	include "helpers.cfm";

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
		$createTable();
	}

	function teardown() {
		$dropTable();
	}

	function test_createTable_generates_table() {
		actual = ListSort(model("dbmigrationtabletests").findAll().columnList, "text");
		expected = ListSort("id,stringcolumn,textcolumn,booleancolumn,integercolumn,binarycolumn,datecolumn,datetimecolumn,timecolumn,decimalcolumn,floatcolumn,charcolumn,uniqueidentifiercolumn,createdat,updatedat,deletedat", "text");
	  assert("actual eq expected");
	}

}

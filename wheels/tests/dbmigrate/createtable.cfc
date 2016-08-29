component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
	}

	function test_createTable_generates_table() {
		tableName = "dbmigration_createtable_tests";
		t = migration.createTable(tableName);
		t.string(columnNames='stringcolumn', limit=255);
		t.text(columnNames='textcolumn');
		t.boolean(columnNames='booleancolumn', default=false, null=false);
		t.integer(columnNames='integercolumn', default=0);
		t.binary(columnNames="binarycolumn");
		t.date(columnNames="datecolumn");
		t.dateTime(columnNames="datetimecolumn");
		t.time(columnNames="timecolumn");
		t.decimal(columnNames="decimalcolumn");
		t.float(columnNames="floatcolumn");
    // TODO: this datatype doesnt work on sqlserver
    // t.bigInteger(columnNames="bigintegercolumn", default=0);
    t.timeStamps();
		t.create();

		actual = ListSort(model(tableName).findAll().columnList, "text");
		expected = ListSort("id,stringcolumn,textcolumn,booleancolumn,integercolumn,binarycolumn,datecolumn,datetimecolumn,timecolumn,decimalcolumn,floatcolumn,createdat,updatedat,deletedat", "text");

		migration.dropTable(tableName);
		assert("actual eq expected");
	}

	function test_createTable_generates_table_using_MicrosoftSQLServer_datatypes() {
		tableName = "dbmigration_createtable_MicrosoftSQLServer_tests";
		if (migration.adapter.adapterName() eq "MicrosoftSQLServer") {
			t = migration.createTable(tableName);
			t.char(columnNames="charcolumn");
			t.uniqueIdentifier(columnNames="uniqueidentifiercolumn");
			t.create();
			actual = ListSort(model(tableName).findAll().columnList, "text");
			expected = ListSort("id,charcolumn,uniqueidentifiercolumn", "text");
			migration.dropTable(tableName);
		  assert("actual eq expected");
		}
	}

}

component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
	}

	function test_createTable_generates_table() {
		tableName = "dbm_addrecord_tests";
		recordValue = "#RandRange(0, 99)# bottles of beer on the wall...";

		t = migration.createTable(tableName);
		t.string(columnNames="beers");
    t.timeStamps();
		t.create();
		migration.addRecord(table=tableName, beers=recordValue);
		actual = $query(
			datasource=application.wheels.dataSourceName,
			sql="SELECT * FROM #tableName# WHERE beers = '#recordValue#'"
		);
		expected = 1;

		migration.dropTable(tableName);
		assert("actual.RecordCount eq expected");
	}

}

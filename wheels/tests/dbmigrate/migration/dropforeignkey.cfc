component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
	}

	function test_dropForeignKey_drops_a_foreign_key_constraint() {
		tableName = "dbm_dfk_foos";
		referenceTableName = "dbm_dfk_bars";

		t = migration.createTable(name=tableName, force=true);
		t.integer(columnNames="barid");
		t.create();

		t = migration.createTable(name=referenceTableName, force=true);
		t.integer(columnNames="integercolumn");
		t.create();

		migration.addForeignKey(
			table=tableName,
			referenceTable=referenceTableName,
			column='barid',
			referenceColumn="id"
		);

		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=referenceTableName,
			type="foreignkeys"
		);

		created = $query(
			query=info,
			dbtype="query",
			sql="SELECT * FROM query WHERE fktable_name = '#ucase(tableName)#' AND fkcolumn_name = 'BARID' AND pkcolumn_name = 'ID'"
		);

		migration.dropForeignKey(table=tableName, keyName="FK_#tableName#_#referenceTableName#");
		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=referenceTableName,
			type="foreignkeys"
		);
		dropped = $query(
			query=info,
			dbtype="query",
			sql="SELECT * FROM query WHERE fktable_name = '#ucase(tableName)#' AND fkcolumn_name = 'BARID' AND pkcolumn_name = 'ID'"
		);

		migration.dropTable(tableName);
		migration.dropTable(referenceTableName);

	  assert("created.recordCount eq 1");
		assert("dropped.recordCount eq 0");
	}

}

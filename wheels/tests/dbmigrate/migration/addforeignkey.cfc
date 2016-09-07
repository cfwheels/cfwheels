component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
	}

	function test_addForeignKey_creates_a_foreign_key_constraint() {
		// oracle fk names cannot exceed 30 chars, so these table names must be short
		tableName = "dbm_afk_foos";
		referenceTableName = "dbm_afk_bars";

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

		migration.dropTable(tableName);
		migration.dropTable(referenceTableName);

		actual = $query(
			query=info,
			dbtype="query",
			sql="
				SELECT * FROM query
				WHERE pkcolumn_name = 'id'
				AND fktable_name = '#tableName#'
				AND fkcolumn_name = 'barid'
			"
		);

	  assert("actual.recordCount eq 1");
	}

}

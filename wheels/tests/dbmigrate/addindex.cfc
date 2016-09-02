component extends="wheels.tests.Test" {

	function setup() {
		migration = CreateObject("component", "wheels.dbmigrate.Migration").init();
	}

	function test_addIndex_creates_an_index() {
		tableName = "dbm_addindex_tests";
		indexName = "idx_foo";
		t = migration.createTable(name=tableName, force=true);
		t.integer(columnNames="integercolumn");
		t.create();

		migration.addIndex(table=tableName, columnNames='integercolumn', indexName=indexName);
		info = $dbinfo(
			datasource=application.wheels.dataSourceName,
			table=tableName,
			type="index"
		);

		migration.dropTable(tableName);

		actual = $query(query=info, dbtype="query", sql="SELECT * FROM query WHERE index_name = '#indexName#'");

	  assert("actual.recordCount eq 1");
		assert("actual.non_unique");
	}

	// todo: multi column index

	// todo: unique index

	// default index name

}

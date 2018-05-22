component extends="wheels.Test" {

	/*
	 * Executes once before the test suite runs.
	 * Populates the test database on reload or if the authors table does not exist.
	 */
	function beforeAll() {
		local.tables = $dbinfo(datasource=application.wheels.dataSourceName, type="tables");
		local.tableList = ValueList(local.tables.table_name);
		local.populate = StructKeyExists(url, "populate") ? url.populate : true;
		if (local.populate && (StructKeyExists(url, "reload") && url.reload == true) || !FindNoCase("authors", local.tableList)) {
			include "populate.cfm";
		}
	}

	/*
	 * Executes before every test case if called from the package via super.superSetup().
	 */
	function setup() {

	}

	/*
	 * Executes after every test case if called from the package via super.superTeardown().
	 */
	function teardown() {

	}

	/*
	 * Executes once after the test suite runs.
	 */
	function afterAll() {

	}

}

component extends="Wheels" {

	/*
	 * Executes once before the test suite runs.
	 * Populates the test database on reload or if there are no tables in the database.
	 */
	function beforeAll() {
		local.tables = $dbinfo(datasource=application.wheels.dataSourceName, type="tables");
		if ((StructKeyExists(url, "reload") && url.reload == true) || !local.tables.recordCount) {
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

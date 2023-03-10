/**
 * This is an example file, it can be safely deleted.
 * We recommend using the "functions" folder for testing controller, model and global functions.
 * The test suite is flexible though so you can safely rename folders and files to structure things how you want it.
 */
component extends="app.tests.Test" {

	/**
	 * Executes once before this package's first test case.
	 */
	function packageSetup() {
	}

	/**
	 * Executes before every test case.
	 */
	function setup() {
		super.setup();
	}

	/**
	 * An example test.
	 */
	function testExample() {
		assert("true");
	}

	/**
	 * Executes after every test case.
	 */
	function teardown() {
		super.teardown();
	}

	/**
	 * Executes once after this package's last test case.
	 */
	function packageTeardown() {
	}

}

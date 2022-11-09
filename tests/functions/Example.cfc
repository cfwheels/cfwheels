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

	/* 
		Test case for the bug below:
		https://github.com/cfwheels/cfwheels/issues/1115

		This test was made by creating a user scaffold and adding a textfield through function in the 
		_form partial that was used in the new.cfm for users.
		Then we add an addClass='text-dark' attribute in the textField method call.
		The response should be 'text-dark' appended to the "class" attribute of the input field.
	*/
	function testUsersFirstnameNotContainAddClassAttribute() {
		local.params = {
			controller = "users",
			action = "new"
		};

		result = processRequest(params=local.params, returnAs="struct");

		assert("result.status eq 200");
		assert("!(result.body contains 'addClass')");
	}

	function testUsersFirstnameContainsTextDarkClassAddedByAddClassAttribute() {
		local.params = {
			controller = "users",
			action = "new"
		};

		result = processRequest(params=local.params, returnAs="struct");

		assert("result.status eq 200");
		assert("result.body contains 'text-dark'");
	}

}

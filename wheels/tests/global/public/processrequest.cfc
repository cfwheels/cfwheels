component extends="wheels.tests.Test" {

	function test_process_request() {
		local.params = {
			action = "show",
			controller = "csrfProtectedExcept"
		};
		result = processRequest(local.params);
		expected = "Show ran";
		assert("Find(expected, result)");
	}

	function test_process_request_return_as_struct() {
		local.params = {
			action = "show",
			controller = "csrfProtectedExcept"
		};
		result = processRequest(params=local.params, returnAs="struct").status;
		expected = 200;
		assert("Compare(expected, result) eq 0");
	}

}

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

	function test_process_request_as_get() {
		local.params = {
			action = "actionGet",
			controller = "verifies"
		};
		result = processRequest(method="get", params=local.params);
		expected = "actionGet";
		assert("Find(expected, result)");
	}

	function test_process_request_as_post() {
		local.params = {
			action = "actionPost",
			controller = "verifies"
		};
		result = processRequest(method="post", params=local.params);
		expected = "actionPost";
		assert("Find(expected, result)");
	}

}

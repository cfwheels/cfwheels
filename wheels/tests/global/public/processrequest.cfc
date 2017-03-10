component extends="wheels.tests.Test" {

	function test_process_request() {
		local.params = {
			action = "wheels",
			controller = "wheels",
			route = "root"
		};
		result = processRequest(local.params);
		expected = "Congratulations";
		assert("Find(expected, result)");
	}

	function test_process_request_return_as_struct() {
		local.params = {
			action = "wheels",
			controller = "wheels",
			route = "root"
		};
		result = processRequest(params=local.params, returnAs="struct").status;
		expected = 200;
		assert("Compare(expected, result) == 0");
	}

}

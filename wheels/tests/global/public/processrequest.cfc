component extends="wheels.tests.Test" {

	function test_process_request() {
		local.params = {
			action = "wheels",
			controller = "wheels",
			route = "root"
		};
		local.result = processRequest(local.params);
		local.expected = "Congratulations";
		assert(Find(local.expected, local.result));
	}

	function test_process_request_return_as_struct() {
		local.params = {
			action = "wheels",
			controller = "wheels",
			route = "root"
		};
		local.result = processRequest(params=local.params, returnAs="struct").status;
		local.expected = 200;
		assert(Compare(local.expected, local.result) == 0);
	}

}

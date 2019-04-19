component extends="wheels.tests.Test" {

	function test_parsing_json_in_body() {
		local.dispatch = CreateObject("component", "wheels.Dispatch");
		local.args = {};
		local.args.params = {whatever = 1};
		local.httpRequestData = Duplicate(request.wheels.httpRequestData);
		request.wheels.httpRequestData.headers = {"Content-Type" = "application/vnd.api+json"};
		request.wheels.httpRequestData.content = '{"data":{"type":"users","id":"1","attributes":{"test":"Passed"}}}';
		result = local.dispatch.$parseJsonBody(argumentcollection=local.args).data.attributes.test;
		request.wheels.httpRequestData = Duplicate(local.httpRequestData);
		expected = "Passed";
		assert("result eq expected");
	}

	function test_parsing_array_json_in_body() {
		local.dispatch = CreateObject("component", "wheels.Dispatch");
		local.args = {};
		local.args.params = {whatever = 1};
		local.httpRequestData = Duplicate(request.wheels.httpRequestData);
		request.wheels.httpRequestData.headers = {"Content-Type" = "application/vnd.api+json"};
		request.wheels.httpRequestData.content = '[{"foo":"bar"}]';
		result = local.dispatch.$parseJsonBody(argumentcollection=local.args);
		request.wheels.httpRequestData = Duplicate(local.httpRequestData);
		keylist = StructKeyList(result);
		assert("listFindNoCase(keylist, 'whatever')");
		assert("listFindNoCase(keylist, '_json')");
	}

}

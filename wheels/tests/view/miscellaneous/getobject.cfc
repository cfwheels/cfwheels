component extends="wheels.tests.Test" {

	include "/wheels/view/miscellaneous.cfm";

	function test_getting_object_from_request_scope() {
		request.obj = model("post").findOne();
		result = $getObject("request.obj");
		assert("IsObject(result)");
	}

	function test_getting_object_from_default_scope() {
		obj = model("post").findOne();
		result = $getObject("obj");
		assert("IsObject(result)");
	}

	function test_getting_object_from_variables_scope() {
		variables.obj = model("post").findOne();
		result = $getObject("variables.obj");
		assert("IsObject(result)");
	}

}

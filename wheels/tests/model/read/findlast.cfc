component extends="wheels.tests.Test" {

	function test_find_first() {
		result = model("user").findLast();
		assert('result.id IS 5');
		result = model("user").findLast(properties="id");
		assert('result.id IS 5');
	}

}

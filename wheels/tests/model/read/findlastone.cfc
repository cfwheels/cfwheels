component extends="wheels.tests.Test" {

	function test_find_lastOne() {
		result = model("user").findLastOne();
		assert('result.id IS 5');
		result = model("user").findLastOne(properties="id");
		assert('result.id IS 5');
	}

}

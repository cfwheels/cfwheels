component extends="wheels.tests.Test" {

	function test_$cleantestcase_returns_expected_value() {
		loc.basePath = "wheels.tests.testframework";
		loc.actual = $cleanTestCase("wheels.tests.testframework.foo.bar", loc.basePath);
		loc.expected = "foo.bar";
		assert("loc.actual eq loc.expected");
	}
}

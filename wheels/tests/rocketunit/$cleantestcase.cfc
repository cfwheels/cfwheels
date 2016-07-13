<cfscript>
component extends="wheelsMapping.Test" {

	function setup() {
		loc.rocketUnit = CreateObject("component", "wheelsMapping.rocketunit.Test");
	}

	function _test_$cleantestcase_returns_expected_value() {
		loc.actual = loc.rocketUnit.$cleanTestCase("wheels.tests.rocketunit.foo.bar");
		loc.expected = "foo.bar";
		assert(loc.actual eq loc.expected);
	}
}
</cfscript>

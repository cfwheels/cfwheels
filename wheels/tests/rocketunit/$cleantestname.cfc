<cfscript>
component extends="wheelsMapping.Test" {

	// not testing case sensitivity

	function setup() {
		loc.rocketUnit = CreateObject("component", "wheelsMapping.rocketunit.Test");
    loc.expected = "Actual equals expected";
	}

	function test_$cleantestname_with_underscores_returns_expected_value() {
    loc.actual = loc.rocketUnit.$cleanTestName("test_actual_equals_expected");
		assert(loc.actual eq loc.expected);
	}


  function test_$cleantestname_with_hyphens_returns_expected_value() {
    loc.actual = loc.rocketUnit.$cleanTestName("test_actual-equals-expected");
		assert(loc.actual eq loc.expected);
	}

  function test_$cleantestname_with_camelcase_returns_expected_value() {
    loc.actual = loc.rocketUnit.$cleanTestName("test_actualEqualsExpected");
    assert(loc.actual eq loc.expected);
	}
}
</cfscript>

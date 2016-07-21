component extends="wheels.Test" {

	function setup() {
    loc.expected = "Actual equals expected";
	}

	// not testing case sensitivity

	function test_$cleantestname_with_underscores_returns_expected_value() {
    loc.actual = $cleanTestName("test_actual_equals_expected");
		assert("loc.actual eq loc.expected");
	}

  function test_$cleantestname_with_hyphens_returns_expected_value() {
    loc.actual = $cleanTestName("test_actual-equals-expected");
		assert("loc.actual eq loc.expected");
	}

  function test_$cleantestname_with_camelcase_returns_expected_value() {
    loc.actual = $cleanTestName("test_actualEqualsExpected");
    assert("loc.actual eq loc.expected");
	}
}
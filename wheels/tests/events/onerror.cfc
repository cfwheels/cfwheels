component extends="wheels.tests.Test" {

	// this test was originally for https://github.com/cfwheels/cfwheels/issues/1091 but as the expected path/s
	// are shown in the stack trace as well as the tagContext, its tricky to isolate without some html parsing.
	function test_onerror_cfmlerror_shows_wheels_templates() {
		try {
			Throw(type = "UnitTestError");
		} catch (any e) {
			exception = e;
		}

		actual = $includeAndReturnOutput($template = "wheels/events/onerror/cfmlerror.cfm", exception = exception);
		expected = "wheels/tests/events/onerror.cfc:7"; // line 7 is the throw() line in this test case.

		assert("actual contains expected");
	}

}

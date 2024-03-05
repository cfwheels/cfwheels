component extends="testbox.system.BaseSpec" {

	function run() {

		describe("Tests that onerror", () => {

			it("cfmlerror shows wheels templates", () => {
				try {
					Throw(type = "UnitTestError")
				} catch (any e) {
					exception = e
				}

				actual = application.wo.$includeAndReturnOutput($template = "/wheels/events/onerror/cfmlerror.cfm", exception = exception)
				// line 9 is the throw() line in this test case.
				if(application.wheels.servername eq "Adobe Coldfusion" and left(application.wheels.serverversion,4) eq "2018"){
					expected = "wheels\tests_testbox\specs\events\onerror.cfc:9" 
				}else{
					expected = "/wheels/tests_testbox/specs/events/onerror.cfc:9" 
				}

				expect(actual).toInclude(expected)
			})
		})
	}
}
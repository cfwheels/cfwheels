/**
 * My BDD Test
 */
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		// The following should NOT fail
		describe(
			"Thread Collisions",
			function(){
				it( "will NOT fail on the second spec due to identical spec name based thread name", function(){
				} );

				it( "will NOT fail on the second spec due to identical spec name based thread name", function(){
				} );
			},
			"async",
			true
		);
	}

}

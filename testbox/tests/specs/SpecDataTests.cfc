/**
 * Test Passing of spec data
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

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "Spec Data", function(){
			it(
				title = "can handle binding",
				body  = function( data ){
					expect( data.keep ).toBeTrue();
				},
				data = { keep : true }
			);
		} );
	}

}

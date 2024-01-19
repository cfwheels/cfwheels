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
		feature( "Given-When-Then test language support", function(){
			scenario( "I want to be able to write tests using Given-When-Then language", function(){
				given( "I am using TestBox", function(){
					when( "I run this test suite", function(){
						then( "it should be supported", function(){
							expect( true ).toBe( true );
						} );
					} );
				} );
			} );
		} );
	}

}

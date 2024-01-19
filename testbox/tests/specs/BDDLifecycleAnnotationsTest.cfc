/**
 * This tests the BDD functionality in TestBox.
 */
component extends="tests.utils.ExampleParentTestCase" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		variables.counter = 0;
		// After annotated class this should be 1
	}

	function afterAll(){
		structClear( variables );
	}

	/**
	 * @aroundEach
	 */
	function testAroundEach( spec, suite ){
		variables.counter++;
		arguments.spec.body();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "Lifecycle annotations", function(){
			it( "runs lifecycle annotation hooks just as if they were in the suite", function(){
				expect( variables.counter ).toBe( 4 );
			} );

			describe( "Lifecycle Annotation Hooks with normal Lifecycle Methods", function(){
				beforeEach( function(){
					variables.counter++;
				} );

				it( "runs both types of methods", function(){
					expect( variables.counter ).toBe( 8 );
				} );
			} );
		} );
	}

}

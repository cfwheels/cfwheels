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
		variables.counter = 0;
		describe( "Outer describe", function(){
			aroundEach( function( spec, suite ){
				counter++;
				spec.body();
			} );

			it( "the aroundEach should be executed as normal", function(){
				expect( counter ).toBe( 1 );
			} );

			describe( "Inner describe", function(){
				it( "the aroundEach from the parent context should be ran", function(){
					expect( counter ).toBe( 2 );
				} );
			} );
		} );

		describe( "Another describe with no aroundEach", function(){
			it( "can execute as normal", function(){
				expect( counter ).toBe( 2 );
			} );
			describe( "with yet another describe", function(){
				it( "can execute as normal", function(){
					expect( counter ).toBe( 2 );
				} );
			} );
		} );
	}

}

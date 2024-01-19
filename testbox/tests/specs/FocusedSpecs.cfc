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

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "My First Suite", function(){
			it( "A Spec that should not run", function(){
				fail( "implement" );
			} );

			it( "A Spec that should not run", function(){
				fail( "implement" );
			} );

			fit( "This should execute", function(){
				expect( 1 ).toBeTrue();
			} );

			it( "A Spec that should not run", function(){
				fail( "implement" );
			} );

			fit( "This should execute as well", function(){
				expect( 1 ).toBeTrue();
			} );

			fdescribe( "All specs here should run", function(){
				it( "should run", function(){
				} );
				it( "should run", function(){
				} );
				it( "should run", function(){
				} );
			} );

			describe( "All specs here should NOT run", function(){
				it( "A Spec that should not run", function(){
					fail( "implement" );
				} );

				it( "A Spec that should not run", function(){
					fail( "implement" );
				} );

				it( "A Spec that should not run", function(){
					fail( "implement" );
				} );
			} );
		} );

		fdescribe( "My Focused Suite", function(){
			it( "This should execute", function(){
				expect( 1 ).toBeTrue();
			} );

			describe( "All specs here should run", function(){
				it( "should run", function(){
				} );
				it( "should run", function(){
				} );
				it( "should run", function(){
				} );
			} );

			xdescribe( "skipped suites", function(){
				it( "A Spec that should not run", function(){
					fail( "implement" );
				} );

				it( "A Spec that should not run", function(){
					fail( "implement" );
				} );

				it( "A Spec that should not run", function(){
					fail( "implement" );
				} );
			} );
		} );
	}

}

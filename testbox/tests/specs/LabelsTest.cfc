/**
 * My BDD Test
 */
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.testsRan = 0;
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		if ( structKeyExists( url, "labels" ) && listContains( url.labels, "luis" ) ) {
			expect( testsRan ).toBe( 5 );
		} else if ( structKeyExists( url, "excludes" ) && listContains( url.excludes, "luis" ) ) {
			expect( testsRan ).toBe( 3 );
		} else {
			expect( testsRan ).toBe( 8 );
		}
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe(
			title  = "Suite with a label",
			labels = "luis",
			body   = function(){
				it( "should execute", function(){
					testsRan++;
				} );
				it( "should execute as well", function(){
					testsRan++;
				} );
				describe( "Nested Suite", function(){
					it( "should execute as well, as nested suite is inside a label suite", function(){
						testsRan++;
					} );

					describe( "Double Nested Suite", function(){
						it( "should execute this spec as well, because a parent suite has the correct label", function(){
							testsRan++;
						} );
					} );
				} );
			}
		);

		describe( "Suites with no labels", function(){
			it( "should not execute", function(){
				testsRan++;
			} );
			it( "should not execute", function(){
				testsRan++;
			} );
		} );

		describe( "Suite without a label but containing a spec with a label", function(){
			it(
				title  = "spec with a label",
				labels = "luis",
				body   = function(){
					testsRan++;
				}
			);
			it( "should not execute", function(){
				testsRan++;
			} );
		} );
	}

}

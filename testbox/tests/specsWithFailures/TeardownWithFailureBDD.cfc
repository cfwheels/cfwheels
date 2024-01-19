/**
* My BDD Test
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		// all your suites go here.

		describe( "A suite", function(){
			beforeEach(function( currentSpec ){
				writedump(var="beforeeach: #arguments.currentSpec#", output="console");
			});
			afterEach(function( currentSpec ){
				writedump(var="afterEach: #arguments.currentSpec#", output="console");
			});

			it("passes", function(){
				expect( 1 ).toBe( 1 );
			});

			it("fails", function(){
				expect( 1 ).toBe( 3 );
			});

		});
	}

}
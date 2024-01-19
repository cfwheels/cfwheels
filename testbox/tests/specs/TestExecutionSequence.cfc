component extends="testbox.system.BaseSpec" {

	function beforeAll(){
		debug( "1. in beforeAll()<br>" );
	}

	function afterAll(){
		debug( "8.in afterAll()<br>" );
	}


	function run(){
		describe( "outer describe", function(){
			aroundEach( function( spec, suite ){
				debug( "3.. top of outer aroundEach()<br>" );
				// execute the spec
				arguments.spec.body();
				debug( "6.. bottom of outer aroundEach()<br>" );
			} );


			describe( "inner describe", function(){
				beforeEach( function(){
					debug( "2... in inner describe()'s beforeEach()<br>" );
				} );

				afterEach( function(){
					debug( "7... in inner describe()'s afterEach()<br>" );
				} );

				it( "tests the negative", function(){
					debug( "4.... top of inner describe()'s first it()'s callback<br>" );
					expect( sgn( -1 ) ).toBeLT( 0 );
					debug( "5.... bottom of inner describe()'s first it()'s callback<br>" );
				} );
			} );
		} );
	}

}

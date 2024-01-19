component extends=testbox.system.BaseSpec {

	function run(){
		describe( "Tests of TestBox behaviour", function(){
			it( "rejects 5 as being between 1 and 10", function(){
				expect( function(){
					expect( 5 ).notToBeBetween( 1, 10 );
				} ).toThrow();
			} );

			it( "rejects 10 as being between 1 and 10", function(){
				expect( function(){
					expect( 10 ).notToBeBetween( 1, 10 );
				} ).toThrow();
			} );

			it( "rejects 15 as being between 1 and 10", function(){
				expect( 15 ).notToBeBetween( 1, 10 );
			} );

			it( "accepts 1 as being between 1 and 10", function(){
				expect( 1 ).toBeBetween( 1, 10 );
			} );

			it( "accepts 5 as being between 1 and 10", function(){
				expect( 5 ).toBeBetween( 1, 10 );
			} );

			it( "accepts 10 as being between 1 and 10", function(){
				expect( 10 ).toBeBetween( 1, 10 );
			} );
		} );
	}

}


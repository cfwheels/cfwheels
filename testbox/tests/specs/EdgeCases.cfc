component extends="testbox.system.BaseSpec" {

	function run(){
		describe( "Tests sparse array", function(){
			it( "works", function(){
				var expected  = [ "a" ];
				expected[ 3 ] = "c";
				var actual    = expected;
				expect( expected ).toBe( actual ); // this is line 10
			} );

			it( "can handle private UDFs", variables.myFakeClosure );
			it( "can handle public UDFs", variables.myFakePublicClosure );
		} );

		describe( "Ability to bind data to life-cycle methods", function(){
			var data = [ "spec1", "spec2" ];

			for ( var thisData in data ) {
				describe( "Trying #thisData#", function(){
					beforeEach(
						data = { myData : thisData },
						body = function( currentSpec, data ){
							targetData = arguments.data.myData;
						}
					);

					it(
						title = "should account for life-cycle data binding",
						data  = { myData : thisData },
						body  = function( data ){
							expect( targetData ).toBe( data.mydata );
						}
					);

					afterEach(
						data = { myData : thisData },
						body = function( currentSpec, data ){
							targetData = arguments.data.myData;
						}
					);
				} );
			}

			for ( var thisData in data ) {
				describe( "Trying around life-cycles with #thisData#", function(){
					aroundEach(
						data = { myData : thisData },
						body = function( spec, suite, data ){
							targetData = arguments.data.myData;
							arguments.spec.body( data = arguments.spec.data );
						}
					);

					it(
						title = "should account for life-cycle data binding",
						data  = { myData : thisData },
						body  = function( data ){
							expect( targetData ).toBe( data.mydata );
						}
					);
				} );
			}
		} );

		describe( "When testing a key does not exists", function(){
			var data = { name : "luis", awesome : true };
			it( "should pass when the key does not exist", function(){
				expect( data ).notToHaveKey( "age" );
			} );
			it( "should fail when the key does exist", function(){
				expect( function(){
					expect( data ).notToHaveKey( "name" );
				} ).toThrow( type = "TestBox.AssertionFailed" );
			} );
		} );
	}

	private function myFakeClosure(){
		expect( true ).toBeTrue();
	}

	private function myFakePublicClosure(){
		expect( true ).toBeTrue();
	}

}

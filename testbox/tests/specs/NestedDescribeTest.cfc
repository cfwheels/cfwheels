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
		describe( "Outer describe", function(){
			describe( "Inner describe", function(){
				it( "Tests are ONLY in inner it()", function(){
					expect( true ).toBe( true );
				} );
			} );


			story( "I want pricing details", function(){
				var sailingsData = [
					{
						name           : "AmaWaterways",
						Cruise_ID      : "749053",
						CrzCode        : "AM",
						API_Sail_ID    : "13732",
						API_Length     : 7,
						API_Port_Count : 7,
						API_Sail_Date  : "10/08/2019"
					},
					{
						name           : "Avalon",
						Cruise_ID      : "767012",
						CrzCode        : "AV",
						API_Sail_ID    : "WDB091010APS",
						API_Length     : 7,
						API_Port_Count : 9,
						API_Sail_Date  : "10/10/2019"
					},
					{
						name           : "Azamara",
						Cruise_ID      : "721541",
						CrzCode        : "AZ",
						API_Sail_ID    : "JR01191027JR07M398",
						API_Length     : 7,
						API_Port_Count : 7,
						API_Sail_Date  : "10/27/2019"
					},
					{
						name           : "Celebrity",
						Cruise_ID      : "708821",
						CrzCode        : "CB",
						API_Sail_ID    : "SL01190117SL14K095",
						API_Length     : 14,
						API_Port_Count : 9,
						API_Sail_Date  : "01/17/2019"
					}
				];

				arrayEach( sailingsData, function( item ){
					given( "[#item.name#] valid incoming arguments for a #item.name# sailing", function(){
						then(
							then = "[#item.name#] I get a response with inErrorStatus=false",
							data = item,
							body = function( data ){
								debug( "Starting to process #data.name#" );

								sleep( randRange( 500, 2000 ) );

								debug( "==> Finalized process #data.name#" );
							}
						);
					} );
				} );
			} );
		} );
	}

}

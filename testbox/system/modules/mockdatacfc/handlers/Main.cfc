/**
 * RESTFul service controller for MockData CFC
 */
component extends="coldbox.system.EventHandler" {

	// DI
	property name="mockData" inject="MockData@MockDataCFC";

	/**
	 * Index service
	 */
	any function index( event, rc, prc ){
		// mock the incoming RC without reserved words
		var results = mockData.mock(
			argumentCollection = rc.filter( function( item ){
				return !listFindNoCase( "event,namespaceRouting,namespace", item );
			} )
		);

		// CORS
		cfheader( name = "Access-Control-Allow-Origin", value = "*" );

		// Rendering
		event.renderData( type = "json", data = results );
	}

}

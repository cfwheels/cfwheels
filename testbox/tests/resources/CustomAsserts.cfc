component{

	function assertIsAwesome( expected, actual ){
		return ( expected eq actual ? true : fail( 'actual is not awesome' ) );
	}

	function assertIsFunky( actual ){
		return ( actual gte 100 ? true : fail('Actual is not funky!') );
	}

}
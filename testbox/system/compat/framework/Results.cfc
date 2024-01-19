/**
 * Copyright Since 2005 TestBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * A compat class for MXUnit Directory Test Suite
 */
component {

	/**
	 * Constructor
	 *
	 * @bundles  
	 * @testSpecs
	 */
	function init( required bundles, testSpecs = "" ){
		for ( var thisArg in arguments ) {
			variables[ thisArg ] = arguments[ thisArg ];
		}

		return this;
	}

	/**
	 * Get the results output in a specific mode
	 *
	 * @mode The mode of the output
	 */
	any function getResultsOutput( mode = "simple" ){
		switch ( arguments.mode ) {
			case "junitxml": {
				arguments.mode = "junit";
				break;
			}
			case "query":
			case "array": {
				arguments.mode = "raw";
				break;
			}
			case "html":
			case "rawhtml": {
				arguments.mode = "simple";
				break;
			}
			default: {
				arguments.mode = "simple";
			}
		}

		var tb = new testbox.system.TestBox( bundles = variables.bundles );

		return tb.run( testSpecs = variables.testSpecs, reporter = arguments.mode );
	}

}

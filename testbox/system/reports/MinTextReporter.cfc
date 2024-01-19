/**
 * Copyright Since 2005 TestBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * A minimalistic reporter
 */
component extends="TextReporter" {

	/**
	 * Get the name of the reporter
	 */
	function getName(){
		return "MinText";
	}

	/**
	 * Do the reporting thing here using the incoming test results
	 * The report should return back in whatever format they desire and should set any
	 * Specific browser types if needed.
	 *
	 * @results    The instance of the TestBox TestResult object to build a report on
	 * @testbox    The TestBox core object
	 * @options    A structure of options this reporter needs to build the report with
	 * @justReturn Boolean flag that if set just returns the content with no content type and buffer reset
	 */
	any function runReport(
		required testbox.system.TestResult results,
		required testbox.system.TestBox testbox,
		struct options     = {},
		boolean justReturn = false
	){
		if ( !arguments.justReturn ) {
			// content type
			getPageContextResponse().setContentType( "text/plain" );
		}
		// bundle stats
		variables.bundleStats= arguments.results.getBundleStats();
		// prepare the report
		savecontent variable ="local.report" {
			include "assets/mintext.cfm";
		}
		return reReplace(
			trim( local.report ),
			"[\r\n]+",
			chr( 10 ),
			"all"
		);
	}

}

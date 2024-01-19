/**
 * Copyright Since 2005 TestBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * An XML reporter
 */
component extends="BaseReporter" {

	/**
	 * Constructor
	 */
	function init(){
		variables.converter = new testbox.system.util.XMLConverter();
		return this;
	}

	/**
	 * Get the name of the reporter
	 */
	function getName(){
		return "XML";
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
			resetHTMLResponse();
			getPageContextResponse().setContentType( "application/xml" );
		}
		return variables.converter.toXML( data = arguments.results.getMemento(), rootName = "TestBox" );
	}

}

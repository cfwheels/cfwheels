/**
 * Copyright Since 2005 TestBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * A JUnit reporter
 */
component extends="BaseReporter" {

	/**
	 * Get the name of the reporter
	 */
	function getName(){
		return "JUnit";
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

		return toJUnit( arguments.results );
	}

	private function toJUnit( required results ){
		var buffer = createObject( "java", "java.lang.StringBuilder" ).init(
			"<?xml version=""1.0"" encoding=""UTF-8""?>"
		);
		var r = arguments.results;

		// build top level test suites container
		// cfformat-ignore-start
		buffer.append(
			"<testsuites
			name=""ColdBox.TestBox.TestResults""
			time=""#r.getTotalDuration() / 1000#""
			tests=""#r.getTotalSpecs()#""
			failures=""#r.getTotalFail()#""
			disabled=""#r.getTotalSkipped()#""
			errors=""#r.getTotalError()#""
			labels=""#arrayToList( r.getLabels() )#""
			>"
		);
		// cfformat-ignore-end

		// iterate over bundles
		var bundlestats = r.getBundleStats();
		for ( var thisBundle in bundleStats ) {
			buildTestSuites( buffer, r, thisBundle, thisBundle.suiteStats );
		}

		buffer.append( "</testsuites>" );

		return buffer.toString();
	}

	private function buildTestSuites(
		required buffer,
		required results,
		required bundleStats,
		required suiteStats,
		parentName = ""
	){
		var r     = arguments.results;
		var out   = arguments.buffer;
		var stats = arguments.suiteStats;

		// iterate over
		for ( var thisSuite in arguments.suiteStats ) {
			// build out full suite name
			var fullName = encodeForXMLAttribute( arguments.parentName & thisSuite.name );

			// build test suite header
			// cfformat-ignore-start
			out.append(
				"<testsuite
				name=""#fullName#""
				tests=""#thisSuite.totalSpecs#""
				failures=""#thisSuite.totalFail#""
				errors=""#thisSuite.totalError#""
				time=""#thisSuite.totalDuration / 1000#""
				skipped=""#thisSuite.totalSkipped#""
				timestamp=""#dateFormat( now(), "mm/dd/yy" )# #timeFormat( now(), "medium" )#""
				hostname=""#encodeForXMLAttribute( cgi.remote_host )#""
				package=""#encodeForXMLAttribute( arguments.bundleStats.path )#""
				>"
			);
			// cfformat-ignore-end

			// Note: Too verbose, reconsider for future iterations on how to make this useful.
			// build out properties
			// buildProperties( out, r, thisSuite, arguments.bundleStats );

			// build out test cases
			for ( var thisSpecStat in thisSuite.specStats ) {
				buildTestCase( out, r, thisSpecStat, arguments.bundleStats );
			}
			// close header
			out.append( "</testsuite>" );

			// Check embedded suites
			if ( arrayLen( thisSuite.suiteStats ) ) {
				buildTestSuites(
					out,
					r,
					arguments.bundlestats,
					thisSuite.suiteStats,
					encodeForXMLAttribute( fullName & "##" )
				);
			}
		}
	}

	private function buildTestCase(
		required buffer,
		required results,
		required specStats,
		required bundleStats
	){
		var r     = arguments.results;
		var out   = arguments.buffer;
		var stats = arguments.specStats;

		// build test case
		// cfformat-ignore-start
		out.append(
			"<testcase
			name=""#encodeForXMLAttribute( stats.name )#""
			time=""#stats.totalDuration / 1000#""
			classname=""#arguments.bundleStats.path#""
			status=""#stats.status#""
			>"
		);

		switch ( stats.status ) {
			case "failed": {
				out.append(
					"<failure message=""#encodeForXMLAttribute( stats.failMessage )#""><![CDATA[
					#stats.failorigin.toString()#
					]]></failure>"
				);
				break;
			}
			case "skipped": {
				out.append( "<skipped></skipped>" );
				break;
			}
			case "error": {
				out.append(
					"<error type=""#encodeForXMLAttribute( stats.error.type )#"" message=""#encodeForXMLAttribute( stats.error.message )#""><![CDATA[
					#stats.error.stackTrace.toString()#
					]]></error>"
				);
				break;
			}
		}
		// cfformat-ignore-end

		out.append( "</testcase>" );
	}

	private function buildProperties(
		required buffer,
		required results,
		required bundleStats,
		required suiteStats
	){
		var r     = arguments.results;
		var out   = arguments.buffer;
		var stats = arguments.suiteStats;

		out.append( "<properties>" );

		genPropsFromCollection( out, cgi );

		out.append( "</properties>" );
	}

	private function genPropsFromCollection( required buffer, required collection ){
		for ( var thisProp in arguments.collection ) {
			// null check
			if ( isNull( arguments.collection[ thisProp ] ) ) {
				continue;
			}
			if ( isSimpleValue( arguments.collection[ thisProp ] ) ) {
				arguments.buffer.append(
					"<property name=""#encodeForXMLAttribute( lCase( thisProp ) )#"" value=""#encodeForXMLAttribute( arguments.collection[ thisProp ] )#"" />"
				);
			} else if (
				isArray( arguments.collection[ thisProp ] ) OR
				isStruct( arguments.collection[ thisProp ] ) OR
				isQuery( arguments.collection[ thisProp ] )
			) {
				arguments.buffer.append(
					"<property name=""#encodeForXMLAttribute( lCase( thisProp ) )#"" value=""#encodeForXMLAttribute( arguments.collection[ thisProp ].toString() )#"" />"
				);
			}
		}
	}

}

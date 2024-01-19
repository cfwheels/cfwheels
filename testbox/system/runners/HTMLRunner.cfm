<cfsetting showDebugOutput="false">
<cfsetting requesttimeout="99999999">
<!--- Executes all tests in the 'specs' folder with simple reporter by default --->
<cfparam name="url.reporter" 						default="simple">
<cfparam name="url.directory" 						default="">
<cfparam name="url.recurse" 						default="true" type="boolean">
<cfparam name="url.bundles" 						default="">
<cfparam name="url.labels" 							default="">
<cfparam name="url.excludes" 						default="">
<cfparam name="url.reportpath" 						default="">
<cfparam name="url.propertiesFilename"			 	default="TEST.properties">
<cfparam name="url.propertiesSummary"			 	default="false" type="boolean">

<cfparam name="url.coverageEnabled"					default="false" type="boolean">
<cfparam name="url.coverageSonarQubeXMLOutputPath"	default="">
<cfparam name="url.coverageBrowserOutputDir"		default="">
<cfparam name="url.coveragePathToCapture"			default="">
<cfparam name="url.coverageWhitelist"				default="">
<cfparam name="url.coverageBlacklist"				default="/testbox">
<!--- Enable batched code coverage reporter, useful for large test bundles which require spreading over multiple testbox run commands. --->
<cfparam name="url.isBatched"						default="false">

<cfscript>
// prepare for tests for bundles or directories
testbox = new testbox.system.TestBox(
	labels   = url.labels,
	excludes = url.excludes,
	options  =  {
		coverage : {
			enabled       	: url.coverageEnabled,
			pathToCapture 	: url.coveragePathToCapture,
			whitelist     	: url.coverageWhitelist,
			blacklist     	: url.coverageBlacklist,
			isBatched		: url.isBatched,
			sonarQube     	: {
				XMLOutputPath : url.coverageSonarQubeXMLOutputPath
			},
			browser			: {
				outputDir : url.coverageBrowserOutputDir
			}
		}
	}
);
if( len( url.bundles ) ){
	testbox.addBundles( url.bundles );
}
if( len( url.directory ) ){
	for( dir in listToArray( url.directory ) ){
		testbox.addDirectories( dir, url.recurse );
	}
}

// Run Tests using correct reporter
results = testbox.run( reporter=url.reporter );

function escapePropertyValue( required string value ) {
	if ( len( arguments.value ) == 0 ) {
		return arguments.value;
	}
	local.value = replaceNoCase( arguments.value, '\', '\\', 'all' );
	value = replaceNoCase( value, chr(13), '\r', 'all' );
	value = replaceNoCase( value, chr(10), '\n', 'all' );
	value = replaceNoCase( value, chr(9), '\t', 'all' );
	value = replaceNoCase( value, chr(60), '\u003c', 'all' );
	value = replaceNoCase( value, chr(62), '\u003e', 'all' );
	value = replaceNoCase( value, chr(47), '\u002f', 'all' );
	return replaceNoCase( value, chr(32), '\u0020', 'all' );
}

// Write TEST.properties in report destination path.
if( url.propertiesSummary ){
	testResult = testbox.getResult();
	errors = testResult.getTotalFail() + testResult.getTotalError();
	savecontent variable="propertiesReport"{
writeOutput( ( errors ? "test.failed=true" : "test.passed=true" ) & chr( 10 ) );
writeOutput( "test.labels=#escapePropertyValue( arrayToList( testResult.getLabels() ) )#
test.bundles=#escapePropertyValue( URL.bundles )#
test.directory=#escapePropertyValue( url.directory )#
total.bundles=#escapePropertyValue( testResult.getTotalBundles() )#
total.suites=#escapePropertyValue( testResult.getTotalSuites() )#
total.specs=#escapePropertyValue( testResult.getTotalSpecs() )#
total.pass=#escapePropertyValue( testResult.getTotalPass() )#
total.fail=#escapePropertyValue( testResult.getTotalFail() )#
total.error=#escapePropertyValue( testResult.getTotalError() )#
total.skipped=#escapePropertyValue( testResult.getTotalSkipped() )#" );
	}

	//ACF Compatibility - check for and expand to absolute path
	if( !directoryExists( url.reportpath ) ) url.reportpath = expandPath( url.reportpath );

	if( !trim( lcase( url.propertiesfilename ) ).endsWith( '.properties' ) ) {
		url.propertiesfilename &= '.properties';
	}
	fileWrite( url.reportpath & "/" & url.propertiesfilename, propertiesReport );
}

// do stupid JUnitReport task processing, if the report is ANTJunit
if( url.reporter eq "ANTJunit" ){
	// Produce individual test files due to how ANT JUnit report parses these.
	xmlReport = xmlParse( results );
	for( thisSuite in xmlReport.testsuites.XMLChildren ){
		fileWrite( url.reportpath & "/TEST-" & thisSuite.XMLAttributes.package & ".xml", toString( thisSuite ) );
	}
}

// Writeout Results
writeoutput( results );
</cfscript>

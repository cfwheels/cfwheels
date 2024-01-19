/**
 * ********************************************************************************
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 * I collect code coverage data for a directory of files and generate
 * a query of data that can be consumed by different reporting interfaces.
 */
component accessors=true {

	/**
	 * Constructor
	 */
	function init(){
		variables.CR   = chr( 13 );
		variables.LF   = chr( 10 );
		variables.CRLF = CR & LF;

		return this;
	}

	/**
	 * Configure the main data collection class.
	 *
	 * @return true if enabled, false if disabled
	 */
	boolean function configure(){
		try {
			variables.fragentClass = createObject( "java", "com.intergral.fusionreactor.agent.Agent" );
			// Do a quick test to ensure the line performance instrumentation is loaded.  This will return null for non-supported versions of FR
			var instrumentation    = fragentClass.getAgentInstrumentation().get( "cflpi" );
		} catch ( Any e ) {
			return false;
		}

		if ( isNull( instrumentation ) ) {
			return false;
		}

		// for file globbing
		variables.pathPatternMatcher = new testbox.system.modules.globber.models.PathPatternMatcher();

		// Detect server
		if ( listFindNoCase( "Railo,Lucee", server.coldfusion.productname ) ) {
			variables.templateCompiler = new TemplateCompiler_Lucee();
		} else {
			variables.templateCompiler = new TemplateCompiler_Adobe();
		}

		return true;
	}

	/**
	 * Reset system for a new test.  Turns on line coverage and resets in-memory statistics
	 */
	CoverageGenerator function beginCapture(){
		// Turn on line profiling
		fragentClass
			.getAgentInstrumentation()
			.get( "cflpi" )
			.setActive( true );
		// Clear any data in memory
		fragentClass
			.getAgentInstrumentation()
			.get( "cflpi" )
			.reset();

		return this;
	}

	/**
	 * End the capture of data.  Clears up memory and optionally turns off line profiling
	 *
	 * @leaveLineProfilingOn Set to true to leave line profiling enabled on the server
	 */
	CoverageGenerator function endCapture( leaveLineProfilingOn = false ){
		// Turn off line profiling
		if ( !leaveLineProfilingOn ) {
			fragentClass
				.getAgentInstrumentation()
				.get( "cflpi" )
				.setActive( false );
		}
		// Clear any data in memory
		fragentClass
			.getAgentInstrumentation()
			.get( "cflpi" )
			.reset();

		return this;
	}

	/**
	 *
	 * @pathToCapture The full path to a folder of code.  Searched recursively
	 * @whitelist     Comma-delimited list or array of file paths to include
	 * @blacklist     Comma-delimited list or array of file paths to exclude
	 *
	 * @return query of data
	 */
	query function generateData(
		required string pathToCapture,
		any whitelist = "",
		any blacklist = ""
	){
		// Convert lists to an array.
		if ( isSimpleValue( arguments.whitelist ) ) {
			arguments.whitelist = arguments.whitelist.listToArray();
		}
		if ( isSimpleValue( arguments.blacklist ) ) {
			arguments.blacklist = arguments.blacklist.listToArray();
		}

		// Get a recursive list of all CFM and CFC files in  project root.
		var fileList = directoryList( arguments.pathToCapture, true, "path", "*.cf?" );

		// start data structure
		var qryData = queryNew(
			"filePath,relativeFilePath,filePathHash,numLines,numCoveredLines,numExecutableLines,percCoverage,lineData",
			"varchar,varchar,varchar,integer,integer,integer,decimal,object"
		);

		for ( var theFile in fileList ) {
			theFile = theFile.replace( "\", "/", "all" );

			var relativeFilePath = replaceNoCase( theFile, arguments.pathToCapture, "" );

			// Skip this file if it doesn't match our patterns
			// Pass a path relative to our root folder
			if (
				!isPathAllowed(
					relativeFilePath,
					arguments.whitelist,
					arguments.blacklist
				)
			) {
				continue;
			}

			var fileContents = fileRead( theFile );
			// Replace Windows CRLF with CR
			fileContents     = replaceNoCase( fileContents, CRLF, CR, "all" );
			// Replace lone LF with CR
			fileContents     = replaceNoCase( fileContents, LF, CR, "all" );
			// Break on CR, keeping empty lines
			var fileLines    = fileContents.listToArray( CR, true );

			// new file: theFile
			var strFiledata = {
				filePath           : theFile,
				relativeFilePath   : relativeFilePath,
				numLines           : arrayLen( fileLines ),
				numCoveredLines    : 0,
				numExecutableLines : 0,
				percCoverage       : 0,
				filePathHash       : hash( theFile )
			};
			// Add this to query later
			var lineData = createObject( "java", "java.util.LinkedHashMap" ).init();

			var jFile         = createObject( "java", "java.io.File" ).init( theFile );
			var lineMetricMap = fragentClass
				.getAgentInstrumentation()
				.get( "cflpi" )
				.getLineMetrics( jFile.getCanonicalPath() );
			if ( isNull( lineMetricMap ) ) {
				lineMetricMap = {};
			}
			var noDataForFile = false;
			// If we don't have any metrics for this file, and we're on Railo or Lucee, attempt to force the file to load.
			if ( !structCount( lineMetricMap ) ) {
				// Force the engine to compile and load the file even though it was never run.
				templateCompiler.compileAndLoad( theFile );
				// Check for metrics again
				lineMetricMap = fragentClass
					.getAgentInstrumentation()
					.get( "cflpi" )
					.getLineMetrics( theFile );

				if ( isNull( lineMetricMap ) ) {
					lineMetricMap     = structNew();
					var noDataForFile = true;
				}
			}
			var currentLineNum  = 0;
			var previousLineRan = 0;

			for ( var line in fileLines ) {
				currentLineNum++;
				if ( structCount( lineMetricMap ) && lineMetricMap.containsKey( javacast( "int", currentLineNum ) ) ) {
					var lineMetric = lineMetricMap.get( javacast( "int", currentLineNum ) );
					var covered    = lineMetric.getCount();

					// Overrides for buggyiness ************************************************************************


					// On Adobe, the first line of CFCs seems to always report as being executable but not running whether it's a comment or a component declaration
					if (
						theFile.right( 4 ) == ".cfc" && currentLineNum == 1 && !covered && line.startsWith(
							"/" & "*"
						)
					) {
						continue;
					}

					// On Adobe, the first line of CFCs seems to always report as being executable but not running whether it's a comment or a component declaration
					if (
						theFile.right( 4 ) == ".cfc" && currentLineNum == 1 && !covered && line.startsWith(
							"component"
						)
					) {
						covered = 1;
					}

					// Ignore any tag based comments.  Some are reporting as covered, others aren't.  They really all should be ignored.
					if ( reFindNoCase( "^<!---.*--->$", trim( line ) ) ) {
						continue;
					}

					// Ignore any CFscript tags.  They don't consistently report and they aren't really executable in themselves
					if ( reFindNoCase( "<(\/)?cfscript>", trim( line ) ) ) {
						continue;
					}

					// Count as covered any closing CF tags where the previous line ran.  Ending tags don't always seem to get picked up.
					if ( !covered && previousLineRan && reFindNoCase( "<\/cf.*>", trim( line ) ) ) {
						covered = previousLineRan;
					}

					// Count as covered any closing script braces where the previous line ran.  E.x, I've seen trailing } in a switch statement not picked up
					if ( !covered && previousLineRan && trim( line ) == "}" ) {
						covered = previousLineRan;
					}

					// Count as covered any closing parenthesis where the previous line ran.
					if ( !covered && previousLineRan && ( trim( line ) == ");" || trim( line ) == ")" ) ) {
						covered = previousLineRan;
					}

					// Count as covered any cffunction or cfargument tag where the previous line ran.
					if ( !covered && reFindNoCase( "^<cf(function|argument)", trim( line ) ) && previousLineRan ) {
						covered = previousLineRan;
					}

					// Overrides for bugginess ************************************************************************

					lineData[ currentLineNum ] = covered;

					strFiledata.numExecutableLines++;
					if ( covered ) {
						strFiledata.numCoveredLines++;
					}
					var previousLineRan = covered;
				} else if ( noDataForFile ) {
					// As a hack, if there is no data for this file, just count every line against us.
					strFiledata.numExecutableLines++;
				}
			}

			if ( strFiledata.numExecutableLines ) {
				strFiledata.percCoverage = strFiledata.numCoveredLines / strFiledata.numExecutableLines;
			} else {
				// If there's no executable lines in the file, show it as 100% even though we can't divide by zero
				strFiledata.percCoverage = 1;
			}
			queryAddRow( qryData, strFiledata );
			qryData[ "lineData" ][ qryData.recordCount ] = lineData;
		}

		// Return the data
		return qryData;
	}

	/**
	 * Determines if a path is valid given the whitelist and black list.  White and black lists
	 * use standard file globbing patterns.
	 *
	 * @path      The relative path to check.
	 * @whitelist paths to allow
	 * @blacklist paths to exclude
	 */
	function isPathAllowed(
		required string path,
		required array whitelist,
		required array blacklist
	){
		// Check whitelist
		if (
			arrayLen( arguments.whitelist ) && !pathPatternMatcher.matchPatterns(
				arguments.whitelist,
				arguments.path
			)
		) {
			return false;
		}
		// Check blacklist
		if (
			arrayLen( arguments.blacklist ) && pathPatternMatcher.matchPatterns(
				arguments.blacklist,
				arguments.path
			)
		) {
			return false;
		}

		// We passed all the checks
		return true;
	}

}

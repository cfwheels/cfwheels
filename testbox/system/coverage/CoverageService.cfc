/**
 * ********************************************************************************
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 *
 * I handle capturing line coverage data. I can accept the following options:
 *
 * enabled - Boolean to turn coverage on or off
 * sonarQube.XMLOutputPath Absolute XML file path to write XML sunarQube file
 * browser.outputDir Absolute directory path to create html code coverage browser
 * pathToCapture Absolute path to root folder to capture coverage. Typically your web root
 * whitelist A comma-delimited list of file globbing paths relative to your pathToCapture of the ONLY files to match.  When emtpy, everything is matched by default
 * blacklist A comma-delimited list of file globbing paths relative to your pathToCapture of files to ignore
 *
 */
component accessors="true" {

	/**
	 * Coverage Enabled or not
	 */
	property name="coverageEnabled" type="boolean";

	/**
	 * Struct of coverage options
	 */
	property name="coverageOptions" type="struct";

	/**
	 * The CoverageGenerator object reference
	 */
	property name="coverageGenerator" type="any";

	/**
	 * Bootstrap the Code Coverage service and decide if we'll be enabled or not
	 *
	 * @coverageOptions struct of options to initialize with
	 */
	function init( coverageOptions = {} ){
		// Default options
		variables.coverageOptions = setDefaultOptions( arguments.coverageOptions );
		variables.coverageEnabled = variables.coverageOptions.enabled;

		// If disabled in config, go no further
		if ( getCoverageEnabled() ) {
			variables.coverageGenerator = loadCoverageGenerator();
			variables.coverageEnabled   = coverageGenerator.configure();
			variables.coverageReporter  = loadCoverageReporter();
		}

		return this;
	}

	/**
	 * Reset system for a new test.  Turns on line coverage and resets in-memory statistics
	 */
	CoverageService function beginCapture(){
		if ( getCoverageEnabled() ) {
			coverageGenerator.beginCapture();
		}

		return this;
	}

	/**
	 * End the capture of data.  Clears up memory and optionally turns off line profiling
	 *
	 * @leaveLineProfilingOn Set to true to leave line profiling enabled on the server
	 */
	CoverageService function endCapture( leaveLineProfilingOn = false ){
		if ( getCoverageEnabled() ) {
			coverageGenerator.endCapture( leaveLineProfilingOn );
		}

		return this;
	}

	/**
	 * Process Code Coverage if enabled and set results inside the TestResult object
	 *
	 * @results.hint The instance of the TestBox TestResult object to build a report on
	 * @testbox.hint The TestBox core object
	 */
	CoverageService function processCoverage(
		required testbox.system.TestResult results,
		required testbox.system.TestBox testbox
	){
		if ( getCoverageEnabled() ) {
			// Prepare coverage data
			var qryCoverageData = generateCoverageData( getCoverageOptions() );

			// SonarQube Integration
			var sonarQubeResults = processSonarQube( qryCoverageData, getCoverageOptions() );

			if ( getCoverageOptions().isBatched ) {
				qryCoverageData = variables.coverageReporter.processCoverageReport( qryCoverageData );
			}

			// Generate Stats
			var stats = processStats( qryCoverageData );

			// Generate code browser
			var browserResults = processCodeBrowser( qryCoverageData, stats, getCoverageOptions() );

			results.setCoverageEnabled( true );
			results.setCoverageData( {
				"qryData"          : qryCoverageData,
				"stats"            : stats,
				"sonarQubeResults" : sonarQubeResults,
				"browserResults"   : browserResults
			} );
		}

		return this;
	}

	/**
	 * Render HTML representation of statistics
	 */
	function renderStats( required struct coverageData, boolean fullPage = true ){
		var stats         = coverageData.stats;
		var pathToCapture = getCoverageOptions().pathToCapture;

		var codeBrowser = new browser.CodeBrowser( getCoverageOptions().coverageTresholds );

		savecontent variable="local.statsHTML" {
			include "/testbox/system/coverage/stats/coverageStats.cfm";
		}

		return local.statsHTML;
	}

	/**
	 * Default user option struct and do some validation
	 *
	 * @opts The options to default and check
	 */
	private function setDefaultOptions( struct opts = {} ){
		if ( isNull( opts.enabled ) ) {
			opts.enabled = true;
		}

		if ( isNull( opts.sonarQube ) ) {
			opts.sonarQube = {};
		}
		if ( isNull( opts.sonarQube.XMLOutputPath ) ) {
			opts.sonarQube.XMLOutputPath = "";
		}

		if ( isNull( opts.browser ) ) {
			opts.browser = {};
		}
		if ( isNull( opts.browser.outputDir ) ) {
			opts.browser.outputDir = "";
		}

		// Clean up the browser output dir if it is set
		if ( len( opts.browser.outputDir ) ) {
			// Expand the output dir if it looks like it needs it
			if (
				!directoryExists( opts.browser.outputDir ) && directoryExists(
					expandPath( opts.browser.outputDir )
				)
			) {
				opts.browser.outputDir = expandPath( opts.browser.outputDir );
			}

			opts.browser.outputDir = normalizeSlashes( opts.browser.outputDir );

			if ( !opts.browser.outputDir.endsWith( "/" ) ) {
				opts.browser.outputDir = opts.browser.outputDir & "/";
			}
		}

		if ( isNull( opts.coverageTresholds ) ) {
			opts.coverageTresholds = {};
		}
		if ( isNull( opts.coverageTresholds.good ) ) {
			opts.coverageTresholds.good = 85;
		}
		if ( isNull( opts.coverageTresholds.bad ) ) {
			opts.coverageTresholds.bad = 50;
		}

		if ( isNull( opts.pathToCapture ) ) {
			opts.pathToCapture = "";
		}
		if ( isNull( opts.whitelist ) ) {
			opts.whitelist = "";
		}
		if ( isNull( opts.blacklist ) ) {
			opts.blacklist = "";
		}
		if ( isNull( opts.isBatched ) ) {
			opts.isBatched = false;
		}

		// If no path provided to capture
		if ( !len( opts.pathToCapture ) ) {
			// Look for a /root mapping which is a common ColdBox convention
			if ( !isNull( getApplicationMetadata().mappings ) ) {
				var mappings = getApplicationMetadata().mappings;
			} else {
				var mappings = {};
			}
			if ( mappings.keyExists( "/root" ) ) {
				opts.pathToCapture = expandPath( "/root" );
				// And default to entire web root
			} else {
				opts.pathToCapture = expandPath( "/" );
			}
		} else if ( !directoryExists( opts.pathToCapture ) && directoryExists( expandPath( opts.pathToCapture ) ) ) {
			opts.pathToCapture = expandPath( opts.pathToCapture );
		}

		opts.pathToCapture = normalizeSlashes( opts.pathToCapture );

		if ( !opts.pathToCapture.endsWith( "/" ) ) {
			opts.pathToCapture = opts.pathToCapture & "/";
		}

		// Bypass validation if not enabled
		if ( !opts.enabled ) {
			return opts;
		}

		if ( !directoryExists( opts.pathToCapture ) ) {
			throw(
				message = "Coverage option [pathToCapture] does not point to a real and absolute directory path.",
				detail  = opts.pathToCapture
			);
		}

		return opts;
	}

	/**
	 * Interface with FusionReactor to build coverage data
	 */
	private function generateCoverageData( required struct opts ){
		return coverageGenerator.generateData(
			opts.pathToCapture,
			opts.whitelist,
			opts.blacklist
		);
	}

	/**
	 * Write out SonarQube generic coverage XML file
	 */
	private function processSonarQube( required query qryCoverageData, required struct opts ){
		if ( len( opts.sonarQube.XMLOutputPath ) ) {
			// Create XML generator
			var sonarQube = new sonarqube.SonarQube();
			// Prettify output
			sonarQube.setFormatXML( true );

			// Generate XML (writes file and returns string
			sonarQube.generateXML( qryCoverageData, opts.sonarQube.XMLOutputPath );
			return opts.sonarQube.XMLOutputPath;
		}
		return "";
	}


	/**
	 * Generate statistics from the coverage data
	 */
	private function processStats( required query qryCoverageData ){
		var coverageStats = new stats.CoverageStats();
		return coverageStats.generateStats( qryCoverageData );
	}

	/**
	 * Generate code browser
	 */
	private function processCodeBrowser( qryCoverageData, stats, opts ){
		// Only generate browser if there's a generation path specified
		if ( len( opts.browser.outputDir ) ) {
			var codeBrowser = new browser.CodeBrowser( opts.coverageTresholds );
			codeBrowser.generateBrowser( qryCoverageData, stats, opts.browser.outputDir );
			return opts.browser.outputDir;
		}
		return "";
	}

	/*
	 * Turns all slashes in a path to forward slashes except for \\ in a Windows UNC network share
	 * Also changes double slashes to a single slash
	 */
	function normalizeSlashes( string path ){
		if ( path.left( 2 ) == "\\" ) {
			path = "\\" & path.replace( "\", "/", "all" ).right( len( path ) - 2 );
			return path.replace( "//", "/", "all" );
		} else {
			return path.replace( "\", "/", "all" ).replace( "//", "/", "all" );
		}
	}


	/**
	 * Acquire a CoverageGenerator component which does the hard work.
	 */
	private component function loadCoverageGenerator(){
		return new data.CoverageGenerator();
	}

	/**
	 * Acquire a CoverageGenerator component which does the hard work.
	 */
	private component function loadCoverageReporter(){
		return new CoverageReporter( { outputDir : getCoverageOptions().browser.outputDir } );
	}

}

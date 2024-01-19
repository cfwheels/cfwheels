/**
 * ********************************************************************************
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 * I turn a query of coverage data into stats
 */
component accessors="true" {

	/**
	 * Specify a struct of options for the code coverage report.
	 * Most importantly, the outputDir where we can find the .json report file.
	 */
	property name="reportOptions" type="struct";

	/**
	 * Full path to the .json report file.
	 */
	property name="CoverageReportFile" type="string";

	public component function init( struct reportOptions = {} ){
		setReportOptions( setDefaultOptions( arguments.reportOptions ) );
		setCoverageReportFile( getReportOptions().outputDir & "coverageReport.json" );
		return this;
	}

	/**
	 * Set up the coverage report - wipes any old coverage report.json file.
	 *
	 * You'll want to run this from a testbox "Batch Runner" -
	 * i.e. a testbox runner which fires _separate requests_ to execute all Testbox specs sequentially.
	 *
	 * This helps avoid out-of-memory errors with especially large code bases and/or test bundles.
	 */
	public function beginCoverageReport(){
		/**
		 * Ensure the coverage report is wiped clean.
		 */
		if ( fileExists( getCoverageReportFile() ) ) {
			fileDelete( getCoverageReportFile() );
		}
	}

	/**
	 * Finish collecting coverage stats.
	 */
	public function endCoverageReport(){
		/**
		 * Currently does nothing...
		 */
	}

	/**
	 * Begin processing coverage data IF batching enabled.
	 *
	 * @coverageQuery The result from CoverageGenerator's generateData() method.
	 *
	 * @return an aggregated, FULL report of all test coverage data accumulated to this point.
	 */
	public any function processCoverageReport( required any coverageQuery ){
		return !getReportOptions().isBatched
		 ? arguments.coverageQuery
		 : aggregateCoverageData( arguments.coverageQuery );
	}

	/**
	 * TESTBOX multi-step coverage report.
	 *
	 * Each test run coverage report is saved to a JSON file at conclusion.
	 * That JSON file is merged into the existing
	 *
	 * @coverageQuery The result from CoverageGenerator's generateData() method.
	 *
	 * @return an aggregated, FULL report of all test coverage data accumulated to this point.
	 */
	private function aggregateCoverageData( required any coverageQuery ){
		var totalCoverage = queryNew(
			"filePath,relativeFilePath,filePathHash,numLines,numCoveredLines,numExecutableLines,percCoverage,lineData",
			"varchar,varchar,varchar,integer,integer,integer,decimal,object"
		);
		if ( fileExists( getCoverageReportFile() ) ) {
			var currentCoverage  = arguments.coverageQuery;
			var previousCoverage = readCoverageFromReportFile();

			currentCoverage.each( function( row ){
				var filepath    = row[ "relativeFilePath" ];
				var oldRowIndex = getRowIndexWithFile( previousCoverage, filepath );
				if ( oldRowIndex > 0 ) {
					var amended           = queryGetRow( previousCoverage, oldRowIndex );
					// UPDATE LINE DATA
					amended[ "lineData" ] = amended[ "lineData" ].map( function( line, lineCoveredValue ){
						// if it's covered in the latest coverage check, use that value. Otherwise use value from file.
						if ( structKeyExists( row[ "lineData" ], line ) && row[ "lineData" ][ line ] > 0 ) {
							return row[ "lineData" ][ line ];
						}
						return lineCoveredValue;
					} );
					// SUM
					amended[ "numCoveredLines" ] = amended[ "lineData" ].reduce( function( coveredCount, line, covered ){
						if ( covered > 0 ) {
							coveredCount++;
						}
						return coveredCount;
					}, 0 );
					// NEW CALC:
					if ( amended[ "numExecutableLines" ] > 0 ) {
						amended[ "percCoverage" ] = amended[ "numCoveredLines" ] / amended[ "numExecutableLines" ];
					} else {
						amended[ "percCoverage" ] = 1;
					}
					// Because Lucee rots. See LDEV-4269.
					queryAddRow( totalCoverage, 1 );
					amended.each( function( key, value ){
						totalCoverage[ key ][ totalCoverage.recordCount ] = value;
					} );
				} else {
					// Because Lucee rots. See LDEV-4269.
					queryAddRow( totalCoverage, 1 );
					row.each( function( key, value ){
						totalCoverage[ key ][ totalCoverage.recordCount ] = value;
					} );
				}
			} );

			/**
			 * After combining the previous coverage report with the current coverage query data,
			 * we save it as JSON to aggregate with the next test run.
			 */
			writeJSONReport( totalCoverage );
		} else {
			/**
			 * If no previous coverage data exists, we simply export the current coverage query to a struct
			 * and save as json for future test runs to consume.
			 */
			writeJSONReport( arguments.coverageQuery );
		}

		// Return a new query without modifying the old
		return totalCoverage.recordCount ? totalCoverage : arguments.coverageQuery;
	}

	/**
	 * Read test coverage report from .json file and return as a struct.
	 *
	 * @return a struct where `key` is the filePath and the value is each row from the coverage data query.
	 */
	private Query function readCoverageFromReportFile(){
		return deserializeJSON( fileRead( getCoverageReportFile() ), false );
	}

	private void function writeJSONReport( required Query coverageQuery ){
		fileWrite( getCoverageReportFile(), serializeJSON( arguments.coverageQuery, false, false ) );
	}

	/**
	 * Determine whether the provided filepath/filename is in the query.
	 *
	 * @return the row index
	 */
	private numeric function getRowIndexWithFile( required query coverage, required string filepath ){
		var index = 0;
		var i     = 1;
		for ( var row in arguments.coverage ) {
			if ( row[ "relativeFilePath" ] == arguments.filepath ) {
				index = i;
				break;
			}
			i++;
		}
		return index;
	}

	/**
	 * Set sane defaults for coverage report options.
	 *
	 * @opts The options to validate and extend/default.
	 */
	private struct function setDefaultOptions( struct opts = {} ){
		if ( isNull( opts.outputDir ) ) {
			opts.outputDir = "";
		}
		if ( isNull( opts.isBatched ) ) {
			opts.isBatched = false;
		}
		return opts;
	}

}

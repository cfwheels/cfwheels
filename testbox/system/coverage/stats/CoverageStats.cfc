/**
 * ********************************************************************************
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 * I turn a query of coverage data into stats
 */
component accessors=true {

	function init(){
		return this;
	}

	/**
	 *
	 * @qryCoverageData A query object containing coverage data
	 *
	 * @return struct of stats
	 */
	struct function generateStats( required query qryCoverageData ){
		var stats = {
			numFiles              : qryCoverageData.recordCount,
			percTotalCoverage     : 0,
			totalExecutableLines  : 0,
			totalCoveredLines     : 0,
			qryFilesWorstCoverage : "",
			qryFilesBestCoverage  : ""
		};

		// Remove the lineData column so it doesn't confuse the QofQ engine.
		var qryData = queryExecute(
			"
			SELECT filePath, relativeFilePath, filePathHash, numLines, numCoveredLines, numExecutableLines, percCoverage
			FROM qryCoverageData
			",
			{},
			{ dbtype : "query" }
		);

		// Get totals across all files
		var qryPerc = queryExecute(
			"
			SELECT	sum( numCoveredLines ) as sumCoveredLines ,
					sum( numExecutableLines ) as sumExecutableLines
			FROM qryData
			",
			{},
			{ dbtype : "query" }
		);

		if ( qryPerc.recordCount ) {
			stats.totalExecutableLines += val( qryPerc.sumExecutableLines );
			stats.totalCoveredLines += val( qryPerc.sumCoveredLines );
		}

		// Avoid divide-by-zero errors on the % calculation
		if ( stats.totalExecutableLines ) {
			stats.percTotalCoverage = stats.totalCoveredLines / stats.totalExecutableLines;
		}

		// Get files with best coverage
		var qryBest = queryExecute(
			"
			SELECT *
			FROM qryData
			WHERE percCoverage > 0
			ORDER BY percCoverage DESC, filePath
			",
			{},
			{ dbtype : "query", maxRows : 10 }
		);

		stats.qryFilesBestCoverage = qryBest;

		var listBestFilePathHashes = "'" & valueList( qryBest.filePathHash, "','" ) & "'";

		// Get files with worst coverage (exclude files already listed under "best" coverage)
		var qryWorst = queryExecute(
			"
			SELECT *
			FROM qryData
			WHERE filePathHash NOT IN ( #preserveSingleQuotes( listBestFilePathHashes )# )
				AND percCoverage < 1
			ORDER BY percCoverage ASC, filePath
			",
			{},
			{ dbtype : "query", maxRows : 10 }
		);

		stats.qryFilesWorstCoverage = qryWorst;

		return stats;
	}

}

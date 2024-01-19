/**
 * This tests the CoverageReporter functionality in TestBox.
 */
component extends="testbox.system.BaseSpec" {

	function run(){
		describe( "CoverageReporter", function(){
			it( "can init", function(){
				expect( new system.coverage.CoverageReporter() ).toBeComponent();
			} );
			it( "will read options", function(){
				var model = new system.coverage.CoverageReporter( {} );

				expect( model.getReportOptions().isBatched ).toBeFalse();
			} );
			describe( "batching disabled", function(){
				it( "won't process coverage data if batching disabled", function(){
					var model = prepareMock( new system.coverage.CoverageReporter( {} ) );
					model.$( "aggregateCoverageData" );

					model.processCoverageReport( queryNew( "filePath,numCoveredLines,lineData" ) );

					expect( model.$never( "aggregateCoverageData" ) ).toBeTrue(
						"shouldn't execute the aggregateCoverageData() method"
					);
				} );
			} );
			describe( "batching enabled", function(){
				it( "beginCoverageReport - deletes old JSON report if exists", function(){
					var opts  = { outputDir : expandPath( "./" ), isBatched : true };
					var model = prepareMock( new system.coverage.CoverageReporter( opts ) );

					// debug( model.getCoverageReportFile() );
					fileWrite( model.getCoverageReportFile(), serializeJSON( {} ) );


					expect( fileExists( model.getCoverageReportFile() ) ).toBeTrue();
					model.beginCoverageReport();

					expect( fileExists( model.getCoverageReportFile() ) ).toBeFalse();
				} );
			} );
			describe( "code coverage processing", function(){
				it( "processCoverageReport - merges coverage data", function(){
					var opts  = { outputDir : expandPath( "./" ), isBatched : true };
					var model = prepareMock( new system.coverage.CoverageReporter( opts ) );
					model.beginCoverageReport();

					// test initial report run
					model.processCoverageReport( getDummyCodeCoverage() );
					expect( fileExists( model.getCoverageReportFile() ) ).toBeTrue(
						"should create .json report file"
					);

					var initialResult = fileRead( model.getCoverageReportFile() );
					expect( initialResult ).toBeJSON();

					model.processCoverageReport( getDummyCodeCoverage() );
					var finalResult = fileRead( model.getCoverageReportFile() );
					expect( finalResult ).toBeJSON();

					expect( structKeyArray( deserializeJSON( finalResult ) ) ).toHaveLength(
						arrayLen( structKeyArray( deserializeJSON( initialResult ) ) ),
						"should merge NOT duplicate coverage data"
					);
				} );
				it( "processCoverageReport - keeps COVERED line data from both old and new", function(){
					var opts  = { outputDir : expandPath( "./" ), isBatched : true };
					var model = prepareMock( new system.coverage.CoverageReporter( opts ) );
					model.beginCoverageReport();

					// test initial report run
					var dummyData = getDummyCodeCoverage();

					// fake some code coverage
					var rowIndex                        = 1 // get row index
					dummyData[ "lineData" ][ rowIndex ] = { "1" : 1, "2" : "0" };

					// save to report JSON file
					model.processCoverageReport( dummyData );

					// now fake the ABSENCE of code coverage
					dummyData[ "lineData" ][ rowIndex ] = { "1" : 0, "2" : "1" };
					var resultQry                       = model.processCoverageReport( dummyData );
					var lineCoverage                    = resultQry
						.filter( function( row ){
							return row[ "relativeFilePath" ] == "CoverageReporterTest.cfc";
						} )
						.reduce( function( agg, row ){
							agg.append( row );
							return agg;
						}, [] )
						.first();

					debug( lineCoverage );

					var firstLineCoverage  = lineCoverage.lineData[ 1 ];
					var secondLineCoverage = lineCoverage.lineData[ 2 ];

					expect( firstLineCoverage ).toBe( 1, "should retain knowledge of previously covered code" );
					expect( secondLineCoverage ).toBe( 1, "should retain knowledge of current coverage report" );
				} );
			} );
		} );
	}

	function getDummyCodeCoverage(){
		var coverageQuery = queryNew(
			"filePath,relativeFilePath,filePathHash,numLines,numCoveredLines,numExecutableLines,percCoverage,lineData",
			"varchar,varchar,varchar,integer,integer,integer,decimal,object"
		);
		var path  = expandPath( "./" );
		var files = [
			"CoverageReporterTest.cfc",
			"CoverageServiceTest.cfc"
		];
		var rowN = 0;
		for ( var fileName in files ) {
			queryAddRow(
				coverageQuery,
				{
					filePath           : path & fileName,
					relativeFilePath   : fileName,
					numLines           : 3,
					numCoveredLines    : 0,
					numExecutableLines : 0,
					percCoverage       : 0,
					filePathHash       : hash( fileName ),
					lineData           : createObject( "java", "java.util.LinkedHashMap" ).init()
				}
			);
			qryData[ "lineData" ][ rowN ] = {};
			rowN++;
		}
		return coverageQuery;
	}

}

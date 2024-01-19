<!---
	Template for outputting overview stats about the line coverage details that were captured.
 --->
<cfset ASSETS_DIR=expandPath( "/testbox/system/reports/assets" )>
<cfoutput>
<cfif isDefined( 'stats' )>
	<cfset totalProjectCoverage = numberFormat( stats.percTotalCoverage * 100, '9.9' )>
	<div class="list-group mb-2">
		<div
			class="list-group-item list-group-item-info p-2"
			id="coverageStats"
		>
			<div class="d-flex flex-fill justify-content-between align-items-stretch expand-collapse"
				data-toggle="collapse"
				data-target="##coverage-stats"
				aria-expanded="false"
				aria-controls="coverage-stats"
				style="cursor: pointer;"
			>
				<div class="d-flex align-items-start flex-column">
					<h3 class="mb-auto">
						<i class="fas fa-microscope"></i> Code Coverage Stats
					</h3>

					<cfif len( coverageData.sonarQubeResults ) >
						<h5 class="mt-2">
							SonarQube code coverage XML file generated in <br>
							<span class="badge badge-info">#coverageData.sonarQubeResults#</span>
						</h5>
					</cfif>

					<cfif len( coverageData.browserResults ) >
						<h5 class="mt-1">
							Coverage Browser generated in <br>
							<span class="badge badge-info">#coverageData.browserResults#</span>
						</h5>
					</cfif>
				</div>
				<div class="d-flex align-items-end flex-column">
					<div class="text-right">
						<button
							class="btn btn-link py-0"
							style="text-decoration: none;"
							id="btn_coverageStats"
							title="Show coverage stats"
						>
							<i class="fas fa-plus-square plus-minus h2"></i>
						</button>
					</div>
					<div class="mt-auto text-right">
						<span class="h5">Files Processed:<span class="badge badge-info ml-1">#stats.numFiles#</span></span>
						<div class="d-inline-block ml-2">
							<div class="d-inline-block align-bottom" style="width:200px;">
								<div class="ml-1 progress position-relative" style="height: 1.4rem;">
									<div class="progress-bar bg-#codeBrowser.percentToContextualClass(totalProjectCoverage)#" role="progressbar" style="width: #totalProjectCoverage#%" aria-valuenow="#totalProjectCoverage#" aria-valuemin="0" aria-valuemax="100">
									</div>
									<div class="progress-bar bg-secondary" role="progressbar" style="width: #100 - totalProjectCoverage#%" aria-valuenow="#100 - totalProjectCoverage#" aria-valuemin="0" aria-valuemax="100">
									</div>
									<span class="justify-content-center text-light d-flex position-absolute w-100" style="line-height: 1.25rem; font-size: 1.2rem;">
										#totalProjectCoverage#% coverage
									</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<cfset bestCoverageHasCoveredFiles = ArraySum(ValueArray(stats.qryFilesBestCoverage, "percCoverage")) GT 0 >
			<cfset worstCoverageHasCoveredFiles = ArraySum(ValueArray(stats.qryFilesWorstCoverage, "percCoverage")) GT 0 >

			<div id="coverage-stats" class="debugdata mt-2 collapse" data-specid="coverageStats">
				<ul class="list-group">
					<cfif bestCoverageHasCoveredFiles >
						<li class="list-group-item">
							<h4>Files with best coverage:</h4>
							<ol class="list-group">
								<cfloop query="stats.qryFilesBestCoverage">
									<cfset qTarget         = stats.qryFilesBestCoverage>
									<cfset percentage      = numberFormat( qTarget.percCoverage * 100, '9.9' )>
									<cfset trimmedFilePath = replaceNoCase( qTarget.filePath, pathToCapture, '' )>
									<li class="list-group-item">
										<span class="col-9">#trimmedFilePath#</span>
										<div class=" col-3 d-inline-flex float-right">
											<div class="progress position-relative w-100">
												<div class="progress-bar bg-#codeBrowser.percentToContextualClass( percentage )#" role="progressbar" style="width: #percentage#%" aria-valuenow="#percentage#" aria-valuemin="0" aria-valuemax="100"></div>
												<div class="progress-bar bg-secondary" role="progressbar" style="width: #100-percentage#%" aria-valuenow="#100-percentage#" aria-valuemin="0" aria-valuemax="100"></div>
												<span class="justify-content-center text-light d-flex position-absolute w-100">#percentage#% coverage</span>
											</div>
										</div>
									</li>
								</cfloop>
							</ol>
						</li>
					</cfif>
					<cfif worstCoverageHasCoveredFiles >
						<li class="list-group-item">
							<h4>Files with worst coverage:</h4>
							<ol class="list-group">
								<cfloop query="stats.qryFilesWorstCoverage">
									<cfset qTarget      	= stats.qryFilesWorstCoverage>
									<cfset percentage 		= numberFormat( qTarget.percCoverage * 100, '9.9' )>
									<cfset trimmedFilePath 	= replaceNoCase( qTarget.filePath, pathToCapture, '' )>
									<li class="list-group-item">
										<span class="col-9">#trimmedFilePath#</span>
										<div class=" col-3 d-inline-flex float-right">
											<div class="progress position-relative w-100">
												<div class="progress-bar bg-#codeBrowser.percentToContextualClass( percentage )#" role="progressbar" style="width: #percentage#%" aria-valuenow="#percentage#" aria-valuemin="0" aria-valuemax="100"></div>
												<div class="progress-bar bg-secondary" role="progressbar" style="width: #100-percentage#%" aria-valuenow="#100-percentage#" aria-valuemin="0" aria-valuemax="100"></div>
												<span class="justify-content-center text-light d-flex position-absolute w-100">#percentage#% coverage</span>
											</div>
										</div>
									</li>
								</cfloop>
							</ol>
						</li>
					</cfif>
				</ul>
			</div>
		</div>
	</div>
</cfif>
</cfoutput>
<cfparam name="url.fullPage" default="true">
<cfset ASSETS_DIR = expandPath( "/testbox/system/reports/assets" )>
<cfoutput>
	<cfif url.fullPage>
		<!DOCTYPE html>
		<html>
			<head>
				<meta charset="utf-8">
				<meta name="generator" content="TestBox v#testbox.getVersion()#">
				<title>Pass: #results.getTotalPass()# Fail: #results.getTotalFail()# Errors: #results.getTotalError()#</title>

				<style>#fileRead(  "#ASSETS_DIR#/css/main.css" )#</style>
				<script>#fileRead(  "#ASSETS_DIR#/js/jquery-3.3.1.min.js" )#</script>
				<script>#fileRead(  "#ASSETS_DIR#/js/bootstrap.min.js" )#</script>
				<script>#fileRead( "#ASSETS_DIR#/js/fontawesome.js" )#</script>
			</head>
			<body>
	</cfif>
				<div class="container-fluid my-3">
					<!-- Header -->					
					<div class="d-flex justify-content-between align-items-end">
						<div>
							<img src="data:image/png;base64, #toBase64( fileReadBinary( '#ASSETS_DIR#/images/TestBoxLogo125.png' ) )#" height="75">
							<span class="badge badge-info">v#testbox.getVersion()#</span>
						</div>
						<div class="buttonBar mt-1 float-right mb-1">
							<a 	class="ml-1 btn btn-sm btn-primary float-right"
								href="#variables.baseURL#&directory=#URLEncodedFormat( URL.directory )#&opt_run=true"
								title="Run all tests"
							>
								<i class="fas fa-running"></i> Run All Tests
							</a>
						</div>
					</div>
					<!--- Code Coverage Stats --->
					<cfif results.getCoverageEnabled()>
						#testbox.getCoverageService().renderStats( results.getCoverageData(), false )#
					</cfif>
					<div class="list-group">
						<!--- Test Results Stats --->
						<div class="list-group-item list-group-item-info p-2 d-flex justify-content-between align-items-end" id="globalStats">
							<div>
								<h3><i class="fas fa-chart-line"></i> Test Results Stats (#numberFormat( results.getTotalDuration() )# ms)</h3>
								<div>
									<h5 class="mt-2">
										<span>Bundles:<span class="badge badge-info ml-1">#results.getTotalBundles()#</span></span>
										<span class="ml-3">Suites:<span class="badge badge-info ml-1">#results.getTotalSuites()#</span></span>
										<span class="ml-3">Specs:<span class="badge badge-info ml-1">#results.getTotalSpecs()#</span></span>
									</h5>
									<cfif arrayLen( results.getLabels() )>
										<h5 class="mt-2 mb-0">
											<span>Labels Applied: <span class="badge badge-info ml-1">#arrayToList( results.getLabels() )#</u></span>
										</h5>
									</cfif>
									<cfif arrayLen( results.getExcludes() )>
										<h5 class="mt-2 mb-0">
											<span>Excludes Applied: <span class="badge badge-info ml-1">#arrayToList( results.getExcludes() )#</u></span>
										</h5>
									</cfif>
								</div>
							</div>

							<div>
								<span
									class="specStatus badge badge-success passed"
									data-status="passed"
								>
									<i class="fas fa-check"></i> Pass: #results.getTotalPass()#
								</span>
								<span
									class="specStatus badge badge-warning failed"
									data-status="failed"
								>
									<i class="fas fa-exclamation-triangle"></i> Failures: #results.getTotalFail()#
								</span>
								<span
									class="specStatus badge badge-danger error"
									data-status="error"
								>
									<i class="fas fa-times"></i> Errors: #results.getTotalError()#
								</span>
								<span
									class="specStatus badge badge-secondary skipped"
									data-status="skipped"
								>
									<i class="fas fa-minus-circle"></i> Skipped: #results.getTotalSkipped()#
								</span>
								<span
									class="reset badge badge-dark"
									title="Clear status filters"
								>
									<i class="fas fa-broom"></i> Reset
								</span>
							</div>
						</div>
					</div>
					<!--- Debug Panel --->
					<cfloop array="#variables.bundleStats#" index="thisBundle">
						<cfif !isSimpleValue( thisBundle.globalException ) OR arrayLen( thisBundle.debugBuffer )>
							<div class="my-2">
								<div class="card-body p-0">
									<ul class="list-group">
										<!--- Global Error --->
										<cfif !isSimpleValue( thisBundle.globalException )>
											<li class="list-group-item list-group-item-danger">
												<span class="h5">
													<strong>Global Bundle Exception</strong>
												</span>
												<button class="btn btn-link float-right py-0 expand-collapse collapsed" id="btn_globalException_#thisBundle.id#" onclick="toggleDebug( 'globalException_#thisBundle.id#' )" title="Show more information">
													<i class="fas fa-plus-square"></i>
												</button>
												<div class="my-2 pl-4 debugdata" style="display:none;" data-specid="globalException_#thisBundle.id#">
													<cfdump var="#thisBundle.globalException#" />
												</div>
											</li>
										</cfif>
										<!--- Debug Panel --->
										<cfif arrayLen( thisBundle.debugBuffer )>
											<li class="list-group-item list-group-item-info">
												<span class="alert-link h5">
													<strong>Debug Stream: #thisBundle.path#</strong>
												</span>
												<button class="btn btn-link float-right py-0 expand-collapse collapsed" id="btn_#thisBundle.id#" onclick="toggleDebug( '#thisBundle.id#' )" title="Toggle the test debug stream">
													<i class="fas fa-plus-square"></i>
												</button>
												<div class="my-2 pl-4 debugdata" style="display:none;" data-specid="#thisBundle.id#">
													<p>The following data was collected in order as your tests ran via the <em>debug()</em> method:</p>
													<cfloop array="#thisBundle.debugBuffer#" index="thisDebug">
														<h6>#thisDebug.label#</h6>
														<cfdump var="#thisDebug.data#" label="#thisDebug.label# - #dateFormat( thisDebug.timestamp, " short" )# at #timeFormat( thisDebug.timestamp, "full" )#" top="#thisDebug.top#" />
													</cfloop>
												</div>
											</li>
										</cfif>
									</ul>
								</div>
							</div>
						</cfif>
					</cfloop>
				</div>
<script>
$( document ).ready( function() {
	$(".expand-collapse").click(function (event) {
		let icon = $(this).children(".svg-inline--fa");
		var icon_fa_icon = icon.attr('data-icon');

		if (icon_fa_icon === "minus-square") {
				icon.attr('data-icon', 'plus-square');
		} else if (icon_fa_icon === "plus-square") {
				icon.attr('data-icon', 'minus-square');
		}
	});
} );

function toggleDebug( specid ) {
	$( `##btn_${specid}` ).toggleClass( "collapsed" );
	$( "div.debugdata" ).each( function() {
		var $this = $( this );
		// if bundleid passed and not the same bundle
		if ( specid != undefined && $this.attr( "data-specid" ) != specid ) {
			return;
		}
		// toggle.
		$this.slideToggle();
	});
}
</script>
<cfif url.fullPage>
			</body>
		</html>
</cfif>
</cfoutput>
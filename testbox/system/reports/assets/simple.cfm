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
				<style>#fileRead( "#ASSETS_DIR#/css/main.css" )#</style>
				<script>#fileRead( "#ASSETS_DIR#/js/jquery-3.3.1.min.js" )#</script>
				<script>#fileRead( "#ASSETS_DIR#/js/popper.min.js" )#</script>
				<script>#fileRead( "#ASSETS_DIR#/js/bootstrap.min.js" )#</script>
				<script>#fileRead( "#ASSETS_DIR#/js/stupidtable.min.js" )#</script>
				<script>#fileRead( "#ASSETS_DIR#/js/fontawesome.js" )#</script>
			</head>
			<body>
	</cfif>
				<div class="container-fluid my-3">

					<!--- Filter--->
					<div class="d-flex justify-content-between align-items-end">

						<div>
							<!--- Header --->
							<div>
								<img src="data:image/png;base64, #toBase64( fileReadBinary( '#ASSETS_DIR#/images/TestBoxLogo125.png' ) )#" height="75">
								<span class="badge badge-info">v#testbox.getVersion()#</span>
							</div>
						</div>

						<div>
							<input class="d-inline col-7 ml-2 form-control float-right mb-1" type="text" name="bundleFilter" id="bundleFilter" placeholder="Filter Bundles..." size="35">
							<div class="buttonBar mb-1 float-right">
								<a 	class="ml-1 btn btn-sm btn-primary float-right"
									href="#variables.baseURL#&directory=#URLEncodedFormat( URL.directory )#&opt_run=true"
									title="Run all tests"
								>
									<i class="fas fa-running"></i> Run All Tests
								</a>
								<button
									id="collapse-bundles"
									class="ml-1 btn btn-sm btn-primary float-right"
									title="Collapse all bundles"
									>
										<i class="fas fa-minus-square"></i> Collapse All Bundles
								</button>
								<button
									id="expand-bundles"
									class="ml-1 btn btn-sm btn-primary float-right"
									title="Expand all bundles"
									>
										<i class="fas fa-plus-square"></i> Expand All Bundles
								</button>
							</div>
						</div>
					</div>

					<!--- Code Coverage Stats --->
					<cfif results.getCoverageEnabled()>
						#testbox.getCoverageService().renderStats( results.getCoverageData(), false )#
					</cfif>

					<!--- Global Stats --->
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
									<h5 class="mt-2 mb-0">
										<span class="badge badge-info">
											#results.getCFMLEngine()#
											#results.getCFMLEngineVersion()#
										</span>
									</h5>
								</div>
							</div>

							<div>
								<span
									class="spec-status btn btn-sm btn-success Passed"
									data-status="passed"
								>
									<i class="fas fa-check"></i> Pass: #results.getTotalPass()#
								</span>
								<span
									class="spec-status btn btn-sm btn-warning Failed"
									data-status="failed"
								>
									<i class="fas fa-exclamation-triangle"></i> Failures: #results.getTotalFail()#
								</span>
								<span
									class="spec-status btn btn-sm btn-danger Error"
									data-status="error"
								>
									<i class="fas fa-times"></i> Errors: #results.getTotalError()#
								</span>
								<span
									class="spec-status btn btn-sm btn-secondary Skipped"
									data-status="skipped"
								>
									<i class="fas fa-minus-circle"></i> Skipped: #results.getTotalSkipped()#
								</span>
								<span
									class="reset btn btn-sm btn-dark"
									title="Clear status filters"
								>
									<i class="fas fa-broom"></i> Reset
								</span>
							</div>
						</div>
						<div class="list-group-item accordion pl-0" id="bundles">
							<!--- Bundle Info --->
							<cfloop array="#variables.bundleStats#" index="thisBundle">

								<!--- Skip if not in the includes list --->
								<cfif len( url.testBundles ) and !listFindNoCase( url.testBundles, thisBundle.path )>
									<cfcontinue>
								</cfif>

								<!--- Bundle div --->
								<div class="bundle card" id="#thisBundle.path#" data-bundle="#thisBundle.path#">
									<div
										class="card-header expand-collapse"
										id="header_#thisBundle.id#"
										data-toggle="collapse"
										data-target="##details_#thisBundle.id#"
										aria-expanded="false"
										aria-controls="details_#thisBundle.id#"
										style="cursor: pointer;"
									>
										<h5 class="mb-0 clearfix">
											<!--- bundle stats --->
											<a
												class="alert-link h5"
												href="#variables.baseURL#&directory=#URLEncodedFormat( URL.directory )#&testBundles=#URLEncodedFormat( thisBundle.path )#&opt_run=true&coverageEnabled=false"
												title="Run only this bundle"
											>
												#thisBundle.path# (#numberFormat( thisBundle.totalDuration )# ms)
											</a>
											<button
													class="btn btn-link float-right py-0 bundle-btn"
													style="text-decoration: none;"
													type="button"
												>
												<i class="fas fa-minus-square plus-minus"></i>
											</button>
										</h5>
										<div class="float-right">
											<span
												class="spec-status btn btn-sm btn-success Passed"
												data-status="passed" data-bundleid="#thisBundle.id#"
											>
												<i class="fas fa-check"></i> Pass: #thisBundle.totalPass#
											</span>
											<span
												class="spec-status btn btn-sm btn-warning Failed"
												data-status="failed" data-bundleid="#thisBundle.id#"
											>
												<i class="fas fa-exclamation-triangle"></i> Failures: #thisBundle.totalFail#
											</span>
											<span
												class="spec-status btn btn-sm btn-danger Error"
												data-status="error" data-bundleid="#thisBundle.id#"
											>
												<i class="fas fa-times"></i> Errors: #thisBundle.totalError#
											</span>
											<span
												class="spec-status btn btn-sm btn-secondary Skipped"
												data-status="skipped" data-bundleid="#thisBundle.id#"
											>
												<i class="fas fa-minus-circle"></i> Skipped: #thisBundle.totalSkipped#
											</span>
											<span
												class="reset btn btn-sm btn-dark"
												data-bundleid="#thisBundle.id#"
												title="Clear status filters"
											>
												<i class="fas fa-broom"></i> Reset
											</span>
										</div>
										<h5 class="d-inline-block">
											<span>Suites:<span class="badge badge-info ml-1">#thisBundle.totalSuites#</span></span>
											<span class="ml-3">Specs:<span class="badge badge-info ml-1">#thisBundle.totalSpecs#</span></span>
										</h5>
									</div>

									<div
										id="details_#thisBundle.id#"
										class="collapse details-panel show"
										aria-labelledby="header_#thisBundle.id#"
										data-bundle="#thisBundle.path#"
									>
										<div class="card-body suite list-group"
												data-bundleid="#thisBundle.id#">
											<ul class="list-group">

												<!--- Global Exception --->
												<cfif !isSimpleValue( thisBundle.globalException )>
													<li>
														<div
															class="list-group-item list-group-item-danger py-3 expand-collapse"
															data-toggle="collapse"
															data-target="##globalException_#thisBundle.id#"
															aria-expanded="false"
															aria-controls="globalException_#thisBundle.id#"
															style="cursor: pointer;"
														>
															<span class="h5">
																<strong>
																	<i class="fas fa-times"></i> Global Bundle Exception
																</strong>(#numberFormat( thisBundle.totalDuration )# ms)
															</span>
															<button
																class="btn btn-link float-right py-0"
																style="text-decoration: none;"
																id="btn_globalException_#thisBundle.id#"
																title="Show more information"
															>
																<i class="fas fa-plus-square plus-minus"></i>
															</button>
															<div>#encodeForHtml( thisBundle.globalException.Message )#</div>
															<div class="bg-light p-2 ">
																<cfif arrayLen( thisBundle.globalException.TagContext ) && structKeyExists( thisBundle.globalException.TagContext[ 1 ], "codePrintHTML" )>
																	<code>#thisBundle.globalException.TagContext[ 1 ].codePrintHTML#</code>
																</cfif>
															</div>
														</div>
														<div class="overflow-auto my-2 collapse details-panel" id="globalException_#thisBundle.id#" data-specid="globalException_#thisBundle.id#">
															<cfdump var="#thisBundle.globalException#" />
														</div>
													</li>
												</cfif>

												<!-- Iterate over bundle suites -->
												<cfloop array="#thisBundle.suiteStats#" index="suiteStats">
													#genSuiteReport( suiteStats, thisBundle )#
												</cfloop>

												<!--- Debug Panel --->
												<cfif thisBundle.keyExists( "debugBuffer" ) && arrayLen( thisBundle.debugBuffer )>
													<li>
														<div class="list-group-item list-group-item-primary py-3 expand-collapse"
															title="Toggle Debug Stream"
															data-toggle="collapse"
															data-target="##debugdata_#thisBundle.id#"
															aria-expanded="false"
															aria-controls="debugdata_#thisBundle.id#"
															style="cursor: pointer;"
														>
															<span class="alert-link h5 text-info">
																<strong><i class="fas fa-bug"></i> Debug Stream</strong>
															</span>

															<button
																class="btn btn-link float-right py-0"
																style="text-decoration: none;"
																id="btn_#thisBundle.id#"
																title="Toggle the test debug stream"
															>
																<i class="fas fa-plus-square plus-minus"></i>
															</button>
														</div>
														<div id="debugdata_#thisBundle.id#" class="overflow-auto bg-light p-2 collapse" data-specid="#thisBundle.id#">
															<p>The following data was collected in order as your tests ran via the <em>debug()</em> method:</p>
															<cfloop array="#thisBundle.debugBuffer#" index="thisDebug">
																<cfif !IsNull(thisDebug)>
																	<h6>#thisDebug.label#</h6>
																	<cfdump var="#thisDebug.data#" label="#thisDebug.label# - #dateFormat( thisDebug.timestamp, " short" )# at #timeFormat( thisDebug.timestamp, "full" )#" top="#thisDebug.top#" />
																</cfif>
															</cfloop>
														</div>
													</li>
												</cfif>
											</ul>
										</div>
									</div>
								</div>
							</cfloop>
						</div>
					</div>
				</div>
	<script>
$( document ).ready( function() {
	// spec toggler
	$( "span.spec-status" ).click( function( event ) {
    event.stopPropagation();
		$( this ).parent().children().removeClass( "active" );
		$( this ).addClass( "active" );
		toggleSpecs( $( this ).attr( "data-status" ), $( this ).attr( "data-bundleid" ) );
	});

	// spec reseter
	$( "span.reset" ).click( function( event ) {
    event.stopPropagation();
		resetSpecs( $(this) );
	});

	// Filter Bundles
	$( "##bundleFilter" ).keyup( debounce( function() {
		let targetText = $( this ).val().toLowerCase();
		$( ".bundle" ).each( function( index ) {
			let bundle = $( this ).data( "bundle" ).toLowerCase();
			if ( bundle.search( targetText ) < 0 ) {
				// hide it
				$( this ).hide();
			} else {
				$( this ).removeAttr('style');
			}
		});
	}, 100));

	$( "##bundleFilter" ).focus();

	// Bootstrap Collapse
	$("body").on("click", "##collapse-bundles", function() {
		$(".details-panel").collapse("hide");
		$(".bundle-btn > svg.plus-minus").attr("data-icon", "plus-square");
	});

	$("body").on("click", "##expand-bundles", function() {
		$(".details-panel:not(.show)").collapse("show");
		$(".bundle-btn > svg.plus-minus").attr("data-icon", "minus-square");
	});

	$( "body" ).on("click", ".expand-collapse", function() {
		element = $( this );
		let icon = element.find( ".plus-minus" );
		let icon_fa_icon = icon.attr( 'data-icon' );

		if (icon_fa_icon === "minus-square") {
				icon.attr( 'data-icon', 'plus-square' );
		} else if ( icon_fa_icon === "plus-square" ) {
				icon.attr( 'data-icon', 'minus-square' );
		}
	});

});

function debounce( func, wait, immediate ) {
	let timeout;
	return function() {
		let context = this,
			args = arguments;
		let later = function() {
			timeout = null;
			if ( !immediate ) {
				func.apply( context, args );
			}
		};
		let callNow = immediate && !timeout;
		clearTimeout( timeout );
		timeout = setTimeout( later, wait );
		if ( callNow ) {
			func.apply( context, args );
		}
	};
};

function resetSpecs(element) {
	let selector = $( "li.spec, ul.suite, div.suite" );

	if ( element.attr( 'data-bundleid' ) ) {
		selector = $( `##details_${element.attr( 'data-bundleid' )}` );
		selector.find( "li.spec" ).each(function() {
			$( this ).removeAttr('style');
		});
		selector.find( "ul.suite" ).each(function() {
			$( this ).removeAttr('style');
		});
		selector.find( "div.suite" ).each(function() {
			$( this ).removeAttr('style');
		});
		selector.addClass("show");
	}
	else {
		selector.each(function() {
			$( this ).removeAttr('style');
		});
		$( ".details-panel" ).addClass("show");
	}
}

function toggleSpecs( type, bundleID ) {
	$( "ul.suite" ).each( function() {
		handleToggle( $( this ), bundleID, type );
	});
	$( "div.suite" ).each( function() {
		handleToggle( $( this ), bundleID, type );
	});
	$( "li.spec" ).each( function() {
		handleToggle( $( this ), bundleID, type );
	});
}

function handleToggle( target, bundleID, type ) {
	type = capitalizeFirstLetter( type );
	let $this = target;

	// if bundleid passed and not the same bundle, skip
	if ( bundleID != undefined && $this.attr( "data-bundleid" ) != bundleID ) {
		return;
	}
	// toggle the opposite type
	if ( !$this.hasClass( type ) ) {
		$this.hide();
	} else {
		// show the type you sent
		$this.removeAttr('style');
		$this.parents().removeAttr('style');
		$this.parents(".bundle").find(".details-panel:not(.show)").addClass("show");
		$this.parents(".bundle").find(".bundle-btn > svg.plus-minus").attr("data-icon", "minus-square");
	}
}

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}
</script>
<style>
code {
	color: black !important;
}
</style>
<cfif url.fullPage>
			</body>
		</html>
</cfif>
</cfoutput>

<cffunction name="statusToBootstrapClass" output="false">
	<cfargument name="status">
	<cfset bootstrapClass = "">
	<cfif lcase( arguments.status ) eq "failed">
		<cfset bootstrapClass = "warning">
	<cfelseif lcase( arguments.status ) eq "error">
		<cfset bootstrapClass = "danger">
	<cfelseif lcase( arguments.status ) eq "passed">
		<cfset bootstrapClass = "success">
	<cfelseif lcase( arguments.status ) eq "skipped">
		<cfset bootstrapClass = "secondary">
	</cfif>
	<cfreturn bootstrapClass>
</cffunction>

<cffunction name="statusToIcon" output="false">
	<cfargument name="status">
	<cfset icon = "">
	<cfif lcase( arguments.status ) eq "failed">
		<cfset icon = '<i class="fas fa-exclamation-triangle"></i>'>
	<cfelseif lcase( arguments.status ) eq "error">
		<cfset icon = '<i class="fas fa-times"></i>'>
	<cfelseif lcase( arguments.status ) eq "passed">
		<cfset icon = '<i class="fas fa-check"></i>'>
	<cfelseif lcase( arguments.status ) eq "skipped">
		<cfset icon = '<i class="fas fa-minus-circle"></i>'>
	</cfif>
	<cfreturn icon>
</cffunction>

<!--- Recursive Output --->
<cffunction name="genSuiteReport" output="false">
	<cfargument name="suiteStats">
	<cfargument name="bundleStats">
	<cfsavecontent variable="local.report">
		<cfoutput>
			<li class="list-group-item #suiteStats.status#" data-bundleid="#suiteStats.bundleID#">
				<!--- Suite Results --->
				<a
					class="alert-link text-#statusToBootstrapClass( suiteStats.status )#"
					title="Total: #arguments.suiteStats.totalSpecs# Passed:#arguments.suiteStats.totalPass# Failed:#arguments.suiteStats.totalFail# Errors:#arguments.suiteStats.totalError# Skipped:#arguments.suiteStats.totalSkipped#"
					href="#variables.baseURL#&directory=#URLEncodedFormat( URL.directory )#&testSuites=#URLEncodedFormat( arguments.suiteStats.name )#&testBundles=#URLEncodedFormat( arguments.bundleStats.path )#&opt_run=true&coverageEnabled=false"
				>
					#statusToIcon( arguments.suiteStats.status )# <strong>#arguments.suiteStats.name#</strong>
					(#numberFormat( arguments.suiteStats.totalDuration )# ms)
				</a>
				<ul class="list-group">
					<cfloop array="#arguments.suiteStats.specStats#" index="local.thisSpec">
						<!--- Spec Results --->

						<li
							class="spec list-group-item #local.thisSpec.status#"
							data-bundleid="#arguments.bundleStats.id#"
							data-specid="#local.thisSpec.id#"
						>
							<div class="clearfix">
								<a
									class="alert-link text-#statusToBootstrapClass( local.thisSpec.status )#"
									href="#variables.baseURL#&directory=#URLEncodedFormat( URL.directory )#&testSpecs=#URLEncodedFormat( local.thisSpec.name )#&testBundles=#URLEncodedFormat( arguments.bundleStats.path )#&opt_run=true&coverageEnabled=false"
								>
									#statusToIcon( local.thisSpec.status )# #local.thisSpec.name# (#numberFormat( local.thisSpec.totalDuration )# ms)
								</a>

								<!--- Compose message according to status --->
								<cfif local.thisSpec.status eq "failed">
									<cfset local.thisSpec.message = local.thisSpec.failMessage>
								</cfif>
								<cfif local.thisSpec.status eq "error">
									<cfset local.thisSpec.message = local.thisSpec.error.message & local.thisSpec.error.detail>
								</cfif>

								<!--- Show it with expanding button --->
								<cfif structKeyExists( local.thisSpec, "message" )>
									- <strong>#encodeForHTML( local.thisSpec.message )#</strong></a>
									<button
										class="btn btn-link float-right py-0 expand-collapse"
										data-toggle="collapse"
										data-target="##failure_error_#local.thisSpec.id#"
										aria-expanded="false"
										aria-controls="failure_error_#local.thisSpec.id#"
										style="text-decoration: none;"
										id="btn_#local.thisSpec.id#"
										title="Show more information"
									>
										<i class="fas fa-plus-square plus-minus"></i>
									</button>
								</cfif>
							</div>

							<!--- Show failed data snapshot --->
							<cfif structKeyExists( local.thisSpec, "message" )>
								<div>

									<!--- Failure Snapshot --->
									<cfif local.thisSpec.status eq "failed" && isArray( local.thisSpec.failOrigin ) && arrayLen( local.thisSpec.failOrigin )>
										<cfloop array="#local.thisSpec.failOrigin#" item="thisContext">
											<cfif findNoCase( arguments.bundleStats.path, reReplace( thisContext.template, "(/|\\)", ".", "all" ) )>
												<!--- Template --->
												<div style="margin-bottom: 5px">
													<a href="#openInEditorURL( thisContext.template, thisContext.line, url.editor )#">
														#thisContext.template#:#thisContext.line#
													</a>
												</div>
												<!--- Lucee Nice Code Print --->
												<cfif structKeyExists( thisContext, "codePrintHTML" )>
													<div class="pl-5 mb-2 bg-light">
														<code>#thisContext.codePrintHTML#</code>
													</div>
												</cfif>
											</cfif>
										</cfloop>
									</cfif>

									<!--- If it's an error, show the last snapshot --->
									<cfif !isNull( local.thisSpec.error.tagContext ) && arrayLen( local.thisSpec.error.tagContext ) >
										<cfset var thisContext = local.thisSpec.error.tagContext[ 1 ]>
										<!--- Template --->
										<div style="margin-bottom: 5px">
											<a href="#openInEditorURL( thisContext.template, thisContext.line, url.editor )#">
												#thisContext.template#:#thisContext.line#
											</a>
										</div>
										<!--- Lucee Nice Code Print --->
										<cfif structKeyExists( thisContext, "codePrintHTML" )>
											<div class="pl-5 mb-2 bg-light">
												<code>#thisContext.codePrintHTML#</code>
											</div>
										</cfif>
										<!--- Stacktrace mini snapshot --->
										<div class="pl-5 mb-2 bg-light">
											<pre>#left( local.thisSpec.error.stackTrace, 1000 )#</pre>
										</div>
									</cfif>

									<!--- Deep Insights into failures, hidden by default --->
									<div id="failure_error_#local.thisSpec.id#" class="my-2 collapse" data-specid="#local.thisSpec.id#">
										<!--- Origin --->
										<h4>Failure Origin</h4>
										<cfloop array="#local.thisSpec.failOrigin#" index="thisStack">
											<div
												style="border: 1px solid blue; padding: 5px; margin: 5px 0px; border-radius: 5px; cursor: pointer"
												title="Open in Editor"
												onClick="window.location='#openInEditorURL( thisStack.template, thisStack.line, url.editor )#'"
											>
												#thisStack.template#:#thisStack.line#
												<cfif !isNull( thisStack.codePrintPlain )>
													<pre>#thisStack.codePrintPlain#</pre>
												</cfif>
											</div>
										</cfloop>

										<!--- Fail Detail --->
										<cfif len( local.thisSpec.failDetail )>
											<h4>Failure Details</h4>
											<cfdump var="#local.thisSpec.failDetail#">
										</cfif>

										<!--- StackTrace --->
										<h4>Failure StackTrace</h4>
										<cfif len( local.thisSpec.failStackTrace )>
											<pre>#encodeForHTML( local.thisSpec.failStackTrace )#</pre>
										</cfif>
										<cfif !isNull( local.thisSpec.error.stackTrace )>
											<pre>#encodeForHTML( local.thisSpec.error.stackTrace )#</pre>
										</cfif>

										<!--- Extended Info --->
										<cfif len( local.thisSpec.failExtendedInfo )>
											<h4>Failure Extended Info</h4>
											<cfdump var="#local.thisSpec.failExtendedInfo#">
										</cfif>
									</div>
								</div>
							</cfif>
						</li>
					</cfloop>

					<!--- Do we have nested suites --->
					<cfif arrayLen( arguments.suiteStats.suiteStats )>
						<cfloop array="#arguments.suiteStats.suiteStats#" index="local.nestedSuite">
							#genSuiteReport( local.nestedSuite, arguments.bundleStats )#
						</cfloop>
					</cfif>
				</ul>
			</li>
		</cfoutput>
	</cfsavecontent>
	<cfreturn local.report>
</cffunction>

<cfoutput>
<!-- Stats --->
<section class="border border-info my-1 p-1 bg-light clearfix" id="globalStats">

	<h2>Stats (#results.getTotalDuration()# ms)</h2>
	<p>
		Bundles/Suites/Specs: #results.getTotalBundles()#/#results.getTotalSuites()#/#results.getTotalSpecs()#
		<br>
		<span class="badge badge-success" data-status="passed">Pass: #results.getTotalPass()#</span>
		<span class="badge badge-warning" data-status="failed">Failures: #results.getTotalFail()#</span>
		<span class="badge badge-danger" data-status="error">Errors: #results.getTotalError()#</span>
		<span class="badge badge-secondary" data-status="skipped">Skipped: #results.getTotalSkipped()#</span>
		<br>
		<cfif arrayLen( results.getLabels() )>
		Labels Applied: #arrayToList( results.getLabels() )#<br>
		</cfif>
		<cfif results.getCoverageEnabled()>
		Coverage: #numberFormat( results.getCoverageData().stats.percTotalCoverage*100, '9.9' )#%
		</cfif>
	</p>
</section>

<!--- Bundle Info --->
<cfloop array="#variables.bundleStats#" index="thisBundle">
	<section class="bundle" id="bundle-#thisBundle.path#">

		<!--- bundle stats --->
		<h2>#thisBundle.path# (#thisBundle.totalDuration# ms)</h2>
		<p>
			Suites/Specs: #thisBundle.totalSuites#/#thisBundle.totalSpecs#
			<br>
			<span class="badge badge-success" 	data-status="passed" data-bundleid="#thisBundle.id#">Pass: #thisBundle.totalPass#</span>
			<span class="badge badge-warning" 	data-status="failed" data-bundleid="#thisBundle.id#">Failures: #thisBundle.totalFail#</span>
			<span class="badge badge-danger" 	data-status="error" data-bundleid="#thisBundle.id#">Errors: #thisBundle.totalError#</span>
			<span class="badge badge-secondary" 	data-status="skipped" data-bundleid="#thisBundle.id#">Skipped: #thisBundle.totalSkipped#</span>
		</p>

		<!-- Global Error --->
		<cfif !isSimpleValue( thisBundle.globalException )>
			<h2>Global Bundle Exception</h2>
			<p>#thisBundle.globalException.stacktrace#</p>
		</cfif>

		<!-- Iterate over bundle suites -->
		<cfloop array="#thisBundle.suiteStats#" index="suiteStats">
			<section class="suite #statusToBootstrapClass( suiteStats.status )#" data-suiteid="#suiteStats.id#">
			<dl>
				#genSuiteReport( suiteStats, thisBundle )#
			</dl>
			</section>
		</cfloop>

	</section>
</cfloop>

<cffunction name="statusToBootstrapClass" output="false">
	<cfargument name="status">

	<cfif lcase( arguments.status ) eq "failed">
		<cfset bootstrapClass = "text-warning">
	<cfelseif lcase( arguments.status ) eq "error">
		<cfset bootstrapClass = "text-danger">
	<cfelseif lcase( arguments.status ) eq "passed">
		<cfset bootstrapClass = "text-success">
	<cfelseif lcase( arguments.status ) eq "skipped">
		<cfset bootstrapClass = "text-secondary">
	</cfif>

	<cfreturn bootstrapClass>
</cffunction>

<!--- Recursive Output --->
<cffunction name="genSuiteReport" output="false">
	<cfargument name="suiteStats">
	<cfargument name="bundleStats">

	<cfsavecontent variable="local.report">
		<cfoutput>
		<!--- Suite Results --->
		<h2>+#arguments.suiteStats.name# (#arguments.suiteStats.totalDuration# ms)</h2>
		<dl>
			<cfloop array="#arguments.suiteStats.specStats#" index="local.thisSpec">
				<!--- Spec Results --->
				<cfset thisSpecStatusClass = statusToBootstrapClass(local.thisSpec.status)>

				<dt class="spec #thisSpecStatusClass#" data-bundleid="#arguments.bundleStats.id#" data-specid="#local.thisSpec.id#">
					#local.thisSpec.name# (#local.thisSpec.totalDuration# ms)
				</dt>

				<cfif local.thisSpec.status eq "failed">
					<dd>#encodeForHTML( local.thisSpec.failMessage )#</dd>
					<dd><textarea cols="100" rows="20">#local.thisSpec.failOrigin.toString()#</textarea></dd>
				</cfif>

				<cfif local.thisSpec.status eq "error">
					<dd>#encodeForHTML( local.thisSpec.error.message )#</dd>
					<dd><textarea cols="100" rows="20">#local.thisSpec.error.stacktrace#</textarea></dd>
				</cfif>
			</cfloop>

			<!--- Do we have nested suites --->
			<cfif arrayLen( arguments.suiteStats.suiteStats )>
				<cfloop array="#arguments.suiteStats.suiteStats#" index="local.nestedSuite">
					<section class="suite #statusToBootstrapClass(arguments.suiteStats.status)#" data-bundleid="#arguments.bundleStats.id#">
					<dl>
						#genSuiteReport( local.nestedSuite, arguments.bundleStats )#
					</dl>
					</section>
				</cfloop>
			</cfif>

		</dl>
		</cfoutput>
	</cfsavecontent>

	<cfreturn local.report>
</cffunction>
</cfoutput>
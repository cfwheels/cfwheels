<cfoutput>█▓▒▒░░░ TestBox v#testbox.getVersion()# ░░░▒▒▓█
<!--- Iterate over each bundle tested --->
<cfloop array="#variables.bundleStats#" index="thisBundle">
_____________________________________________________________
#space()#
<!--- Bundle Name --->
#getBundleIndicator( thisBundle )##thisBundle.path# (#thisBundle.totalDuration# ms)
<!--- Bundle Report --->
[Passed: #thisBundle.totalPass#] [Failed: #thisBundle.totalFail#] [Errors: #thisBundle.totalError#] [Skipped: #thisBundle.totalSkipped#] [Suites/Specs: #thisBundle.totalSuites#/#thisBundle.totalSpecs#]
#space()#<!--- Bundle Exception Output --->
<cfif !isSimpleValue( thisBundle.globalException )>
#space()#
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
<GLOBAL BUNDLE EXCEPTION>
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#space()#
#thisBundle.globalException.type#:#thisBundle.globalException.message#:#thisBundle.globalException.detail#
<cfloop array="#thisBundle.globalException.tagContext#" item="thisContext">
	<cfif findNoCase( thisBundle.path, reReplace( thisContext.template, "(/|\\)", ".", "all" ) )>
	#thisContext.template#:#thisContext.line#
	#thisContext.codePrintPlain ?: ""#
	</cfif>
</cfloop>
#space()#
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
</cfif><!--- Generate Suite Reports --->
<cfloop array="#thisBundle.suiteStats#" index="suiteStats">#genSuiteReport( suiteStats, thisBundle )#</cfloop>
</cfloop>
<!--- Final Stats --->
#space()#
#space()#
=================================================================================
Final Stats
=================================================================================
#space()#
[Passed: #results.getTotalPass()#] [Failed: #results.getTotalFail()#] [Errors: #results.getTotalError()#] [Skipped: #results.getTotalSkipped()#] [Bundles/Suites/Specs: #results.getTotalBundles()#/#results.getTotalSuites()#/#results.getTotalSpecs()#]
<!--- Code Coverage --->
<cfif results.getCoverageEnabled()>
#space()#
=================================================================================
Code Coverage
=================================================================================
[Total Coverage: #numberFormat( results.getCoverageData().stats.percTotalCoverage*100, '9.9' )#%]
#space()#
</cfif>
<!--- Final Test Stats --->
#space()#
TestBox: #space( 6 )# v#testbox.getVersion()#
Duration: #space( 5 )# #results.getTotalDuration()# ms
CFML Engine: #space( 2 )# #results.getCFMLEngine()# #results.getCFMLEngineVersion()#
Labels: #space( 7 )# #arrayToList( results.getLabels() )#<cfif !arrayLen( results.getLabels() )>None</cfif>
#space()#

<!--- Legend --->
√ Passed #space( 2 )# - Skipped #space( 2 )# !! Exception/Error #space( 2 )# X Failure
<!--- Generate Suite Reports Recursively --->
<cffunction name="genSuiteReport" output="false">
	<cfargument name="suiteStats">
	<cfargument name="bundleStats">
	<cfargument name="level" default=0>
	<cfsetting enablecfoutputonly="true">
	<cfset var tabs = repeatString( tab(), arguments.level )>
	<cfset var tabsNext = repeatString( tab(), arguments.level + 1 )>
	<cfsavecontent variable="local.report"><cfoutput><!---

			Suite Name

		--->#tabs#( #getStatusIndicator( arguments.suiteStats.status )# ) #arguments.suiteStats.name# #chr(13)#<!---

			Specs

		---><cfloop array="#arguments.suiteStats.specStats#" index="local.thisSpec"><!---
		--->#tabsNext#( #getStatusIndicator( local.thisSpec.status )# ) #local.thisSpec.name# (#local.thisSpec.totalDuration# ms) #chr(13)#<!---

			If Spec Failed

		---><cfif local.thisSpec.status eq "failed"><!---
		--->#space()##tabsNext# ! Failure: #local.thisSpec.failMessage# #local.thisSpec.failDetail# #chr(13)#
		   #space()#
<!---
		---></cfif><!---

			If Spec Errored Out

		---><cfif local.thisSpec.status eq "error"><!---
		--->#space()#
 #tabsNext# X Error: #local.thisSpec.error.message# #local.thisSpec.error.detail# #chr(13)#<!---
 ---><cfloop array="#local.thisSpec.error.tagContext#" index="thisStack"><!---
Only show non testbox template paths
---><cfif !reFindNoCase( "testbox(\/|\\)system(\/|\\)", thisStack.template )>#tabsNext#-> #thisStack.template#:#thisStack.line#
</cfif><!---
---></cfloop>
#space()#
#left( local.thisSpec.error.stackTrace, 1500 )# #chr(13)##chr(13)#
#space()#
<!---
---></cfif><!---
		---></cfloop><!---

			Do we have nested suites

		---><cfif arrayLen( arguments.suiteStats.suiteStats )><!---
			---><cfloop array="#arguments.suiteStats.suiteStats#" index="local.nestedSuite"><!---
			--->#genSuiteReport( local.nestedSuite, arguments.bundleStats, arguments.level + 1 )#<!---
			---></cfloop><!---
		---></cfif><!---
		---></cfoutput><!---
	---></cfsavecontent>
	<cfreturn local.report>
</cffunction>
</cfoutput>

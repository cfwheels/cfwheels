<cfsetting requesttimeout="10000" showdebugoutput="true">
<cfparam name="params.type" default="core">
<cfset testresults = $createObjectFromRoot(path=application.wheels.wheelsComponentPath, fileName="test", method="$WheelsRunner", options=params)>

<cfif !isStruct(testresults)>
	<cfoutput><p>No tests found.</p></cfoutput>
<cfelse>
<cfset linkParams = "?controller=wheels&action=wheels&view=tests&type=#params.type#">
<style type="text/css">
#content a {text-decoration:none; font-weight:bold;}
.failed {color:red;font-weight:bold}
.success {color:green;font-weight:bold}
table.testing {border:0;margin-bottom:15px;}
table.testing td, table.testing th {padding:2px 20px 2px 2px;text-align:left;vertical-align:top;font-size:14px;}
table.testing td.n {text-align:right;}
table.testing tr.errRow {background-color:#FFDFDF;}
</style>
<cfoutput>
<p><a href="#linkParams#">Run All Tests</a> | <a href="#linkParams#&reload=true">Reload Test Data</a></p>
<table class="testing">
	<tr><th class="<cfif testresults.ok>success<cfelse>failed</cfif>">Status</th><td class="numeric<cfif testresults.ok> success<cfelse> failed</cfif>"><cfif testresults.ok>Passed<cfelse>Failed</cfif></td></tr>
	<tr><th>Path</th><td class="n">#listChangeDelims(testresults.path, "/", ".")#</td></tr>
	<tr><th>Duration</th><td class="n">#timeFormat(testresults.end - testresults.begin, "HH:mm:ss")#</td></tr>
	<tr><th>Packages</th><td class="n">#testresults.numCases#</td></tr>
	<tr><th>Tests</th><td class="n">#testresults.numTests#</td></tr>
	<tr><th<cfif testresults.numFailures neq 0> class="failed"</cfif>>Failures</th><td class="n<cfif testresults.numFailures neq 0> failed</cfif>">#testresults.numFailures#</td></tr>
	<tr><th<cfif testresults.numErrors neq 0> class="failed"</cfif>>Errors</th><td class="n<cfif testresults.numErrors neq 0> failed</cfif>">#testresults.numErrors#</td></tr>
</table>
<table class="testing">
<tr><th>Package</th></th><th>Tests</th><th>Failures</th><th>Errors</th></tr>
<cfloop from="1" to="#arrayLen(testresults.summary)#" index="testIndex">
	<tr<cfif testresults.summary[testIndex].numFailures + testresults.summary[testIndex].numErrors gt 0> class="errRow"</cfif>>
		<td>
			<cfset a = ListToArray(testresults.summary[testIndex].packageName, ".")>
			<cfset b = createObject("java", "java.util.ArrayList").Init(a)>
			<cfset c = arraylen(a)>
			<cfloop from="1" to="#c#" index="i"><a href="#linkParams#&package=#ArrayToList(b.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#">#a[i]#</a><cfif i neq c>.</cfif></cfloop>
		</td>
		<td class="n">#testresults.summary[testIndex].numTests#</td>
		<td class="n<cfif testresults.summary[testIndex].numFailures neq 0> failed</cfif>">#testresults.summary[testIndex].numFailures#</td>
		<td class="n<cfif testresults.summary[testIndex].numErrors neq 0> failed</cfif>">#testresults.summary[testIndex].numErrors#</td>
	</tr>
</cfloop>
</table>
<table class="testing">
<tr><th>Package</th><th>Test Name</th><th>Time</th><th>Status</th></tr>
<cfloop from="1" to="#arrayLen(testresults.results)#" index="testIndex">
	<tr>
		<td><a href="#linkParams#&package=#testresults.results[testIndex].packageName#">#testresults.results[testIndex].cleanTestCase#</a></td>
		<td><a href="#linkParams#&package=#testresults.results[testIndex].packageName#&test=#testresults.results[testIndex].testName#">#testresults.results[testIndex].cleanTestName#</a></td>
		<td class="n">#testresults.results[testIndex].time#</td>
		<td class="<cfif testresults.results[testIndex].status eq 'Success'>success<cfelse>failed</cfif>">#testresults.results[testIndex].status#</td>
	</tr>
	<cfif testresults.results[testIndex].status neq "Success">
		<tr><td colspan="7" class="failed">#replace(testresults.results[testIndex].message, chr(10), "<br/>", "ALL")#</td></tr>
	</cfif>
</cfloop>
</table>
</cfoutput>
</cfif>
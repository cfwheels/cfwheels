<cfoutput>
<cfcontent type="text/xml" />
<?xml version="1.0" encoding="UTF-8"?>
<testsuite errors="#testResults.numErrors#" failures="#testResults.numFailures#" name="#capitalize(params.type)# Tests" tests="#testResults.numTests#" time="#DateDiff("n",testResults.end,testResults.begin)#" timestamp="#now()#">
<cfloop from="1" to="#arrayLen(testResults.results)#" index="loc.i">  <testcase name="#testResults.results[loc.i].testName#" time="#testResults.results[loc.i].time#"><cfif testResults.results[loc.i].status neq "Success"><failure message="#XmlFormat(HtmlCompressFormat(testResults.results[loc.i].message))#">#XmlFormat(HtmlCompressFormat(testResults.results[loc.i].message))#</failure></cfif></testcase>#Chr(13)#</cfloop>
  <system-out><![CDATA[]]></system-out>
  <system-err><![CDATA[]]></system-err>
</testsuite>
</cfoutput>

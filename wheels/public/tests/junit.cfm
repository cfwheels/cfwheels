<cfoutput>
<cfcontent type="text/xml" />
<?xml version="1.0" encoding="UTF-8"?>
<testsuite errors="#testResults.numErrors#" failures="#testResults.numFailures#" name="#capitalize(params.type)# Tests" tests="#testResults.numTests#" time="#DateDiff("n",testResults.end,testResults.begin)#" timestamp="#now()#">
<cfloop from="1" to="#arrayLen(testResults.results)#" index="local.i">  <testcase name="#testResults.results[local.i].testName#" time="#testResults.results[local.i].time#"><cfif testResults.results[local.i].status neq "Success"><failure message="#XmlFormat(HtmlCompressFormat(testResults.results[local.i].message))#">#XmlFormat(HtmlCompressFormat(testResults.results[local.i].message))#</failure></cfif></testcase>#Chr(13)#</cfloop>
  <system-out><![CDATA[]]></system-out>
  <system-err><![CDATA[]]></system-err>
</testsuite>
</cfoutput>

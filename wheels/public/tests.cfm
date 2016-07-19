<cfscript>
	setting requesttimeout="10000" showdebugoutput="false";
	param name="params.type" default="core";
	param name="params.format" default="html";

	// run the tests
	testResults = $createObjectFromRoot(path="wheels", fileName="Test", method="$WheelsRunner", options=params);

	// output the results in the requested format
	include "tests/#params.format#.cfm";
</cfscript>

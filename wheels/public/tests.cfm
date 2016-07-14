<cfscript>
	setting requesttimeout="10000" showdebugoutput="false";
	param name="params.type" default="core";
	param name="params.format" default="html";

	// run the tests
	if (params.type != "app") {
		testResults = $createObjectFromRoot(path=application.wheels.wheelsComponentPath, fileName="Test", method="$WheelsRunner", options=params);
	} else {
		testResults = $createObjectFromRoot(path="tests", fileName="Test", method="$WheelsRunner", options=params);
	}

	// output the results in the requested format
	include "tests/#params.format#.cfm";
</cfscript>

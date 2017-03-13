<cfscript>
setting requestTimeout=10000 showDebugOutput=false;
param name="params.type" default="core";
param name="params.format" default="html";

// Run the tests.
testResults = $createObjectFromRoot(
	fileName="Test",
	method="$WheelsRunner",
	options=params,
	path=application.wheels.wheelsComponentPath
);

// Output the results in the requested format.
include "tests/#params.format#.cfm";

</cfscript>

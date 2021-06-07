<cfscript>
//public void function onAbort(required targetpage) {
	$restoreTestRunnerApplicationScope();
	$include(template = "/app/#application.wheels.eventPath#/onabort.cfm");
//}
</cfscript>

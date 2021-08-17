<cfscript>
public void function onAbort(required targetpage) {
	$restoreTestRunnerApplicationScope();
	$include(template = "#application.wheels.eventPath#/onabort.cfm");
}
</cfscript>

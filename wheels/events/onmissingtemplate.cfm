<cfscript>

public void function onMissingTemplate(required targetpage) {
	local.lockName = "reloadLock" & application.applicationName;
	$simpleLock(name=local.lockName, execute="$runOnMissingTemplate", executeArgs=arguments, type="readOnly", timeout=180);
}

public void function $runOnMissingTemplate(required targetpage) {
	if (!application.wheels.showErrorInformation) {
		$header(statusCode=404, statustext="Not Found");
	}
	$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
	abort;
}

</cfscript>

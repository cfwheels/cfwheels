<cfscript>

public void function onSessionStart() {
	local.lockName = "reloadLock" & application.applicationName;

	// Fix for shared application name (issue 359).
	if (!StructKeyExists(application, "wheels") || !StructKeyExists(application.wheels, "eventpath")) {
		$simpleLock(name=local.lockName, execute="onApplicationStart", type="exclusive", timeout=180);
	}

	$simpleLock(name=local.lockName, execute="$runOnSessionStart", type="readOnly", timeout=180);
}

public void function $runOnSessionStart() {
	$initializeRequestScope();
	$include(template="#application.wheels.eventPath#/onsessionstart.cfm");
}

</cfscript>

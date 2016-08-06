<cfscript> 
	public void function onRequestEnd(required targetpage) {
		var loc = {};
		loc.lockName = "reloadLock" & application.applicationName;
		$simpleLock(name=loc.lockName, execute="$runOnRequestEnd", executeArgs=arguments, type="readOnly", timeout=180);
		if (application.wheels.showDebugInformation && StructKeyExists(request.wheels, "showDebugInformation") && request.wheels.showDebugInformation)
		{
			$includeAndOutput(template="wheels/events/onrequestend/debug.cfm");
		}
	}

	public void function $runOnRequestEnd(required targetpage) {
		if (application.wheels.showDebugInformation)
		{
			$debugPoint("requestEnd");
		}
		$include(template="#application.wheels.eventPath#/onrequestend.cfm");
		if (application.wheels.showDebugInformation)
		{
			$debugPoint("requestEnd,total");
		}
	}
</cfscript>
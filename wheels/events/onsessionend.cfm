<cfscript>
	public void function onSessionEnd(required sessionScope, required applicationScope){
		var loc = {};
		loc.lockName = "reloadLock" & arguments.applicationScope.applicationName;
		$simpleLock(name=loc.lockName, execute="$runOnSessionEnd", executeArgs=arguments, type="readOnly", timeout=180);
	}

	public void function $runOnSessionEnd(required sessionScope, required applicationScope){
		$include(template="#arguments.applicationScope.wheels.eventPath#/onsessionend.cfm", argumentCollection=arguments);
	}
</cfscript>
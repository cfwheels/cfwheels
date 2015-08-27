<cffunction name="onRequestEnd" returntype="void" access="public" output="true">
	<cfargument name="targetpage" type="any" required="true">
	<cfscript>
		var loc = {};
		loc.lockName = "reloadLock" & application.applicationName;
		$simpleLock(name=loc.lockName, execute="$runOnRequestEnd", executeArgs=arguments, type="readOnly", timeout=180);
		if (application.wheels.showDebugInformation && StructKeyExists(request.wheels, "showDebugInformation") && request.wheels.showDebugInformation)
		{
			$includeAndOutput(template="wheels/events/onrequestend/debug.cfm");
		}
	</cfscript>
</cffunction>

<cffunction name="$runOnRequestEnd" returntype="void" access="public" output="false">
	<cfargument name="targetpage" type="any" required="true">
	<cfscript>
		if (application.wheels.showDebugInformation)
		{
			$debugPoint("requestEnd");
		}
		$include(template="#application.wheels.eventPath#/onrequestend.cfm");
		if (application.wheels.showDebugInformation)
		{
			$debugPoint("requestEnd,total");
		}
	</cfscript>
</cffunction>
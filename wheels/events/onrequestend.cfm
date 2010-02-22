<cffunction name="onRequestEnd" returntype="void" access="public" output="true">
	<cfargument name="targetpage" type="any" required="true">
	<cfscript>
		$simpleLock(execute="$runOnRequestEnd", executeArgs=arguments, name="wheelsReloadLock", type="readOnly");
		if (application.wheels.showDebugInformation && StructKeyExists(request.wheels, "showDebugInformation") && request.wheels.showDebugInformation)
		{
			$includeAndOutput(template="wheels/events/onrequestend/debug.cfm");
		}
	</cfscript>
</cffunction>

<cffunction name="$runOnRequestEnd" returntype="void" access="public" output="false">
	<cfargument name="targetpage" type="any" required="true">
	<cfscript>
		// commit any outstanding transactions
		if (request.wheels.transactionOpen)
			application.wheels.adapter.$commitTransaction();
		if (application.wheels.showDebugInformation)
			$debugPoint("requestEnd");
		$include(template="#application.wheels.eventPath#/onrequestend.cfm");
		if (application.wheels.showDebugInformation)
			$debugPoint("requestEnd,total");
	</cfscript>
</cffunction>
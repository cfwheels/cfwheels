<cffunction name="onSessionEnd" returntype="void" access="public" output="false">
	<cfargument name="sessionScope" type="any" required="true">
	<cfargument name="applicationScope" type="any" required="true">
	<cfscript>
		var loc = {};
		loc.lockName = "reloadLock" & application.applicationName;
		$simpleLock(name=loc.lockName, execute="$runOnSessionEnd", executeArgs=arguments, type="readOnly", timeout=180);
	</cfscript>
</cffunction>

<cffunction name="$runOnSessionEnd" returntype="void" access="public" output="false">
	<cfargument name="sessionScope" type="any" required="true">
 	<cfargument name="applicationScope" type="any" required="true">
	<cfscript>
		$include(template="#arguments.applicationScope.wheels.eventPath#/onsessionend.cfm", argumentCollection=arguments);
	</cfscript>
</cffunction>
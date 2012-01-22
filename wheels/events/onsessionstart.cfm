<cffunction name="onSessionStart" returntype="void" access="public" output="false">
	<cfscript>
		$simpleLock(execute="$runOnSessionStart", name="wheelsReloadLock", type="readOnly", timeout=180);
	</cfscript>
</cffunction>

<cffunction name="$runOnSessionStart" returntype="void" access="public" output="false">
	<cfscript>
		$initializeRequestScope();
		$loadPluginEvents('onsessionstart');
		$include(template="#application.wheels.eventPath#/onsessionstart.cfm");
	</cfscript>
</cffunction>
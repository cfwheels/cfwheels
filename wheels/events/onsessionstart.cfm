<cffunction name="onSessionStart" returntype="void" access="public" output="false">
	<cfscript>
		if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "eventPath"))
			$include(template="#application.wheels.eventPath#/beforeonsessionstart.cfm");
		$simpleLock(execute="$runOnSessionStart", name="wheels", type="readOnly");
	</cfscript>
</cffunction>

<cffunction name="$runOnSessionStart" returntype="void" access="public" output="false">
	<cfscript>
		$include(template="#application.wheels.eventPath#/onsessionstart.cfm");
	</cfscript>
</cffunction>
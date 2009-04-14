<cffunction name="onSessionEnd" returntype="void" access="public" output="false">
	<cfargument name="sessionscope" type="any" required="true">
  <cfargument name="applicationscope" type="any" required="true">
	<cfscript>
		$simpleLock(execute="$runOnSessionEnd", executeArgs=arguments, scope="application", type="readOnly");
	</cfscript>
</cffunction>

<cffunction name="$runOnSessionEnd" returntype="void" access="public" output="false">
	<cfargument name="sessionscope" type="any" required="true">
  <cfargument name="applicationscope" type="any" required="true">
	<cfscript>
		var loc = {};
		$include(template="#application.wheels.eventPath#/onsessionend.cfm");
	</cfscript>
</cffunction>
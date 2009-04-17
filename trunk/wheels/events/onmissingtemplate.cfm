<cffunction name="onMissingTemplate" returntype="void" access="public" output="true">
	<cfargument name="targetpage" type="any" required="true">
	<cfscript>
		$simpleLock(execute="$runOnMissingTemplate", executeArgs=arguments, scope="application", type="readOnly");
	</cfscript>
</cffunction>

<cffunction name="$runOnMissingTemplate" returntype="void" access="public" output="true">
	<cfargument name="targetpage" type="any" required="true">
	<cfscript>
		$header(statusCode=404, statustext="Not Found");
		$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
	</cfscript>
</cffunction>
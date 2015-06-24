<cffunction name="onApplicationEnd" returntype="void" access="public" output="false">
	<cfargument name="applicationScope" type="struct" required="true">
	<cfscript>
		$include(template="#arguments.applicationScope.wheels.eventPath#/onapplicationend.cfm", argumentCollection=arguments);
	</cfscript>
</cffunction>
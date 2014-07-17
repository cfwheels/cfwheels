<cffunction name="onApplicationEnd" returntype="void" access="public" output="false">
	<cfargument name="applicationScope" type="struct" required="true">
	<cfscript>
		$include(template="#arguments.applicationscope.wheels.eventPath#/onapplicationend.cfm", argumentCollection=arguments);
	</cfscript>
</cffunction>
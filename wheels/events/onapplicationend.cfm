<cffunction name="onApplicationEnd" returntype="void" access="public" output="false">
	<cfargument name="applicationscope" type="struct" required="true">
	<cfscript>
		$loadPluginEvents('onapplicationend');
		$include(template="#arguments.applicationscope.wheels.eventPath#/onapplicationend.cfm");
	</cfscript>
</cffunction>
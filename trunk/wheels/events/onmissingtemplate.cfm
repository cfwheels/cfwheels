<cffunction name="onMissingTemplate" output="true">
	<cfargument name="targetpage">
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="../../#application.wheels.eventPath#/onmissingtemplate.cfm">
	</cflock>
</cffunction>

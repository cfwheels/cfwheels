<cffunction name="onMissingTemplate" output="true">
	<cfargument name="targetpage">
	<cfheader statuscode="404" statustext="Not Found">
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="../../#application.wheels.eventPath#/onmissingtemplate.cfm">
	</cflock>
</cffunction>

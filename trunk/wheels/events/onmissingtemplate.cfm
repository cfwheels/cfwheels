<cffunction name="onMissingTemplate" output="true">
	<cfargument name="targetpage">	
	<cflock scope="application" type="readonly" timeout="30">
		<cfheader statuscode="404" statustext="Not Found">
		<cfinclude template="../../#application.wheels.eventPath#/onmissingtemplate.cfm">
	</cflock>
</cffunction>

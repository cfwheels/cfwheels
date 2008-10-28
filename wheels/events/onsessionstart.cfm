<cffunction name="onSessionStart" output="false">
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="../../#application.wheels.eventPath#/onsessionstart.cfm">
	</cflock>
</cffunction>

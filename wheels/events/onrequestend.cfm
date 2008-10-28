<cffunction name="onRequestEnd" output="true">
	<cfargument name="targetpage">
	<cfset var loc = {}>
	<cflock scope="application" type="readonly" timeout="30">
		<cfif application.settings.showDebugInformation>
			<cfset request.wheels.execution.components.requestEnd = getTickCount()>
		</cfif>
		<cfinclude template="../../#application.wheels.eventPath#/onrequestend.cfm">
		<cfif application.settings.showDebugInformation>
			<cfset request.wheels.execution.components.requestEnd = GetTickCount() - request.wheels.execution.components.requestEnd>
		</cfif>
		<cfinclude template="onrequestend/debug.cfm">
	</cflock>
</cffunction>

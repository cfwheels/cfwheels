<cffunction name="onSessionEnd" output="false">
	<cfargument name="sessionscope">
  <cfargument name="applicationscope">
	<cflock scope="application" type="readonly" timeout="30">
		<cfinclude template="../../#arguments.applicationscope.wheels.eventPath#/onsessionend.cfm">
	</cflock>
</cffunction>
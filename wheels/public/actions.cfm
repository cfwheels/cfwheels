<cfif get("environment") IS "production">
	<cfabort>
</cfif>

<cffunction name="congratulations">
	<cfset version = application.wheels.version>
	<cfset renderPage(template="wheels")>
</cffunction>

<cffunction name="plugins">
	<cfset variables[params.name] = application.wheels.plugins[params.name]>
	<cfset renderPage(template="wheels")>
</cffunction>

<cffunction name="tests">
	<cfset testresults = $createObjectFromRoot(path=application.wheels.wheelsComponentPath, fileName="test", method="WheelsRunner", options=params)>
	<cfset renderPage(template="wheels")>
</cffunction>
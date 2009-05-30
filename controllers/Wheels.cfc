<!---
	This is a controller file that Wheels uses internally.
	Do not delete this file.
--->
<cfcomponent extends="Controller">

	<cffunction name="congratulations">
		<cfset version = application.wheels.version>
	</cffunction>
	
	<cffunction name="tests">
		<cfif get("environment") IS "production">
			<cfset redirectTo(route="home")>
		</cfif>
		
		<cfset testresults = $createObjectFromRoot(
			path=application.wheels.wheelsComponentPath
			,fileName="test"
			,method="WheelsRunner"
			,options=params
		)>
	</cffunction>

	<cffunction name="plugins">
		<cfif get("environment") IS "production">
			<cfset renderNothing()>
		</cfif>
	</cffunction>

</cfcomponent>
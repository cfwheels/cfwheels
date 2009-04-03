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
			<cfset renderNothing()>
		</cfif>			
	</cffunction>

	<cffunction name="plugins">
		<cfif get("environment") IS "production">
			<cfset renderNothing()>
		</cfif>
	</cffunction>

</cfcomponent>
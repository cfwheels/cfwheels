<cffunction name="setup">
	<cfset structDelete(request.wheels, "response", false)>
	<cfset $$oldViewPath = application.wheels.viewPath>
	<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
</cffunction>

<cffunction name="teardown">
	<cfset application.wheels.viewPath = $$oldViewPath>
</cffunction>
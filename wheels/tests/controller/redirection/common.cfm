<cfinclude template="/wheelsMapping/global/functions.cfm">

<cffunction name="setup">
	<cfset $$oldCGIScope = request.cgi>
	<cfset $$oldViewPath = application.wheels.viewPath>
	<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
</cffunction>

<cffunction name="teardown">
	<cfset request.cgi = $$oldCGIScope>
	<cfset application.wheels.viewPath = $$oldViewPath>
	<cfset StructDelete(request.wheels, "redirect", false)>
</cffunction>
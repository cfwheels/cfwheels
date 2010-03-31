<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="test", action="test"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="test_x">
		<cfset assert("1 IS 1")>
	</cffunction>

</cfcomponent>
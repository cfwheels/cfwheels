<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy").$createControllerObject({controller="test",action="test"})>

	<cffunction name="test_x">
		<cfset assert("1 IS 1")>
	</cffunction>

</cfcomponent>
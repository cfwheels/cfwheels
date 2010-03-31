<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy").$createControllerObject({controller="dummy",action="dummy"})>

	<cffunction name="test_flashCount_valid">
		<cfset session.flash = {}>
		<cfset session.flash.success = "Congrats!">
		<cfset session.flash.anotherKey = "Test!">
		<cfset result = controller.flashCount()>
		<cfset compare = StructCount(session.flash)>
		<cfset assert("result IS compare")>
	</cffunction>
	
</cfcomponent>

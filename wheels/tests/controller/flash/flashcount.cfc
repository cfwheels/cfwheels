<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="test_flashCount_valid">
		<cfset session.flash = {}>
		<cfset session.flash.success = "Congrats!">
		<cfset session.flash.anotherKey = "Test!">
		<cfset result = controller.flashCount()>
		<cfset compare = StructCount(session.flash)>
		<cfset assert("result IS compare")>
	</cffunction>
	
</cfcomponent>

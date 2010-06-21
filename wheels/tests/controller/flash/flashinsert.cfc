<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset flashStorage = application.wheels.flashStorage>
		<cfset application.wheels.flashStorage = "cookie">
	</cffunction>

	<cffunction name="test_flashInsert_valid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset assert("controller.flash('success') IS 'Congrats!'")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.flashStorage = flashStorage>
	</cffunction>

</cfcomponent>

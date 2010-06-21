<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset flashStorage = application.wheels.flashStorage>
		<cfset application.wheels.flashStorage = "cookie">
	</cffunction>

	<cffunction name="test_flash_key_exists">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset loc.r = controller.flashKeyExists("success")>
		<cfset assert("loc.r IS true")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.flashStorage = flashStorage>
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset flashStorage = application.wheels.flashStorage>
		<cfset application.wheels.flashStorage = "cookie">
	</cffunction>

	<cffunction name="test_flashIsEmpty_valid">
		<cfset controller.flashClear()>
		<cfset result = controller.flashIsEmpty()>
		<cfset assert("result IS true")>
	</cffunction>
	
	<cffunction name="test_flashIsEmpty_invalid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset result = controller.flashIsEmpty()>
		<cfset assert("result IS false")>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset application.wheels.flashStorage = flashStorage>
	</cffunction>

</cfcomponent>
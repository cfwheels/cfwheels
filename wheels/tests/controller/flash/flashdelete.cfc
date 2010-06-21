<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset flashStorage = application.wheels.flashStorage>
		<cfset application.wheels.flashStorage = "cookie">
	</cffunction>

	<cffunction name="test_flashDelete_invalid">
		<cfset controller.flashClear()>
		<cfset result = controller.flashDelete(key="success")>
		<cfset assert("result IS false")>
	</cffunction>
	
	<cffunction name="test_flashDelete_valid">
		<cfset controller.flashClear()>
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset result = controller.flashDelete(key="success")>
		<cfset assert("result IS true")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.flashStorage = flashStorage>
	</cffunction>

</cfcomponent>

<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset flashStorage = application.wheels.flashStorage>
		<cfset application.wheels.flashStorage = "cookie">
	</cffunction>

	<cffunction name="test_flashClear_valid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashClear()>
		<cfset result = StructKeyList(controller.flash())>
		<cfset assert("result IS ''")>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset application.wheels.flashStorage = flashStorage>
	</cffunction>

</cfcomponent>

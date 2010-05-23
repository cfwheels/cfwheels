<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="test_flashClear_valid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashClear()>
		<cfset result = StructKeyList(controller.flash())>
		<cfset assert("result IS ''")>
	</cffunction>
	
</cfcomponent>

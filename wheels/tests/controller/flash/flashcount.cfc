<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="test_flashCount_valid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashInsert(anotherKey="Test!")>
		<cfset result = controller.flashCount()>
		<cfset compare = controller.flashCount()>
		<cfset assert("result IS compare")>
	</cffunction>

</cfcomponent>

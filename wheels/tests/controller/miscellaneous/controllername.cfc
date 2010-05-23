<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>	
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="test_x">
	</cffunction>

</cfcomponent>
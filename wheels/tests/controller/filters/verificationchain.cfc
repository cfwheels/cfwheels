<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>	
	<cfset controller = $controller(name="dummy").new(params)>

	<cffunction name="test_x">
	</cffunction>

</cfcomponent>
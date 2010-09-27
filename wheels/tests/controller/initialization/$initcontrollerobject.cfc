<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>	
	<cfset loc.controller = controller(name="dummy").new(params)>

	<cffunction name="test_x">
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="dummy", action="dummy"}>	
	<cfset loc.controller = controller("dummy", params)>

	<cffunction name="test_x">
	</cffunction>

</cfcomponent>
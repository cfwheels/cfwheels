<cfcomponent extends="wheelsMapping.Test">
	
	<cfset params = {controller="nested.test", action="dummy"}>	
	<cfset loc.controller = controller("nested.test", params)>

	<cffunction name="test_x">
	</cffunction>

</cfcomponent>
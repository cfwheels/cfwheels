<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_can_access_variables_scope_of_objects">
		<cfset params = {controller="dummy", action="dummy"}>
		<cfset loc.controller = controller("dummy", params)>
		<cfset assert('StructKeyExists(loc.controller, "$inspect")')>
		<cfset loc.controllerInstance = loc.controller.$inspect()>
		<cfset StructKeyExists(loc.controllerInstance, "class")>
	</cffunction>

</cfcomponent>
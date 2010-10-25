<cfcomponent extends="wheelsMapping.Test">
	
	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller("dummy", params)>
	
	<cffunction name="setup">
		<cfset request.wheels["myhandle"] = {test="true"}>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset structdelete(request.wheels, "myhandle", false)>
	</cffunction>

	<cffunction name="test_pagination_handle_exists">
		<cfset loc.r = loc.controller.pagination('myhandle')>
		<cfset assert('isstruct(loc.r)')>
		<cfset assert('structkeyexists(loc.r, "test")')>
		<cfset assert('loc.r.test eq true')>
	</cffunction>
	
	<cffunction name="test_pagination_handle_does_not_exists">
		<cfset loc.e = "Wheels.QueryHandleNotFound">
		<cfset loc.r = raised('loc.controller.pagination("someotherhandle")')>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>
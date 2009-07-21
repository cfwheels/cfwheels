<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
	</cffunction>
	
	<cffunction name="setup">
		<cfset loc = {}>
	</cffunction>

	<cffunction name="test_table_not_found">
		<cfset loc.e = raised("global.controller.model('InvalidModel')")>
		<cfset halt(false, "loc.e")>
		<cfset loc.r = "Wheels.TableNotFound">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
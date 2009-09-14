<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.Controller")>

	<cffunction name="test_table_not_found">
		<cfset loc.e = raised("loc.controller.model('InvalidModel')")>
		<cfset halt(false, "loc.e")>
		<cfset loc.r = "Wheels.TableNotFound">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
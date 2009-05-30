<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerBlank")>
	</cffunction>

	<cffunction name="test_table_not_found">
		<cfset loc = {}>
		<cfset loc.e = raised("controller.model('InvalidModel')")>
		<cfset halt(false, "loc.e")>
		<cfset loc.r = "Wheels.TableNotFound">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
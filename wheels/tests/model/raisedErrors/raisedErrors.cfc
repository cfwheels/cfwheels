<cfcomponent extends="wheelsMapping.test">

	<cffunction name="_setup">
		<cfset global.env = duplicate(application.wheels)>
		<cfset application.wheels.modelPath = "/wheelsMapping">
		<cfset application.wheels.modelComponentPath = "wheelsMapping">
		<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	</cffunction>
	
	<cffunction name="_teardown">
		<cfset application.wheels = duplicate(global.env)>
	</cffunction>

	<cffunction name="test_table_not_found">
		<cfset loc.e = raised("loc.controller.model('table_not_found')")>
		<cfset halt(false, "loc.e")>
		<cfset loc.r = "Wheels.TableNotFound">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
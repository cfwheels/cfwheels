<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfif StructKeyExists(request, "test")>
			<cfset StructDelete(request, "test")>
		</cfif>
		<cfset oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
		<cfset application.wheels.existingHelperFiles = "test">
		<cfset params = {controller="test", action="helperCaller"}>
		<cfset loc.controller = controller("test", params)>
	</cffunction>
	
	<cffunction name="test_inclusion_of_global_helper_file">
		<cfset loc.controller.renderView()>
		<cfset assert("StructKeyExists(request.test, 'globalHelperFunctionWasCalled')")>
	</cffunction>
	
	<cffunction name="test_inclusion_of_controller_helper_file">
		<cfset loc.controller.renderView()>
		<cfset assert("StructKeyExists(request.test, 'controllerHelperFunctionWasCalled')")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.viewPath = oldViewPath>
		<cfset application.wheels.existingHelperFiles = "">
	</cffunction>

</cfcomponent>

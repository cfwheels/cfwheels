<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerWithModel")>
		<cfset modelusers = controller.model("ModelUsers")>
	</cffunction>

	<cffunction name="test_class_data_is_populated_without_new_call">
		<cfset loc = {}>
		<cfset halt(false, "modelusers.$classData()")>
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").new(params)>

	<cffunction name="test_provides_sets_controller_class_data">
		<cfset formats = "json,xml,csv">
		<cfset controller.provides(formats=formats) />
		<cfset assert('controller.$getControllerClassData().formats.default eq "html,#formats#"')>
	</cffunction>

	<cffunction name="test_onlyProvides_sets_controller_class_data">
		<cfset formats = "html">
		<cfset controller.onlyProvides(formats="html") />
		<cfset assert('controller.$getControllerClassData().formats.actions.dummy eq formats')>
	</cffunction>

</cfcomponent>
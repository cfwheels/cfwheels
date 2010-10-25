<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller("dummy", params)>

	<cffunction name="test_provides_sets_controller_class_data">
		<cfset formats = "json,xml,csv">
		<cfset loc.controller.provides(formats=formats) />
		<cfset assert('loc.controller.$getControllerClassData().formats.default eq "html,#formats#"')>
	</cffunction>

	<cffunction name="test_onlyProvides_sets_controller_class_data">
		<cfset formats = "html">
		<cfset loc.controller.onlyProvides(formats="html") />
		<cfset assert('loc.controller.$getControllerClassData().formats.actions.dummy eq formats')>
	</cffunction>

</cfcomponent>
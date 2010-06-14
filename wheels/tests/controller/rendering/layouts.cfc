<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="test", action="test"}>
	<cfset controller = $controller(name="test").$createControllerObject(params)>
	
	<cffunction name="test_rendering_without_layout">
		<cfset controller.renderPage(layout=false)>
		<cfset assert("request.wheels.response IS 'view template content'")>
	</cffunction>

	<cffunction name="test_rendering_with_default_layout_in_controller_folder">
		<cfset tempFile = Replace(Replace(GetCurrentTemplatePath(), "\", "/", "all"), "controller/rendering/layouts.cfc", "_assets/views/test/layout.cfm")>
		<cffile action="write" output="<cfoutput>start:controllerlayout##contentForLayout()##end:controllerlayout</cfoutput>" file="#tempFile#">
		<cfset application.wheels.existingLayoutFiles = "test">
		<cfset controller.renderPage()>
		<cfset assert("request.wheels.response Contains 'view template content' AND request.wheels.response Contains 'start:controllerlayout' AND request.wheels.response Contains 'end:controllerlayout'")>
		<cfset application.wheels.existingLayoutFiles = "">
		<cffile action="delete" file="#tempFile#">
	</cffunction>

	<cffunction name="test_rendering_with_default_layout_in_root">
		<cfset controller.renderPage()>
		<cfset assert("request.wheels.response Contains 'view template content' AND request.wheels.response Contains 'start:defaultlayout' AND request.wheels.response Contains 'end:defaultlayout'")>
	</cffunction>

	<cffunction name="test_rendering_with_specific_layout">
		<cfset controller.renderPage(layout="specificLayout")>
		<cfset assert("request.wheels.response Contains 'view template content' AND request.wheels.response Contains 'start:specificlayout' AND request.wheels.response Contains 'end:specificlayout'")>
	</cffunction>

	<cffunction name="test_removing_cfm_file_extension_when_supplied">
		<cfset controller.renderPage(layout="specificLayout.cfm")>
		<cfset assert("request.wheels.response Contains 'view template content' AND request.wheels.response Contains 'start:specificlayout' AND request.wheels.response Contains 'end:specificlayout'")>
	</cffunction>

	<cffunction name="test_rendering_with_specific_layout_in_root">
		<cfset controller.renderPage(layout="/rootLayout")>
		<cfset assert("request.wheels.response Contains 'view template content' AND request.wheels.response Contains 'start:rootlayout' AND request.wheels.response Contains 'end:rootlayout'")>
	</cffunction>

	<cffunction name="test_rendering_with_specific_layout_in_sub_folder">
		<cfset controller.renderPage(layout="sub/layout")>
		<cfset assert("request.wheels.response Contains 'view template content' AND request.wheels.response Contains 'start:sublayout' AND request.wheels.response Contains 'end:sublayout'")>
	</cffunction>

	<cffunction name="test_rendering_with_specific_layout_from_folder_path">
		<cfset controller.renderPage(layout="/shared/layout")>
		<cfset assert("request.wheels.response Contains 'view template content' AND request.wheels.response Contains 'start:sharedlayout' AND request.wheels.response Contains 'end:sharedlayout'")>
	</cffunction>

	<cffunction name="test_view_variable_should_be_available_in_layout_file">
		<cfset controller.$callAction(action="test")>
		<cfset controller.renderPage()>
		<cfset assert("request.wheels.response Contains 'view template content' AND request.wheels.response Contains 'variableForLayoutContent' AND request.wheels.response Contains 'start:defaultlayout' AND request.wheels.response Contains 'end:defaultlayout'")>
	</cffunction>

	<cffunction name="test_rendering_partial_with_layout">
		<cfset controller.renderPartial(partial="partialTemplate", layout="partialLayout")>
		<cfset assert("request.wheels.response Contains 'partial template content' AND request.wheels.response Contains 'start:partiallayout' AND request.wheels.response Contains 'end:partiallayout'")>
	</cffunction>

	<cffunction name="test_rendering_partial_with_specific_layout_in_root">
		<cfset controller.renderPartial(partial="partialTemplate", layout="/partialRootLayout")>
		<cfset assert("request.wheels.response Contains 'partial template content' AND request.wheels.response Contains 'start:partialrootlayout' AND request.wheels.response Contains 'end:partialrootlayout'")>
	</cffunction>

</cfcomponent>
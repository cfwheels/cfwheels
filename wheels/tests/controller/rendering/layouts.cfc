<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="test", action="test"}>
	<cfset loc.controller = controller("test", params)>

	<cffunction name="test_rendering_without_layout">
		<cfset loc.controller.renderView(layout=false)>
		<cfset assert("loc.controller.response() IS 'view template content'")>
	</cffunction>

	<cffunction name="test_rendering_with_default_layout_in_controller_folder">
		<cfset tempFile = expandPath("/wheelsMapping/tests/_assets/views/test/layout.cfm")>
		<cffile action="write" output="<cfoutput>start:controllerlayout##includeContent()##end:controllerlayout</cfoutput>" file="#tempFile#">
		<cfset application.wheels.existingLayoutFiles = "test">
		<cfset loc.controller.renderView()>
		<cfset loc.r = loc.controller.response()>
		<cfset assert("loc.r Contains 'view template content' AND loc.r Contains 'start:controllerlayout' AND loc.r Contains 'end:controllerlayout'")>
		<cfset application.wheels.existingLayoutFiles = "">
		<cffile action="delete" file="#tempFile#">
	</cffunction>

	<cffunction name="test_rendering_with_default_layout_in_root">
		<cfset loc.controller.renderView()>
		<cfset loc.r = loc.controller.response()>
		<cfset assert("loc.r Contains 'view template content' AND loc.r Contains 'start:defaultlayout' AND loc.r Contains 'end:defaultlayout'")>
	</cffunction>

	<cffunction name="test_rendering_with_specific_layout">
		<cfset loc.controller.renderView(layout="specificLayout")>
		<cfset loc.r = loc.controller.response()>
		<cfset assert("loc.r Contains 'view template content' AND loc.r Contains 'start:specificlayout' AND loc.r Contains 'end:specificlayout'")>
	</cffunction>

	<cffunction name="test_removing_cfm_file_extension_when_supplied">
		<cfset loc.controller.renderView(layout="specificLayout.cfm")>
		<cfset loc.r = loc.controller.response()>
		<cfset assert("loc.r Contains 'view template content' AND loc.r Contains 'start:specificlayout' AND loc.r Contains 'end:specificlayout'")>
	</cffunction>

	<cffunction name="test_rendering_with_specific_layout_in_root">
		<cfset loc.controller.renderView(layout="/rootLayout")>
		<cfset loc.r = loc.controller.response()>
		<cfset assert("loc.r Contains 'view template content' AND loc.r Contains 'start:rootlayout' AND loc.r Contains 'end:rootlayout'")>
	</cffunction>

	<cffunction name="test_rendering_with_specific_layout_in_sub_folder">
		<cfset loc.controller.renderView(layout="sub/layout")>
		<cfset loc.r = loc.controller.response()>
		<cfset assert("loc.r Contains 'view template content' AND loc.r Contains 'start:sublayout' AND loc.r Contains 'end:sublayout'")>
	</cffunction>

	<cffunction name="test_rendering_with_specific_layout_from_folder_path">
		<cfset loc.controller.renderView(layout="/shared/layout")>
		<cfset loc.r = loc.controller.response()>
		<cfset assert("loc.r Contains 'view template content' AND loc.r Contains 'start:sharedlayout' AND loc.r Contains 'end:sharedlayout'")>
	</cffunction>

	<cffunction name="test_view_variable_should_be_available_in_layout_file">
		<cfset loc.controller.$callAction(action="test")>
		<cfset loc.controller.renderView()>
		<cfset loc.r = loc.controller.response()>
		<cfset assert("loc.r Contains 'view template content' AND loc.r Contains 'variableForLayoutContent' AND loc.r Contains 'start:defaultlayout' AND loc.r Contains 'end:defaultlayout'")>
	</cffunction>

	<cffunction name="test_rendering_partial_with_layout">
		<cfset loc.controller.renderPartial(partial="partialTemplate", layout="partialLayout")>
		<cfset loc.r = loc.controller.response()>
		<cfset assert("loc.r Does Not Contain 'view template content' AND loc.r Contains 'partial template content' AND loc.r Contains 'start:partiallayout' AND loc.r Contains 'end:partiallayout'")>
	</cffunction>

	<cffunction name="test_rendering_partial_with_specific_layout_in_root">
		<cfset loc.controller.renderPartial(partial="partialTemplate", layout="/partialRootLayout")>
		<cfset loc.r = loc.controller.response()>
		<cfset assert("loc.r Contains 'partial template content' AND loc.r Contains 'start:partialrootlayout' AND loc.r Contains 'end:partialrootlayout'")>
	</cffunction>

</cfcomponent>
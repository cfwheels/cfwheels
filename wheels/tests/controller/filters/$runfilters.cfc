<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="filtering", action="index"}>	
	<cfset loc.controller = controller("filtering", params)>

	<cffunction name="setup">
		<cfset request.filterTests = StructNew()>
	</cffunction>

	<cffunction name="test_should_run_public">
		<cfset loc.controller.$runFilters(type="before", action="index")>
		<cfset assert("StructKeyExists(request.filterTests, 'pubTest')")>
	</cffunction>

	<cffunction name="test_should_run_private">
		<cfset loc.controller.$runFilters(type="before", action="index")>
		<cfset assert("StructKeyExists(request.filterTests, 'privTest')")>
	</cffunction>

	<cffunction name="test_should_run_in_order">
		<cfset loc.controller.$runFilters(type="before", action="index")>
		<cfset assert("request.filterTests.test IS 'bothpubpriv'")>
	</cffunction>

	<cffunction name="test_should_not_run_excluded">
		<cfset loc.controller.$runFilters(type="before", action="doNotRun")>
		<cfset assert("NOT StructKeyExists(request.filterTests, 'dirTest')")>
	</cffunction>

	<cffunction name="test_should_run_included_only">
		<cfset loc.controller.$runFilters(type="before", action="doesNotExist")>
		<cfset assert("NOT StructKeyExists(request.filterTests, 'pubTest')")>
	</cffunction>

	<cffunction name="test_should_pass_direct_arguments">
		<cfset loc.controller.$runFilters(type="before", action="index")>
		<cfset assert("request.filterTests.dirTest IS 1")>
	</cffunction>

	<cffunction name="test_should_pass_struct_arguments">
		<cfset loc.controller.$runFilters(type="before", action="index")>
		<cfset assert("request.filterTests.strTest IS 21")>
	</cffunction>

	<cffunction name="test_should_pass_both_direct_and_struct_arguments">
		<cfset loc.controller.$runFilters(type="before", action="index")>
		<cfset assert("request.filterTests.bothTest IS 31")>
	</cffunction>

	<cffunction name="test_should_skip_remaining_on_false">
	</cffunction>

	<cffunction name="test_should_skip_remaining_and_not_render_when_already_rendered">
	</cffunction>

	<cffunction name="test_should_run_parent">
	</cffunction>

	<cffunction name="test_should_run_parent_and_current_in_order">
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="filtering").$createControllerObject({controller="filtering",action="index"})>

	<cffunction name="setup">
		<cfset request.filterTests = StructNew()>
	</cffunction>

	<cffunction name="test_should_run_public">
		<cfset controller.$runFilters(type="before", action="index")>
		<cfset assert("StructKeyExists(request.filterTests, 'pubTest')")>
	</cffunction>

	<cffunction name="test_should_run_private">
		<cfset controller.$runFilters(type="before", action="index")>
		<cfset assert("StructKeyExists(request.filterTests, 'privTest')")>
	</cffunction>

	<cffunction name="test_should_run_in_order">
		<cfset controller.$runFilters(type="before", action="index")>
		<cfset assert("request.filterTests.test IS 'bothpubpriv'")>
	</cffunction>

	<cffunction name="test_should_not_run_excluded">
		<cfset controller.$runFilters(type="before", action="doNotRun")>
		<cfset assert("NOT StructKeyExists(request.filterTests, 'dirTest')")>
	</cffunction>

	<cffunction name="test_should_run_included_only">
		<cfset controller.$runFilters(type="before", action="doesNotExist")>
		<cfset assert("NOT StructKeyExists(request.filterTests, 'pubTest')")>
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params.controller = "filtering">
	<cfset params.action = "index">
	<cfset controller = $controller(controllerName="filtering", controllerPath="wheels/tests/_assets/controllers").$createControllerObject(params)> 

	<cffunction name="test_should_run_public">
		<cfset request.filterTests = {}>
		<cfset controller.$runFilters(type="before", action="index")>
		<cfset assert("StructKeyExists(request.filterTests, 'pubTest')")>
	</cffunction>

	<cffunction name="test_should_run_private">
		<cfset request.filterTests = {}>
		<cfset controller.$runFilters(type="before", action="index")>
		<cfset assert("StructKeyExists(request.filterTests, 'privTest')")>
	</cffunction>

	<cffunction name="test_should_run_in_order">
		<cfset request.filterTests = {}>
		<cfset controller.$runFilters(type="before", action="index")>
		<cfset assert("request.filterTests.test IS 'bothpubpriv'")>
	</cffunction>

	<cffunction name="test_should_not_run_excluded">
		<cfset request.filterTests = {}>
		<cfset controller.$runFilters(type="before", action="doNotRun")>
		<cfset assert("NOT StructKeyExists(request.filterTests, 'dirTest')")>
	</cffunction>

	<cffunction name="test_should_run_included_only">
		<cfset request.filterTests = {}>
		<cfset controller.$runFilters(type="before", action="doesNotExist")>
		<cfset assert("NOT StructKeyExists(request.filterTests, 'pubTest')")>
	</cffunction>

</cfcomponent>
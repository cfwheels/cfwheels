<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="filtering", action="index"}>	
	<cfset controller = $controller(name="filtering").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset request.filterTests = StructNew()>
	</cffunction>

	<cffunction name="test_should_pass_direct_arguments">
		<cfset controller.$runFilters(type="before", action="index")>
		<cfset assert("request.filterTests.dirTest IS 1")>
	</cffunction>

	<cffunction name="test_should_pass_struct_arguments">
		<cfset controller.$runFilters(type="before", action="index")>
		<cfset assert("request.filterTests.strTest IS 21")>
	</cffunction>

	<cffunction name="test_should_pass_both_direct_and_struct_arguments">
		<cfset controller.$runFilters(type="before", action="index")>
		<cfset assert("request.filterTests.bothTest IS 31")>
	</cffunction>

</cfcomponent>
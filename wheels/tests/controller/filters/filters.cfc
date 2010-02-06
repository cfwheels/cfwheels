<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_access_public_methods">
		<cfset loc.params.controller = "test">
		<cfset loc.params.action = "s">
		<cfset loc.controller = $controller("filterTestPublic").$createControllerObject(loc.params)>
		<cfset loc.controller.$runFilters(type="before", action="index")>
		<cfset assert("StructKeyExists(request, 'filterTestPublic') AND request.filterTestPublic")>
		<cfset StructDelete(request, "filterTestPublic")>
	</cffunction>

	<cffunction name="test_access_private_methods">
		<cfset loc.params.controller = "test">
		<cfset loc.params.action = "s">
		<cfset loc.controller = $controller("filterTestPrivate").$createControllerObject(loc.params)>
		<cfset loc.controller.$runFilters(type="before", action="index")>
		<cfset assert("StructKeyExists(request, 'filterTestPrivate') AND request.filterTestPrivate")>
		<cfset StructDelete(request, "filterTestPrivate")>
	</cffunction>

</cfcomponent>

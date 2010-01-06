<cfcomponent extends="wheelsMapping.test">

	<cfset global.dispatcher = createobject("component", "wheelsMapping.Dispatch") />

	<cffunction name="test_access_public_methods">
		<cfset loc.controller = createobject("component", "wheelsMapping.tests._assets.controllers.FilterTestPublic").$initControllerClass() />
		<cfset loc.controller.filters("filterTestPublic")>
		<cfset loc.dispatcher.$runFilters(controller=loc.controller, actionname="index", type="before")>
		<cfset loc.e = "Pass">
		<cfset loc.r = trim(request.wheels.response)>
		<cfset halt(false, 'request.wheels.response')>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_access_private_methods">
		<cfset loc.controller = createobject("component", "wheelsMapping.tests._assets.controllers.FilterTestPrivate").$initControllerClass() />
		<cfset loc.controller.filters("filterTestPrivate")>
		<cfset loc.dispatcher.$runFilters(controller=loc.controller, actionname="index", type="before")>
		<cfset loc.e = "Pass">
		<cfset loc.r = trim(request.wheels.response)>
		<cfset halt(false, 'request.wheels.response')>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>

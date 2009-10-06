<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.controller") />
	
	<cffunction name="test_flashIsEmpty_valid">
		<cfset session.flash = {} />
		<cfset loc.e = loc.controller.flashIsEmpty() />
		<cfset loc.r = StructIsEmpty(session.flash) />
		<cfset assert("loc.e eq loc.r") />
	</cffunction>
	
	<cffunction name="test_flashIsEmpty_invalid">
		<cfset session.flash = {success="congrats!"} />
		<cfset loc.e = loc.controller.flashIsEmpty() />
		<cfset loc.r = StructIsEmpty(session.flash) />
		<cfset assert("loc.e eq loc.r") />
	</cffunction>
	
</cfcomponent>

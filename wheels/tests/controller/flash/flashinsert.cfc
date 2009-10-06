<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.controller") />
	
	<cffunction name="test_flashInsert_valid">
		<cfset session.flash = {} />
		<cfset loc.e = "congrats!" />
		<cfset loc.controller.flashInsert(success=loc.e) />
		<cfset loc.r = session.flash.success />
		<cfset assert("loc.e eq loc.r") />
	</cffunction>
	
</cfcomponent>

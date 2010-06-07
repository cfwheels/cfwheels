<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")/>
	</cffunction>
	
	<cffunction name="test_flashCount_valid">
		<cfset session.flash = {} />
		<cfset session.flash.success = "congrats!" />
		<cfset loc.count = loc.controller.flashCount() />
		<cfset loc.sessionCount = StructCount(session.flash) />
		<cfset assert("loc.count eq loc.sessionCount") />
	</cffunction>
	
</cfcomponent>

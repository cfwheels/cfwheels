<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")/>
	</cffunction>
	
	<cffunction name="test_flashDelete_invalid">
		<cfset session.flash = {} />
		<cfset loc.e = loc.controller.flashDelete(key='success') />
		<cfset loc.r = "NO" />
		<cfset assert("loc.e eq loc.r") />
	</cffunction>
	
	<cffunction name="test_flashDelete_valid">
		<cfset session.flash = {} />
		<cfset loc.controller.flashInsert(success="congrats!") />
		<cfset loc.e = loc.controller.flashDelete(key="success") />
		<cfset loc.r = "YES" />
		<cfset assert("loc.e eq loc.r") />
	</cffunction>
	
</cfcomponent>

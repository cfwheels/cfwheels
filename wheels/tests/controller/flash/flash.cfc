<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_flash_get_struct_key_valid">
		<cfset session.flash = {} />
		<cfset session.flash.success = "congrats!" />
		<cfset loc.success = loc.controller.flash("success") />
		<cfset assert("session.flash.success eq loc.success") />
	</cffunction>
	
	<cffunction name="test_flash_get_struct_valid">
		<cfset session.flash = {} />
		<cfset session.flash.success = "congrats!" />
		<cfset loc.sessionFlash = loc.controller.$hashStruct(session.flash) />
		<cfset loc.flash = loc.controller.$hashStruct(loc.controller.flash()) />
		<cfset assert("loc.sessionFlash eq loc.flash") />
	</cffunction>
	
	<cffunction name="test_flash_get_empty_struct_valid">
		<cfset session.flash = {} />
		<cfset loc.flash = loc.controller.flash() />
		<cfset assert("IsStruct(loc.flash) eq 'YES'") />
	</cffunction>
	
</cfcomponent>

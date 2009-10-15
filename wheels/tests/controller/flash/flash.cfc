<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.controller") />
	
	<cffunction name="setup">
		<cfset session.flash = {} />
		<cfset session.flash.success = "congrats!" />
	</cffunction>
	
	<cffunction name="test_key_exists">
		<cfset loc.e = loc.controller.flash("success") />
		<cfset loc.r = "congrats!">
		<cfset assert("loc.e eq loc.r") />
	</cffunction>
	
	<cffunction name="test_key_does_not_exists">
		<cfset loc.e = loc.controller.flash("invalidkey") />
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r") />
	</cffunction>
	
	<cffunction name="test_key_is_blank">
		<cfset loc.e = loc.controller.flash("") />
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r") />
	</cffunction>	
	
	<cffunction name="test_key_provided_flash_empty">
		<cfset structclear(session.flash)>
		<cfset loc.e = loc.controller.flash("invalidkey") />
		<cfset loc.r = "">
		<cfset assert("loc.e eq loc.r") />
	</cffunction>
	
	<cffunction name="test_no_key_provided_flash_not_empty">
		<cfset loc.e = loc.controller.$hashStruct(session.flash) />
		<cfset loc.r = loc.controller.$hashStruct(loc.controller.flash()) />
		<cfset assert("loc.e eq loc.r") />
	</cffunction>
	
	<cffunction name="test_no_key_provided_flash_empty">
		<cfset structclear(session.flash)>
		<cfset loc.r = loc.controller.flash() />
		<cfset assert("isstruct(loc.r) and structisempty(loc.r)") />
	</cffunction>

</cfcomponent>

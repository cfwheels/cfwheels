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
	
	<cffunction name="test_flashClear_valid">
		<cfset session.flash = {} />
		<cfset loc.controller.flashInsert(success="congrats!") />
		<cfset loc.controller.flashClear() />
		<cfset loc.flashKeyList = StructKeyList(loc.controller.flash()) />
		<cfset assert("loc.flashKeyList eq ''") />
	</cffunction>
	
	<cffunction name="test_flashCount_valid">
		<cfset session.flash = {} />
		<cfset session.flash.success = "congrats!" />
		<cfset loc.count = loc.controller.flashCount() />
		<cfset loc.sessionCount = StructCount(session.flash) />
		<cfset assert("loc.count eq loc.sessionCount") />
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
	
	<cffunction name="test_flashInsert_valid">
		<cfset session.flash = {} />
		<cfset loc.e = "congrats!" />
		<cfset loc.controller.flashInsert(success=loc.e) />
		<cfset loc.r = session.flash.success />
		<cfset assert("loc.e eq loc.r") />
	</cffunction>
	
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

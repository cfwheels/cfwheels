<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_key_exists">
		<cfset run_key_exists()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_key_exists()>
	</cffunction>
		
	<cffunction name="run_key_exists">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset result = loc.controller.flash("success")>
		<cfset assert("result IS 'Congrats!'")>
	</cffunction>

	<cffunction name="test_key_does_not_exist">
		<cfset run_key_does_not_exist()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_key_does_not_exist()>
	</cffunction>
	
	<cffunction name="run_key_does_not_exist">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset result = loc.controller.flash("invalidkey")>
		<cfset assert("result IS ''")>
	</cffunction>

	<cffunction name="test_key_is_blank">
		<cfset run_key_is_blank()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_key_is_blank()>
	</cffunction>
	
	<cffunction name="run_key_is_blank">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset result = loc.controller.flash("")>
		<cfset assert("result IS ''")>
	</cffunction>

	<cffunction name="test_key_provided_flash_empty">
		<cfset run_key_provided_flash_empty()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_key_provided_flash_empty()>
	</cffunction>
	
	<cffunction name="run_key_provided_flash_empty">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset loc.controller.flashClear()>
		<cfset result = loc.controller.flash("invalidkey")>
		<cfset assert("result IS ''")>
	</cffunction>

	<cffunction name="test_no_key_provided_flash_not_empty">
		<cfset run_no_key_provided_flash_not_empty()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_no_key_provided_flash_not_empty()>
	</cffunction>
	
	<cffunction name="run_no_key_provided_flash_not_empty">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset result = loc.controller.flash()>
		<cfset assert("IsStruct(result) AND StructKeyExists(result, 'success')")>
	</cffunction>
	
	<cffunction name="test_no_key_provided_flash_empty">
		<cfset run_no_key_provided_flash_empty()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_no_key_provided_flash_empty()>
		
	</cffunction>
	
	<cffunction name="run_no_key_provided_flash_empty">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset loc.controller.flashClear()>
		<cfset result = loc.controller.flash()>
		<cfset assert("IsStruct(result) AND StructIsEmpty(result)")>
	</cffunction>

</cfcomponent>

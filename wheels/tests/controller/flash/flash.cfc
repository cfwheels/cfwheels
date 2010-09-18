<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_key_exists">
		<cfset run_key_exists()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_key_exists()>
	</cffunction>
		
	<cffunction name="run_key_exists">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset result = controller.flash("success")>
		<cfset assert("result IS 'Congrats!'")>
	</cffunction>

	<cffunction name="test_key_does_not_exist">
		<cfset run_key_does_not_exist()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_key_does_not_exist()>
	</cffunction>
	
	<cffunction name="run_key_does_not_exist">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset result = controller.flash("invalidkey")>
		<cfset assert("result IS ''")>
	</cffunction>

	<cffunction name="test_key_is_blank">
		<cfset run_key_is_blank()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_key_is_blank()>
	</cffunction>
	
	<cffunction name="run_key_is_blank">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset result = controller.flash("")>
		<cfset assert("result IS ''")>
	</cffunction>

	<cffunction name="test_key_provided_flash_empty">
		<cfset run_key_provided_flash_empty()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_key_provided_flash_empty()>
	</cffunction>
	
	<cffunction name="run_key_provided_flash_empty">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashClear()>
		<cfset result = controller.flash("invalidkey")>
		<cfset assert("result IS ''")>
	</cffunction>

	<cffunction name="test_no_key_provided_flash_not_empty">
		<cfset run_no_key_provided_flash_not_empty()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_no_key_provided_flash_not_empty()>
	</cffunction>
	
	<cffunction name="run_no_key_provided_flash_not_empty">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset result = controller.flash()>
		<cfset assert("IsStruct(result) AND StructKeyExists(result, 'success')")>
	</cffunction>
	
	<cffunction name="test_no_key_provided_flash_empty">
		<cfset run_no_key_provided_flash_empty()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_no_key_provided_flash_empty()>
	</cffunction>
	
	<cffunction name="run_no_key_provided_flash_empty">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashClear()>
		<cfset result = controller.flash()>
		<cfset assert("IsStruct(result) AND StructIsEmpty(result)")>
	</cffunction>

</cfcomponent>

<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_flash_key_exists">
		<cfset run_flash_key_exists()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_flash_key_exists()>
	</cffunction>
	
	<cffunction name="run_flash_key_exists">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset loc.r = controller.flashKeyExists("success")>
		<cfset assert("loc.r IS true")>
	</cffunction>

</cfcomponent>
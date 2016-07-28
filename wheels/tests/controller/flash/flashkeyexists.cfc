<cfcomponent extends="wheels.tests.Test">

	<cffunction name="setup">
		<cfinclude template="setup.cfm">
	</cffunction>

	<cffunction name="teardown">
		<cfinclude template="teardown.cfm">
	</cffunction>

	<cffunction name="test_flash_key_exists">
		<cfset run_flash_key_exists()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_flash_key_exists()>
	</cffunction>

	<cffunction name="run_flash_key_exists">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset loc.r = loc.controller.flashKeyExists("success")>
		<cfset assert("loc.r IS true")>
	</cffunction>

</cfcomponent>

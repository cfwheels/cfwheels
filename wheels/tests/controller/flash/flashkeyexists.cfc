<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="test_flash_key_exists">
		<cfset session.flash = {success="congrats!"}>
		<cfset loc.r = controller.flashKeyExists("success")>
		<cfset assert("loc.r IS true")>
	</cffunction>

</cfcomponent>
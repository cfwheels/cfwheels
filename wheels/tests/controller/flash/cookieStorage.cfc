<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>
	<cfset controller.$setFlashStorage("cookie")>

	<cffunction name="test_cookie_storage_should_be_enabled">
		<cfset assert('controller.$getFlashStorage() eq "cookie"')>
	</cffunction>

</cfcomponent>
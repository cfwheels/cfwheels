<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setup.cfm">
	
	<cffunction name="test_cookie_storage_should_be_enabled">
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset assert('loc.controller.$getFlashStorage() eq "cookie"')>
		<cfset loc.controller.$setFlashStorage("session")>
		<cfset assert('loc.controller.$getFlashStorage() eq "session"')>
	</cffunction>

</cfcomponent>
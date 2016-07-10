<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfinclude template="setup.cfm">
	</cffunction>

	<cffunction name="teardown">
		<cfinclude template="teardown.cfm">
	</cffunction>

	<cffunction name="test_cookie_storage_should_be_enabled">
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset assert(loc.controller.$getFlashStorage() eq "cookie")>
		<cfset loc.controller.$setFlashStorage("session")>
		<cfset assert(loc.controller.$getFlashStorage() eq "session")>
	</cffunction>

</cfcomponent>

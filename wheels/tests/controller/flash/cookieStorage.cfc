<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setup.cfm">
	
	<cffunction name="test_cookie_storage_should_be_enabled">
		<cfset controller.$setFlashStorage("cookie")>
		<cfset assert('controller.$getFlashStorage() eq "cookie"')>
		<cfset controller.$setFlashStorage("session")>
		<cfset assert('controller.$getFlashStorage() eq "session"')>
	</cffunction>

</cfcomponent>
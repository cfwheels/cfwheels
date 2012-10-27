<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
	
		<cfset loc.settings = {}>
		<cfset loc.settings.allowedEnvironmentSwitchThroughURL = true>
		<cfset loc.settings.reloadPassword = "testing">
		<cfset loc.scope = {}>
		<cfset loc.scope.reload = "production">
		<cfset loc.scope.password = "testing">
	
	</cffunction>

	<cffunction name="test_should_return_production">
		<cfset loc.a = $switchEnivronmentSecurity(loc.settings, loc.scope)>
		<cfset assert('loc.a eq "production"')>
	</cffunction>
	
	<cffunction name="test_should_return_blank_because_wrong_password">
		<cfset loc.scope.password = "wrongpassword">
		<cfset loc.a = $switchEnivronmentSecurity(loc.settings, loc.scope)>
		<cfset assert('!len(loc.a)')>
	</cffunction>
	
	<cffunction name="test_should_return_blank_because_not_allowed">
		<cfset loc.settings.allowedEnvironmentSwitchThroughURL = false>
		<cfset loc.a = $switchEnivronmentSecurity(loc.settings, loc.scope)>
		<cfset assert('!len(loc.a)')>
	</cffunction>
	
	<cffunction name="test_should_return_blank_because_settingPasswordToSwitchEnvironmentKey_is_blank">
		<cfset loc.scope.password = "">
		<cfset loc.a = $switchEnivronmentSecurity(loc.settings, loc.scope)>
		<cfset assert('!len(loc.a)')>
	</cffunction>
	
	<cffunction name="test_should_return_blank_because_settings_and_scope_are_empty">
		<cfset loc.settings = {}>
		<cfset loc.a = $switchEnivronmentSecurity(loc.settings, loc.scope)>
		<cfset assert('!len(loc.a)')>
		<cfset loc.scope = {}>
		<cfset loc.a = $switchEnivronmentSecurity(loc.settings, loc.scope)>
		<cfset assert('!len(loc.a)')>
	</cffunction>


</cfcomponent>
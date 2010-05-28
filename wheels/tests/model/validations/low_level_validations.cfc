<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_validate_and_validateOnCreate_should_be_called_when_creating">
		<cfset loc.user = model("user").new()>
		<cfset loc.user.valid()>
		<cfset assert('StructKeyExists(loc.user, "_validateCalled")')>
		<cfset assert('loc.user._validateCalled eq true')>
		<cfset assert('StructKeyExists(loc.user, "_validateOnCreateCalled")')>
		<cfset assert('loc.user._validateOnCreateCalled eq true')>
	</cffunction>
	
	<cffunction name="test_validate_and_validateOnUpdate_should_be_called_when_updating">
		<cfset loc.user = model("user").findOne(where="username = 'perd'")>
		<cfset loc.user.valid()>
		<cfset assert('StructKeyExists(loc.user, "_validateCalled")')>
		<cfset assert('loc.user._validateCalled eq true')>
		<cfset assert('StructKeyExists(loc.user, "_validateOnUpdateCalled")')>
		<cfset assert('loc.user._validateOnUpdateCalled eq true')>
	</cffunction>

</cfcomponent>
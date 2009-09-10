<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.user = createobject("component", "wheels.model").$initModelClass("Users")>
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.user = duplicate(global.user)>
	</cffunction>

	<cffunction name="test_validatesConfirmationOf_valid">
		<cfset loc.user.password = "hamsterjelly">
		<cfset loc.user.passwordConfirmation = "hamsterjelly">
		<cfset loc.user.validatesConfirmationOf(property="password")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesConfirmationOf_invalid">
		<cfset loc.user.password = "hamsterjelly">
		<cfset loc.user.passwordConfirmation = "hamsterjellysucks">
		<cfset loc.user.validatesConfirmationOf(property="password")>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_valid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_invalid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony")>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_valid_allowblank_true">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="true")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_invalid_allowblank_false">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="false")>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="assert_test">
		<cfargument name="obj" type="any" required="true">
		<cfargument name="expect" type="any" required="true">
		<cfset loc.e = arguments.obj.valid()>
		<cfset assert('loc.e eq #arguments.expect#')>
	</cffunction>

</cfcomponent>
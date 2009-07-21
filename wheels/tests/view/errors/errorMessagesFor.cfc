<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.tests.ControllerWithModelErrors")>
		<cfset global.args = {}>
		<cfset global.args.objectName = "ModelUsers">
		<cfset global.args.class = "errors-found">
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_show_duplicate_errors">
		<cfset loc.a.showDuplicates = true>
		<cfset loc.e = global.controller.errorMessagesFor(argumentcollection=loc.a)>
		<cfset loc.r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li><li>firstname error2</li></ul>'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_do_not_show_duplicate_errors">
		<cfset loc.a.showDuplicates = false>
		<cfset loc.e = global.controller.errorMessagesFor(argumentcollection=loc.a)>
		<cfset loc.r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li></ul>'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
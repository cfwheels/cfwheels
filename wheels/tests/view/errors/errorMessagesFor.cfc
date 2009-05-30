<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerWithModelErrors")>
		<cfset args = {}>
		<cfset args.objectName = "ModelUsers">
		<cfset args.class = "errors-found">
	</cffunction>

	<cffunction name="test_show_duplicate_errors">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.showDuplicates = true>
		<cfset loc.e = controller.errorMessagesFor(argumentcollection=loc.a)>
		<cfset loc.r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li><li>firstname error2</li></ul>'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_do_not_show_duplicate_errors">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.showDuplicates = false>
		<cfset loc.e = controller.errorMessagesFor(argumentcollection=loc.a)>
		<cfset loc.r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li></ul>'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
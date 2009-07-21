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

	<cffunction name="test_all_options_supplied">
		<cfset loc.a.property = "firstname">
		<cfset loc.a.prependText = "prepend ">
		<cfset loc.a.appendText = " append">
		<cfset loc.a.wrapperElement = "div">
		<cfset loc.e = global.controller.errorMessageOn(argumentcollection=loc.a)>
		<cfset loc.r = '<div class="errors-found">prepend firstname error1 append</div>'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
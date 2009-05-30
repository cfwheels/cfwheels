<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerWithModelErrors")>
		<cfset args = {}>
		<cfset args.objectName = "ModelUsers">
		<cfset args.class = "errors-found">
	</cffunction>

	<cffunction name="test_all_options_supplied">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.property = "firstname">
		<cfset loc.a.prependText = "prepend ">
		<cfset loc.a.appendText = " append">
		<cfset loc.a.wrapperElement = "div">
		<cfset loc.e = controller.errorMessageOn(argumentcollection=loc.a)>
		<cfset loc.r = '<div class="errors-found">prepend firstname error1 append</div>'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModelErrors")>
		<cfset loc.args = {}>
		<cfset loc.args.objectName = "user">
		<cfset loc.args.class = "errors-found">
	</cffunction>

	<cffunction name="test_all_options_supplied">
		<cfset loc.args.property = "firstname">
		<cfset loc.args.prependText = "prepend ">
		<cfset loc.args.appendText = " append">
		<cfset loc.args.wrapperElement = "div">
		<cfset loc.e = loc.controller.errorMessageOn(argumentcollection=loc.args)>
		<cfset loc.r = '<div class="errors-found">prepend firstname error1 append</div>'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args = {}>
		<cfset loc.args.name = "input">
		<cfset loc.args.close = true>
		<cfset loc.args.attributes = {}>
		<cfset loc.args.attributes.type = "text">
		<cfset loc.args.attributes.class = "wheelstest">
		<cfset loc.args.attributes.size = "30">
		<cfset loc.args.attributes.maxlength = "50">
		<cfset loc.args.attributes.name = "inputtest">
		<cfset loc.args.attributes.firstname = "tony">
		<cfset loc.args.attributes.lastname = "petruzzi">
		<cfset loc.args.attributes._firstname = "tony">
		<cfset loc.args.attributes._lastname = "petruzzi">
		<cfset loc.args.attributes.id = "inputtest">
		<cfset loc.args.skip = "firstname,lastname">
		<cfset loc.args.skipStartingWith = "_">
		<cfset loc.args.attributes.onmouseover = "function(this){this.focus();}">
	</cffunction>

	<cffunction name="test_with_all_options">
		<cfset loc.e = loc.controller.$tag(argumentCollection=loc.args)>
		<cfset loc.r = '<input class="wheelstest" id="inputtest" maxlength="50" name="inputtest" onmouseover="function(this){this.focus();}" size="30" type="text" />'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
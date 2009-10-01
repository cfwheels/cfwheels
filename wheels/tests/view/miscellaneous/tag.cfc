<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	<cfset global.args = {}>
	<cfset global.args.name = "input">
	<cfset global.args.close = true>
	<cfset global.args.attributes = {}>
	<cfset global.args.attributes.type = "text">
	<cfset global.args.attributes.class = "wheelstest">
	<cfset global.args.attributes.size = "30">
	<cfset global.args.attributes.maxlength = "50">
	<cfset global.args.attributes.name = "inputtest">
	<cfset global.args.attributes.firstname = "tony">
	<cfset global.args.attributes.lastname = "petruzzi">
	<cfset global.args.attributes._firstname = "tony">
	<cfset global.args.attributes._lastname = "petruzzi">
	<cfset global.args.attributes.id = "inputtest">
	<cfset global.args.skip = "firstname,lastname">
	<cfset global.args.skipStartingWith = "_">
	<cfset global.args.attributes.onmouseover = "function(this){this.focus();}">

	<cffunction name="test_with_all_options">
		<cfset loc.e = loc.controller.$tag(argumentCollection=loc.args)>
		<cfset loc.r = '<input size="30" onmouseover="function(this){this.focus();}" type="text" class="wheelstest" id="inputtest" maxlength="50" name="inputtest" />'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
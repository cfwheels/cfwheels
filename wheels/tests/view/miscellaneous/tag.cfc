<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args = {}>
		<cfset args.name = "input">
		<cfset args.close = true>
		<cfset args.attributes = {}>
		<cfset args.attributes.type = "text">
		<cfset args.attributes.class = "wheelstest">
		<cfset args.attributes.size = "30">
		<cfset args.attributes.maxlength = "50">
		<cfset args.attributes.name = "inputtest">
		<cfset args.attributes.firstname = "tony">
		<cfset args.attributes.lastname = "petruzzi">
		<cfset args.attributes._firstname = "tony">
		<cfset args.attributes._lastname = "petruzzi">
		<cfset args.attributes.id = "inputtest">
		<cfset args.skip = "firstname,lastname">
		<cfset args.skipStartingWith = "_">
		<cfset args.attributes.onmouseover = "function(this){this.focus();}">
	</cffunction>

	<cffunction name="test_with_all_options">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>

		<cfset loc.e = controller.$tag(argumentCollection=loc.a)>
		<cfset loc.r = '<input size="30" onmouseover="function(this){this.focus();}" type="text" class="wheelstest" id="inputtest" maxlength="50" name="inputtest" />'>

		<cfset assert("loc.e eq loc.r")>

	</cffunction>

</cfcomponent>
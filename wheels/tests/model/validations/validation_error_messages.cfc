<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset StructDelete(application.wheels.models, "users", false)>
        <cfset loc.user = model("users").new()>
	    <cfset loc.user.username = "TheLongestNameInTheWorld">
        <cfset loc.args = {}>
        <cfset loc.args.property = "username">
		<cfset loc.args.minimum = "5">
        <cfset loc.args.maximum = "20">
		<cfset loc.args.message="Please shorten your [property] please. [maximum] characters is the maximum length allowed.">
	</cffunction>
	
	<cffunction name="test_bracketed_argument_markers_are_replaced">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset loc.user.valid()>
		<cfset asset_test(loc.user, loc.args.message)>
	</cffunction>
	
	<cffunction name="test_bracketed_property_argument_marker_at_beginning_is_capitalized">
		<cfset loc.args.message="[property] must be between [minimum] and [maximum] characters.">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset loc.user.valid()>
		<cfset asset_test(loc.user, loc.args.message)>
	</cffunction>
	
	<cffunction name="test_bracketed_argument_markers_can_be_escaped">
		<cfset loc.args.message="[property] must be between [[minimum]] and [maximum] characters.">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset loc.user.valid()>
		<cfset asset_test(loc.user, loc.args.message)>
	</cffunction>
	
	<cffunction name="asset_test">
		<cfargument name="obj" type="any" required="true">
		<cfargument name="expected" type="string" required="true">
		<cfset argument.obj = arguments.obj.errorsOn("username")>
		<cfreturn Compare(argument.obj[1].message, arguments.expected)>
	</cffunction>

</cfcomponent>
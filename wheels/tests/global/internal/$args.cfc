<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_declaring_required_arguments_throws_error_when_missing">
		<cfset loc.args = {}>
		<cfset loc.e = "Wheels.IncorrectArguments">
		<cfset loc.r = raised('$args(args=loc.args, name="sendEmail", combine="template/templates/!")')>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = raised('$args(args=loc.args, name="sendEmail", combine="template/templates", required="template")')>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = raised('$args(args=loc.args, name="sendEmail", required="template")')>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = raised('$args(args=loc.args, name="sendEmail", template="", required="template")')>
		<cfset loc.args.template = "">
		<cfset loc.r = raised('$args(args=loc.args, name="sendEmail", combine="template/templates", required="template")')>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.args.template = "">
		<cfset loc.r = raised('$args(args=loc.args, name="sendEmail", combine="template/templates")')>
		<cfset assert('loc.r eq ""')>
	</cffunction>
	
	<cffunction name="test_not_declaring_required_arguments_should_not_raise_error_when_missing">
		<cfset loc.args = {}>
		<cfset loc.e = "">
		<cfset loc.r = raised('$args(args=loc.args, name="sendEmail", combine="template/templates")')>
		<cfset assert('loc.e eq loc.r')>
		<cfset loc.r = raised('$args(args=loc.args, name="sendEmail")')>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_combined_arguments">
		<cfset loc.e = "">
		<cfset loc.r = combined_arguments(template="tony", templates="per")>
		<cfset assert('loc.r.template eq "per"')>
		<cfset assert('not StructKeyExists(loc.r, "templates")')>
		<cfset loc.r = combined_arguments(templates="per")>
		<cfset assert('loc.r.template eq "per"')>
		<cfset assert('not StructKeyExists(loc.r, "templates")')>
	</cffunction>
	
	<cffunction name="combined_arguments">
		<cfset $args(args=arguments, name="sendEmail", combine="template/templates")>
		<cfreturn arguments>
	</cffunction>
	
</cfcomponent>
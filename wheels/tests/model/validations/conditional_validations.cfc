<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset StructDelete(application.wheels.models, "users", false)>
        <cfset loc.user = model("users").new()>
	    <cfset loc.user.username = "TheLongestNameInTheWorld">
        <cfset loc.args = {}>
        <cfset loc.args.property = "username">
        <cfset loc.args.maximum = "5">
	</cffunction>

	<cffunction name="test_if_validation_using_expression_invalid">
		<cfset loc.args.condition="1 eq 1">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_if_validation_using_expression_valid">
		<cfset loc.args.condition="1 eq 0">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_if_validation_using_method_invalid">
		<cfset loc.args.condition="isnew()">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_if_validation_using_method_valid">
		<cfset loc.args.condition="!isnew()">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_if_validation_using_method_mixin_and_parameters_invalid">
		<cfset loc.args.condition="this.stupid_method(b='1' , a='2') eq 3">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_if_validation_using_method_mixin_and_parameters_valid">
		<cfset loc.args.condition="this.stupid_method(b='1' , a='2') neq 3">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_unless_validation_using_expression_valid">
		<cfset loc.args.unless="true">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_unless_validation_using_expression_invalid">
		<cfset loc.args.unless="false">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_unless_validation_using_method_valid">
		<cfset loc.args.unless="isnew()">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_unless_validation_using_method_invalid">
		<cfset loc.args.unless="!isnew()">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_unless_validation_using_method_mixin_and_parameters_valid">
		<cfset loc.args.unless="this.stupid_method(b='1' , a='2') eq 3">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_unless_validation_using_method_mixin_and_parameters_invalid">
		<cfset loc.args.unless="this.stupid_method(b='1' , a='2') neq 3">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_both_validations_if_trigged_unless_not_trigged_valid">
		<cfset loc.args.condition="1 eq 1">
		<cfset loc.args.unless="this.username eq 'TheLongestNameInTheWorld'">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_both_validations_if_trigged_unless_trigged_invalid">
		<cfset loc.args.condition="1 eq 1">
		<cfset loc.args.unless="this.username eq ''">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_both_validations_if_not_trigged_unless_not_trigged_valid">
		<cfset loc.args.condition="1 eq 0">
		<cfset loc.args.unless="this.username eq 'TheLongestNameInTheWorld'">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_both_validations_if_not_trigged_unless_trigged_valid">
		<cfset loc.args.condition="1 eq 0">
		<cfset loc.args.unless="this.username eq ''">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="assert_test">
		<cfargument name="obj" type="any" required="true">
		<cfargument name="expect" type="boolean" required="true">
		<cfset loc.e = arguments.obj.valid()>
		<cfset assert('loc.e eq #arguments.expect#')>
	</cffunction>

</cfcomponent>
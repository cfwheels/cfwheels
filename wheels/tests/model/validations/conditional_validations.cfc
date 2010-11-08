<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
        <cfset loc.user = createobject("component", "wheelsMapping.Model").$initModelClass(name="Users", path=get("modelPath"))>
        <cfset loc.user.username = "TheLongestNameInTheWorld">
        <cfset loc.args = {}>
        <cfset loc.args.property = "username">
        <cfset loc.args.maximum = "5">
	</cffunction>

	<cffunction name="test_unless_validation_using_expression_valid">
		<cfset loc.args.unless="1 eq 1">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_unless_validation_using_expression_invalid">
		<cfset loc.args.unless="1 eq 0">
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
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.args.unless="this.stupid_mixin(b='1' , a='2') eq 3">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_unless_validation_using_method_mixin_and_parameters_invalid">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.args.unless="this.stupid_mixin(b='1' , a='2') neq 3">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_if_validation_using_expression_invalid">
		<cfset loc.args.if="1 eq 1">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_if_validation_using_expression_valid">
		<cfset loc.args.if="1 eq 0">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_if_validation_using_method_invalid">
		<cfset loc.args.if="isnew()">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_if_validation_using_method_valid">
		<cfset loc.args.if="!isnew()">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_if_validation_using_method_mixin_and_parameters_invalid">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.args.if="this.stupid_mixin(b='1' , a='2') eq 3">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_if_validation_using_method_mixin_and_parameters_valid">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.args.if="this.stupid_mixin(b='1' , a='2') neq 3">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_both_validations_if_trigged_unless_not_trigged_valid">
		<cfset loc.args.if="1 eq 1">
		<cfset loc.args.unless="this.username eq 'TheLongestNameInTheWorld'">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_both_validations_if_trigged_unless_trigged_invalid">
		<cfset loc.args.if="1 eq 1">
		<cfset loc.args.unless="this.username eq ''">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_both_validations_if_not_trigged_unless_not_trigged_valid">
		<cfset loc.args.if="1 eq 0">
		<cfset loc.args.unless="this.username eq 'TheLongestNameInTheWorld'">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_both_validations_if_not_trigged_unless_trigged_valid">
		<cfset loc.args.if="1 eq 0">
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

	<!--- mixin --->
	<cffunction name="stupid_mixin">
		<cfargument name="a" type="numeric" required="true">
		<cfargument name="b" type="numeric" required="true">
		<cfreturn a + b>
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.test">

	<cfset global.user = createobject("component", "wheelsMapping.model").$initModelClass("User")>
	<cfset global.user.username = "TheLongestNameInTheWorld">
	<cfset global.args = {}>
	<cfset global.args.property = "username">
	<cfset global.args.maximum = "5">

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

	<!--- <cffunction name="test_if_condition_not_triggered_validation_should_not_occur">
		<cfset loc.args.if="1 eq 0">
		<cfset loc.args.property = "invalidproperty">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset assert_test(loc.user, true)>
	</cffunction> --->

	<cffunction name="test_if_condition_triggered_validation_should_not_occur">
		<cfset loc.args.if="1 eq 1">
		<cfset loc.args.property = "xxxx">
		<cfset loc.user.validatesLengthOf(argumentCollection=loc.args)>
		<cfset loc.e = raised('loc.user.valid()')>
		<cfset loc.r = "Wheels.PropertyNotFound">
		<cfset assert("loc.e eq loc.r")>
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
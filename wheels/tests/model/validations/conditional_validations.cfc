<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
	</cffunction>
	
	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.user = createobject("component", "wheels.model").$initModelClass("Users")>
		<cfset loc.user.username = "TheLongestNameInTheWorld">
	</cffunction>

	<cffunction name="test_unless_validation_using_expression_true">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="1 eq 1")>
		<cfset assert('loc.user.valid() eq true')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq true')>
	</cffunction>
	
	<cffunction name="test_unless_validation_using_expression_false">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="1 eq 0")>
		<cfset assert('loc.user.valid() eq false')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq false')>
	</cffunction>
	
	<cffunction name="test_unless_validation_using_method_true">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="isnew()")>
		<cfset assert('loc.user.valid() eq true')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq true')>
	</cffunction>
	
	<cffunction name="test_unless_validation_using_method_false">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="!isnew()")>
		<cfset assert('loc.user.valid() eq false')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq false')>
	</cffunction>
	
	<cffunction name="test_unless_validation_using_method_name_true">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="isnew")>
		<cfset assert('loc.user.valid() eq true')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq true')>
	</cffunction>
	
	<cffunction name="test_unless_validation_using_method_name_false">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="!isnew")>
		<cfset assert('loc.user.valid() eq false')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq false')>
	</cffunction>
	
	<cffunction name="test_unless_validation_using_method_mixin_and_parameters_true">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="this.stupid_mixin(b='1' , a='2') eq 3")>
		<cfset loc.e = loc.user.valid()>
		<cfset assert('loc.e eq true')>
		<cfset loc.e = arrayisempty(loc.user.errorsOn("username"))>
		<cfset assert('loc.e eq true')>
	</cffunction>

	<cffunction name="test_unless_validation_using_method_mixin_and_parameters_false">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="this.stupid_mixin(b='1' , a='2') neq 3")>
		<cfset loc.e = loc.user.valid()>
		<cfset assert('loc.e eq false')>
		<cfset loc.e = arrayisempty(loc.user.errorsOn("username"))>
		<cfset assert('loc.e  eq false')>
	</cffunction>
	
	<cffunction name="test_if_validation_using_expression_true">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="1 eq 1")>
		<cfset assert('loc.user.valid() eq false')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq false')>
	</cffunction>
	
	<cffunction name="test_if_validation_using_expression_false">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="1 eq 0")>
		<cfset assert('loc.user.valid() eq true')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq true')>
	</cffunction>

	<cffunction name="test_if_validation_using_method_true">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="isnew()")>
		<cfset assert('loc.user.valid() eq false')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq false')>
	</cffunction>
	
	<cffunction name="test_if_validation_using_method_false">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="!isnew()")>
		<cfset assert('loc.user.valid() eq true')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq true')>
	</cffunction>

	<cffunction name="test_if_validation_using_method_name_true">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="isnew")>
		<cfset assert('loc.user.valid() eq false')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq false')>
	</cffunction>
	
	<cffunction name="test_if_validation_using_method_name_false">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="!isnew")>
		<cfset assert('loc.user.valid() eq true')>
		<cfset assert('arrayisempty(loc.user.errorsOn("username")) eq true')>
	</cffunction>
	
	<cffunction name="test_if_validation_using_method_mixin_and_parameters_true">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="this.stupid_mixin(b='1' , a='2') eq 3")>
		<cfset loc.e = loc.user.valid()>
		<cfset assert('loc.e eq false')>
		<cfset loc.e = arrayisempty(loc.user.errorsOn("username"))>
		<cfset assert('loc.e eq false')>
	</cffunction>

	<cffunction name="test_if_validation_using_method_mixin_and_parameters_false">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="this.stupid_mixin(b='1' , a='2') neq 3")>
		<cfset loc.e = loc.user.valid()>
		<cfset assert('loc.e eq true')>
		<cfset loc.e = arrayisempty(loc.user.errorsOn("username"))>
		<cfset assert('loc.e  eq true')>
	</cffunction>
	
	
	<!--- mixin --->
	<cffunction name="stupid_mixin">
		<cfargument name="a" type="numeric" required="true">
		<cfargument name="b" type="numeric" required="true">
		<cfreturn a + b>
	</cffunction>
	
</cfcomponent>
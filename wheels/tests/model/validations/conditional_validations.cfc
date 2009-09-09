<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.user = createobject("component", "wheels.model").$initModelClass("Users")>
		<cfset global.user.username = "TheLongestNameInTheWorld">
	</cffunction>
	
	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.user = duplicate(global.user)>
	</cffunction>

	<cffunction name="test_unless_validation_using_expression_true">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="1 eq 1")>
		<cfset resultsForTest(loc.user, true)>
	</cffunction>
	
	<cffunction name="test_unless_validation_using_expression_false">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="1 eq 0")>
		<cfset resultsForTest(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_unless_validation_using_method_true">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="isnew()")>
		<cfset resultsForTest(loc.user, true)>
	</cffunction>
	
	<cffunction name="test_unless_validation_using_method_false">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="!isnew()")>
		<cfset resultsForTest(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_unless_validation_using_method_mixin_and_parameters_true">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="this.stupid_mixin(b='1' , a='2') eq 3")>
		<cfset resultsForTest(loc.user, true)>
	</cffunction>

	<cffunction name="test_unless_validation_using_method_mixin_and_parameters_false">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", unless="this.stupid_mixin(b='1' , a='2') neq 3")>
		<cfset resultsForTest(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_if_validation_using_expression_true">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="1 eq 1")>
		<cfset resultsForTest(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_if_validation_using_expression_false">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="1 eq 0")>
		<cfset resultsForTest(loc.user, true)>
	</cffunction>

	<cffunction name="test_if_validation_using_method_true">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="isnew()")>
		<cfset resultsForTest(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_if_validation_using_method_false">
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="!isnew()")>
		<cfset resultsForTest(loc.user, true)>
	</cffunction>
	
	<cffunction name="test_if_validation_using_method_mixin_and_parameters_true">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="this.stupid_mixin(b='1' , a='2') eq 3")>
		<cfset resultsForTest(loc.user, false)>
	</cffunction>

	<cffunction name="test_if_validation_using_method_mixin_and_parameters_false">
		<cfset loc.user.stupid_mixin = stupid_mixin>
		<cfset loc.user.validatesLengthOf(property="username", maximum="5", if="this.stupid_mixin(b='1' , a='2') neq 3")>
		<cfset resultsForTest(loc.user, true)>
	</cffunction>
	
	<cffunction name="resultsForTest">
		<cfargument name="obj" type="any" required="true">
		<cfargument name="result" type="boolean" required="true">
		<cfset loc.e = arguments.obj.valid()>
		<cfset assert('loc.e eq #arguments.result#')>
		<cfset loc.e = arrayisempty(arguments.obj.errorsOn("username"))>
		<cfset assert('loc.e eq #arguments.result#')>
	</cffunction>
	
	<!--- mixin --->
	<cffunction name="stupid_mixin">
		<cfargument name="a" type="numeric" required="true">
		<cfargument name="b" type="numeric" required="true">
		<cfreturn a + b>
	</cffunction>
	
</cfcomponent>
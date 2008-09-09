<cfcomponent extends="wheels.tests.test">

	<cffunction access="public" returntype="void" name="test_00_null_test">
		<!--- Should record 'Success' by default --->
	</cffunction>


	<cffunction access="public" returntype="void" name="test_01_assert_true">
		<!--- An assert that evaluates to true should pass without note --->
		<cfset assert("true")>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_02_assert_2_equals_2">
		<!--- A basic expression that evaluates to true should pass without note --->
		<cfset assert("2 eq 2")>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_03_assert_a_equals_b">
		<!--- Check that true expression with variables doesn't cause failure --->
		<cfset a=1>
		<cfset b=1>
		<cfset assert("a eq b")>
	</cffunction>

</cfcomponent>
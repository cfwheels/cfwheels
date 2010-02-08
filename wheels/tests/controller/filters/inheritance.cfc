<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_should_run_parent">
		<cfset assert("1 IS 1")>
	</cffunction>

	<cffunction name="test_should_run_parent_and_current_in_order">
		<cfset assert("1 IS 1")>
	</cffunction>

</cfcomponent>
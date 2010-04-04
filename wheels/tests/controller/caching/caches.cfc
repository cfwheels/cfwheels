<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="dummy", action="dummy"}>	
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>
	
	<cffunction name="test_specifying_one_action_to_cache">
	</cffunction>

	<cffunction name="test_specifying_multiple_actions_to_cache">
	</cffunction>

	<cffunction name="test_specifying_action_to_cache_with_options">
	</cffunction>
	
</cfcomponent>
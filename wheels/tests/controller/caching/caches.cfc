<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy")>

	<cffunction name="setup">
		<cfset controller.$clearCachableActions()>
	</cffunction>
	
	<cffunction name="test_specifying_one_action_to_cache">
		<cfset controller.caches(action="dummy")>
		<cfset loc.r = controller.$cachableActions()>
		<cfset loc.e = controller.$cacheSettingsForAction("dummy")>
		<cfset assert("ArrayLen(loc.r) IS 1 AND loc.r[1].time IS 60 AND loc.e.time IS 60")>
	</cffunction>

	<cffunction name="test_specifying_multiple_actions_to_cache">
		<cfset controller.caches(actions="dummy1,dummy2")>
		<cfset loc.r = controller.$cachableActions()>
		<cfset assert("ArrayLen(loc.r) IS 2 AND loc.r[2].time IS 60")>
	</cffunction>

	<cffunction name="test_specifying_actions_to_cache_with_options">
		<cfset controller.caches(actions="dummy1,dummy2", time=5, static=true)>
		<cfset loc.r = controller.$cachableActions()>
		<cfset assert("ArrayLen(loc.r) IS 2 AND loc.r[2].time IS 5 AND loc.r[2].static IS true")>
	</cffunction>

	<cffunction name="test_specifying_caching_all_actions">
		<cfset controller.caches(static=true)>
		<cfset loc.r = controller.$cacheSettingsForAction("dummy")>
		<cfset assert("loc.r.static IS true")>
	</cffunction>
	
</cfcomponent>
<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="test", action="test"}>
	<cfset loc.controller = controller("test", params)>

	<cffunction name="setup">
		<cfset loc.controller.$clearCachableActions()>
	</cffunction>
	
	<cffunction name="test_specifying_one_action_to_cache">
		<cfset loc.controller.caches(action="dummy")>
		<cfset loc.r = loc.controller.$cacheSettingsForAction("dummy")>
		<cfset assert("loc.r.time IS 60")>
	</cffunction>

	<cffunction name="test_specifying_one_action_to_cache_and_running_it">
		<cfset $$oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
		<cfset loc.controller.caches(action="test")>
		<cfset loc.result = loc.controller.$processAction("test", params)>
		<cfset application.wheels.viewPath = $$oldViewPath>
		<cfset assert("loc.result IS true")>
	</cffunction>

	<cffunction name="test_specifying_multiple_actions_to_cache">
		<cfset loc.controller.caches(actions="dummy1,dummy2")>
		<cfset loc.r = loc.controller.$cachableActions()>
		<cfset assert("ArrayLen(loc.r) IS 2 AND loc.r[2].time IS 60")>
	</cffunction>

	<cffunction name="test_specifying_actions_to_cache_with_options">
		<cfset loc.controller.caches(actions="dummy1,dummy2", time=5, static=true)>
		<cfset loc.r = loc.controller.$cachableActions()>
		<cfset assert("ArrayLen(loc.r) IS 2 AND loc.r[2].time IS 5 AND loc.r[2].static IS true")>
	</cffunction>

	<cffunction name="test_specifying_caching_all_actions">
		<cfset loc.controller.caches(static=true)>
		<cfset loc.r = loc.controller.$cacheSettingsForAction("dummy")>
		<cfset assert("loc.r.static IS true")>
	</cffunction>
	
</cfcomponent>
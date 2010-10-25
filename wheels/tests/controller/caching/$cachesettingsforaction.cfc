<cfcomponent extends="wheelsMapping.Test">

	<cfset loc.controller = controller(name="dummy")>

	<cffunction name="test_getting_cache_settings_for_action">
		<cfset loc.controller.caches(action="dummy1", time=100)>
		<cfset loc.r = loc.controller.$cacheSettingsForAction("dummy1")>
		<cfset assert("loc.r.time IS 100")>
	</cffunction>
	
</cfcomponent>
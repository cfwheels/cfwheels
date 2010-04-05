<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy")>

	<cffunction name="test_getting_cache_settings_for_action">
		<cfset controller.caches(action="dummy1", time=100)>
		<cfset loc.r = controller.$cacheSettingsForAction("dummy1")>
		<cfset assert("loc.r.time IS 100")>
	</cffunction>
	
</cfcomponent>
<cfcomponent extends="wheelsMapping.Test">

	<cfset loc.controller = controller(name="dummy")>

	<cffunction name="setup">
		<cfset loc.controller.$clearCachableActions()>
	</cffunction>
	
	<cffunction name="test_getting_cachable_actions">
		<cfset loc.controller.caches(actions="dummy1,dummy2")>
		<cfset loc.r = loc.controller.$cachableActions()>
		<cfset assert("ArrayLen(loc.r) IS 2 AND loc.r[1].static IS false")>
	</cffunction>
	
</cfcomponent>
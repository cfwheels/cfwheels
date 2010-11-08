<cfcomponent extends="wheelsMapping.Test">

	<cfset loc.controller = controller(name="dummy")>
	
	<cffunction name="test_clearing_cachable_actions">
		<cfset loc.controller.caches(action="dummy")>
		<cfset loc.controller.$clearCachableActions()>
		<cfset loc.r = loc.controller.$cachableActions()>
		<cfset assert("ArrayLen(loc.r) IS 0")>
	</cffunction>
	
</cfcomponent>
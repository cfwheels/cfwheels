<cfcomponent extends="wheelsMapping.Test">

	<cfset loc.controller = controller(name="dummy")>
	
	<cffunction name="setup">
		<cfset loc.controller.$clearCachableActions()>
	</cffunction>

	<cffunction name="test_adding_cachable_action">
		<cfset loc.controller.caches("dummy1")>
		<cfset loc.str = {}>
		<cfset loc.str.action = "dummy2">
		<cfset loc.str.time = 10>
		<cfset loc.str.static = true>
		<cfset loc.controller.$addCachableAction(loc.str)>
		<cfset loc.r = loc.controller.$cachableActions()>
		<cfset assert("ArrayLen(loc.r) IS 2 AND loc.r[2].action IS 'dummy2'")>
	</cffunction>
	
</cfcomponent>
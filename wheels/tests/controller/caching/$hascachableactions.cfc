<cfcomponent extends="wheelsMapping.Test">

	<cfset loc.controller = controller(name="dummy")>
	
	<cffunction name="setup">
		<cfset loc.controller.$clearCachableActions()>
	</cffunction>

	<cffunction name="test_checking_cachable_action">
		<cfset loc.result = loc.controller.$hasCachableActions()>
		<cfset assert("loc.result IS false")>
		<cfset loc.controller.caches("dummy1")>
		<cfset loc.result = loc.controller.$hasCachableActions()>
		<cfset assert("loc.result IS true")>
	</cffunction>
	
</cfcomponent>
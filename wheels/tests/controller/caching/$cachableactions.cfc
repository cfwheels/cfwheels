<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy")>

	<cffunction name="setup">
		<cfset controller.$clearCachableActions()>
	</cffunction>
	
	<cffunction name="test_getting_cachable_actions">
		<cfset controller.caches(actions="dummy1,dummy2")>
		<cfset loc.r = controller.$cachableActions()>
		<cfset assert("ArrayLen(loc.r) IS 2 AND loc.r[1].static IS false")>
	</cffunction>
	
</cfcomponent>
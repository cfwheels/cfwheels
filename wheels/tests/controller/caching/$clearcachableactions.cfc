<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy")>
	
	<cffunction name="test_clearing_cachable_actions">
		<cfset controller.caches(action="dummy")>
		<cfset controller.$clearCachableActions()>
		<cfset loc.r = controller.$cachableActions()>
		<cfset assert("ArrayLen(loc.r) IS 0")>
	</cffunction>
	
</cfcomponent>
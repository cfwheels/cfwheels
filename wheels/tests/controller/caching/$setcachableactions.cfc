<cfcomponent extends="wheelsMapping.test">

	<cfset controller = $controller(name="dummy")>
	
	<cffunction name="test_setting_cachable_actions">
		<cfset loc.arr = []>
		<cfset loc.arr[1] = {}>
		<cfset loc.arr[1].action = "dummy1">
		<cfset loc.arr[1].time = 10>
		<cfset loc.arr[1].static = true>
		<cfset loc.arr[2] = {}>
		<cfset loc.arr[2].action = "dummy2">
		<cfset loc.arr[2].time = 10>
		<cfset loc.arr[2].static = true>
		<cfset controller.$setCachableActions(loc.arr)>
		<cfset loc.r = controller.$cachableActions()>
		<cfset assert("ArrayLen(loc.r) IS 2 AND loc.r[2].action IS 'dummy2'")>
	</cffunction>
	
</cfcomponent>
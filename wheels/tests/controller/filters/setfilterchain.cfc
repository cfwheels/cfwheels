<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller("dummy", params)>

	<cffunction name="test_valid">
		<!--- Build filter chain through array - this is what we're testing --->
		<cfset
			myFilterChain = [
				{through="restrictAccess"},
				{through="isLoggedIn,checkIPAddress", except="home,login"},
				{type="after", through="logConversion", only="thankYou"}
			]
		>
		<cfset loc.controller.setFilterChain(myFilterChain)>
		<cfset filterChainSet = loc.controller.filterChain()>
		<!--- Undo test --->
		<cfset loc.controller.setFilterChain(ArrayNew(1))>
		<!--- Build filter chain through "normal" filters() function --->
		<cfset loc.controller.filters(through="restrictAccess")>
		<cfset loc.controller.filters(through="isLoggedIn,checkIPAddress", except="home,login")>
		<cfset loc.controller.filters(type="after", through="logConversion", only="thankYou")>
		<cfset filterChainNormal = loc.controller.filterChain()>
		<!--- Undo test --->
		<cfset loc.controller.setFilterChain(ArrayNew(1))>
		<!--- Compare filter chains --->
		<cfset assert("ArrayLen(filterChainSet) eq ArrayLen(filterChainNormal)")>
		<cfset assert("filterChainSet.equals(filterChainNormal)")>
	</cffunction>

</cfcomponent>
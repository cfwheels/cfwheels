<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>	
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>
	
	<cffunction name="test_valid">
		<!--- Build filter chain through array - this is what we're testing --->
		<cfset
			myFilterChain = [
				{through="restrictAccess"},
				{through="isLoggedIn,checkIPAddress", except="home,login"},
				{type="after", through="logConversion", only="thankYou"}
			]
		>
		<cfset controller.setFilterChain(myFilterChain)>
		<cfset filterChainSet = controller.filterChain()>
		<!--- Undo test --->
		<cfset controller.setFilterChain([])>
		<!--- Build filter chain through "normal" filters() function --->
		<cfset controller.filters(through="restrictAccess")>
		<cfset controller.filters(through="isLoggedIn,checkIPAddress", except="home,login")>
		<cfset controller.filters(type="after", through="logConversion", only="thankYou")>
		<cfset filterChainNormal = controller.filterChain()>
		<!--- Undo test --->
		<cfset controller.setFilterChain([])>
		<!--- Compare filter chains --->
		<cfset assert("ArrayLen(filterChainSet) eq ArrayLen(filterChainNormal)")>
	</cffunction>

</cfcomponent>
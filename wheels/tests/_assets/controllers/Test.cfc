<cfcomponent extends="Controller">

	<cffunction name="test">
		<cfset variableForView = "variableForViewContent">
		<cfset variableForLayout = "variableForLayoutContent">
	</cffunction>

	<cffunction name="testRedirect">
		<cfset redirectTo(action="dummy", delay=true)>
		<cfset request.setInActionAfterRedirect = true>
		<cfset renderPage(action="test")>
	</cffunction>

</cfcomponent>
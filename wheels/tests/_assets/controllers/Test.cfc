<cfcomponent extends="Controller">

	<cffunction name="test">
		<cfset variableForView = "hello world!">
	</cffunction>

	<cffunction name="testRedirect">
		<cfset redirectTo(action="dummy", delay=true)>
		<cfset request.setInActionAfterRedirect = true>
		<cfset renderPage(action="test")>
	</cffunction>

</cfcomponent>
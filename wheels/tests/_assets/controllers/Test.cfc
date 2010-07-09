<cfcomponent extends="Controller">

	<cffunction name="test">
		<cfset variableForView = "variableForViewContent">
		<cfset variableForLayout = "variableForLayoutContent">
	</cffunction>

	<cffunction name="testRedirect">
		<cfset redirectTo(action="dummy")>
		<cfset request.setInActionAfterRedirect = true>
		<cfset renderPage(action="test")>
	</cffunction>

	<cffunction name="partialDataTemplate" returnType="struct" access="private">
		<cfset var data = {}>
		<cfset data.fruit = "Apple,Banana,Kiwi">
		<cfset data.somethingElse = true>
		<cfreturn data>
	</cffunction>
	
	<cffunction name="partialDataTemplatePublic" returnType="struct" access="public">
		<cfset var data = {}>
		<cfset data.fruit = "Apple,Banana,Kiwi">
		<cfset data.somethingElse = true>
		<cfreturn data>
	</cffunction>

</cfcomponent>
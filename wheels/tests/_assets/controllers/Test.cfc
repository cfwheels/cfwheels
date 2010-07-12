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

	<cffunction name="$dataForPartial" returnType="struct" access="private">
		<cfset var data = {}>
		<cfset data.fruit = "Apple,Banana,Kiwi">
		<cfset data.somethingElse = true>
		<cfreturn data>
	</cffunction>

	<cffunction name="partialDataImplicitPrivate" returnType="struct" access="private">
		<cfreturn $dataForPartial()>
	</cffunction>

	<cffunction name="partialDataImplicitPublic" returnType="struct" access="public">
		<cfreturn $dataForPartial()>
	</cffunction>
	
	<cffunction name="partialDataExplicitPublic" returnType="struct" access="public">
		<cfreturn $dataForPartial()>
	</cffunction>

</cfcomponent>
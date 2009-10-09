<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.controller") />

	<cffunction name="test_redirectTo_valid">
		<!--- not sure how we are going to test this when the end point is to redirect the browser --->
		<cfset fail()>
	</cffunction>

</cfcomponent>
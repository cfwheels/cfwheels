<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_textAreaTag_valid">
		<cfset loc.controller.textAreaTag(name="description")>
	</cffunction>

</cfcomponent>
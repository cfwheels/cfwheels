<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_endFormTag_valid">
		<cfset loc.controller.endFormTag()>
	</cffunction>

</cfcomponent>
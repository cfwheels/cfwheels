<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_hiddenFieldTag_valid">
		<cfset loc.controller.hiddenFieldTag(name="userId", value="tony")>
	</cffunction>

</cfcomponent>
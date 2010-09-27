<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_textFieldTag_valid">
		<cfset loc.controller.textFieldTag(name="someName")>
	</cffunction>

</cfcomponent>
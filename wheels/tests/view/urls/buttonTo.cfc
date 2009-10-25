<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_x_buttonTo_valid">
		<cfset global.controller.buttonTo(text="Delete Account", action="perFormDelete", disabled="Wait...")>
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_x_textFieldTag_valid">
		<cfset global.controller.textFieldTag(name="someName")>
	</cffunction>

</cfcomponent>
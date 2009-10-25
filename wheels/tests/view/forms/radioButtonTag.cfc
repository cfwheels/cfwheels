<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_x_radioButtonTag_valid">
		<cfset global.controller.radioButtonTag(name="gender", value="m", label="Male", checked=true)>
	</cffunction>

</cfcomponent>
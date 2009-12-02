<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_x_checkBoxTag_valid">
		<cfset loc.controller.checkBoxTag(name="suscribe", value="true", label="Suscribe to our newsletter", checked=false)>
	</cffunction>

</cfcomponent>
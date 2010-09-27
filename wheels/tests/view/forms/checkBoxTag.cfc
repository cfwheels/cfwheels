<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_checkBoxTag_valid">
		<cfset loc.controller.checkBoxTag(name="suscribe", value="true", label="Suscribe to our newsletter", checked=false)>
	</cffunction>

</cfcomponent>
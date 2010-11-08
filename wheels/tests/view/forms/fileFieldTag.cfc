<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_x_fileFieldTag_valid">
		<cfset loc.controller.fileFieldTag(name="photo")>
	</cffunction>

</cfcomponent>
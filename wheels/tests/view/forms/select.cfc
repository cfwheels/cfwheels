<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>
	<cfset loadModels("users")>

	<cffunction name="test_x_select_valid">
		<cfset loc.users = loc.user.findAll()>
	    <cfset global.controller.select(objectName="user", property="firstname", options=loc.users)>
	</cffunction>

</cfcomponent>
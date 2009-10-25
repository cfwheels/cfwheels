<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.tests._assets.controllers.ControllerWithModel")>
	<cfinclude template="/wheelsmapping/tests/_assets/testhelpers/load_models.cfm">
	<cfset load_Models("users")>

	<cffunction name="test_x_select_valid">
		<cfset loc.users = loc.user.findAll()>
	    <cfset global.controller.select(objectName="ModelUsers1", property="firstname", options=loc.users)>
	</cffunction>

</cfcomponent>
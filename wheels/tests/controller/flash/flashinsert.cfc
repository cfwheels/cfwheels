<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy").$createControllerObject({controller="dummy",action="dummy"})>

	<cffunction name="test_flashInsert_valid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset assert("session.flash.success IS 'Congrats!'")>
	</cffunction>
	
</cfcomponent>

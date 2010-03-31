<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy").$createControllerObject({controller="dummy",action="dummy"})>

	<cffunction name="test_flashIsEmpty_valid">
		<cfset session.flash = {}>
		<cfset result = controller.flashIsEmpty()>
		<cfset assert("result IS StructIsEmpty(session.flash)")>
	</cffunction>
	
	<cffunction name="test_flashIsEmpty_invalid">
		<cfset session.flash = {success="congrats!"}>
		<cfset result = controller.flashIsEmpty()>
		<cfset assert("result IS StructIsEmpty(session.flash)")>
	</cffunction>
	
</cfcomponent>
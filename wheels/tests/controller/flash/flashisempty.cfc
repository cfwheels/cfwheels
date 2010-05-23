<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

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
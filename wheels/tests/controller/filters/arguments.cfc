<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params = {controller="filtering", action="index"}>	
	<cfset controller = $controller(name="filtering").$createControllerObject(params)>

</cfcomponent>
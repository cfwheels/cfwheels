<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy").$createControllerObject({controller="dummy",action="dummy"})>

	<cffunction name="test_flashClear_valid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashClear()>
		<cfset result = StructKeyList(controller.flash())>
		<cfset assert("result IS ''")>
	</cffunction>
	
</cfcomponent>

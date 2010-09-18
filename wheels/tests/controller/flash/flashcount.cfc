<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_flashCount_valid">
		<cfset run_flashCount_valid()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_flashCount_valid()>
	</cffunction>
	
	<cffunction name="run_flashCount_valid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashInsert(anotherKey="Test!")>
		<cfset result = controller.flashCount()>
		<cfset compare = controller.flashCount()>
		<cfset assert("result IS compare")>
	</cffunction>

</cfcomponent>

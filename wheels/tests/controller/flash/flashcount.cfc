<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_flashCount_valid">
		<cfset run_flashCount_valid()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_flashCount_valid()>
	</cffunction>
	
	<cffunction name="run_flashCount_valid">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset loc.controller.flashInsert(anotherKey="Test!")>
		<cfset result = loc.controller.flashCount()>
		<cfset compare = loc.controller.flashCount()>
		<cfset assert("result IS compare")>
	</cffunction>

</cfcomponent>

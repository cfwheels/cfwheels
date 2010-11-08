<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_flashIsEmpty_valid">
		<cfset run_flashIsEmpty_valid()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_flashIsEmpty_valid()>
	</cffunction>
	
	<cffunction name="run_flashIsEmpty_valid">
		<cfset loc.controller.flashClear()>
		<cfset result = loc.controller.flashIsEmpty()>
		<cfset assert("result IS true")>
	</cffunction>

	<cffunction name="test_flashIsEmpty_invalid">
		<cfset run_flashIsEmpty_invalid()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_flashIsEmpty_invalid()>
	</cffunction>
	
	<cffunction name="run_flashIsEmpty_invalid">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset result = loc.controller.flashIsEmpty()>
		<cfset assert("result IS false")>
	</cffunction>

</cfcomponent>
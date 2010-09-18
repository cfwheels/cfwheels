<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_flashIsEmpty_valid">
		<cfset run_flashIsEmpty_valid()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_flashIsEmpty_valid()>
	</cffunction>
	
	<cffunction name="run_flashIsEmpty_valid">
		<cfset controller.flashClear()>
		<cfset result = controller.flashIsEmpty()>
		<cfset assert("result IS true")>
	</cffunction>

	<cffunction name="test_flashIsEmpty_invalid">
		<cfset test_flashIsEmpty_invalid()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset test_flashIsEmpty_invalid()>
	</cffunction>
	
	<cffunction name="test_flashIsEmpty_invalid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset result = controller.flashIsEmpty()>
		<cfset assert("result IS false")>
	</cffunction>

</cfcomponent>
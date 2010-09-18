<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_flashClear_valid">
		<cfset run_flashClear_valid()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_flashClear_valid()>
	</cffunction>
	
	<cffunction name="run_flashClear_valid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashClear()>
		<cfset result = StructKeyList(controller.flash())>
		<cfset assert("result IS ''")>
	</cffunction>

</cfcomponent>

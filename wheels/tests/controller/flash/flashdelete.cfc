<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_flashDelete_invalid">
		<cfset run_flashDelete_invalid()>
		<cfset application.wheels.flashStorage = "cookie">
		<cfset run_flashDelete_invalid()>
	</cffunction>

	<cffunction name="run_flashDelete_invalid">
		<cfset controller.flashClear()>
		<cfset result = controller.flashDelete(key="success")>
		<cfset assert("result IS false")>
	</cffunction>
	
	<cffunction name="test_flashDelete_valid">
		<cfset run_flashDelete_valid()>
		<cfset application.wheels.flashStorage = "cookie">
		<cfset run_flashDelete_valid()>
	</cffunction>

	<cffunction name="run_flashDelete_valid">
		<cfset controller.flashClear()>
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset result = controller.flashDelete(key="success")>
		<cfset assert("result IS true")>
	</cffunction>
	
</cfcomponent>
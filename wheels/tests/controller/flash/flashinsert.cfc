<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_flashInsert_valid">
		<cfset run_flashInsert_valid()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_flashInsert_valid()>
	</cffunction>
	
	<cffunction name="run_flashInsert_valid">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset assert("controller.flash('success') IS 'Congrats!'")>
	</cffunction>

	<cffunction name="test_flashInsert_mulitple">
		<cfset run_flashInsert_mulitple()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_flashInsert_mulitple()>
	</cffunction>
	
	<cffunction name="run_flashInsert_mulitple">
		<cfset controller.flashInsert(success="Hooray!!!", error="WTF!")>
		<cfset assert("controller.flash('success') IS 'Hooray!!!'")>
		<cfset assert("controller.flash('error') IS 'WTF!'")>
	</cffunction>

</cfcomponent>

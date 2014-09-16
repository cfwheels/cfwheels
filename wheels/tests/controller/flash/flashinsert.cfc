<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_flashInsert_valid">
		<cfset run_flashInsert_valid()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_flashInsert_valid()>
	</cffunction>
	
	<cffunction name="run_flashInsert_valid">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset assert("loc.controller.flash('success') IS 'Congrats!'")>
	</cffunction>

	<cffunction name="test_flashInsert_mulitple">
		<cfset run_flashInsert_mulitple()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_flashInsert_mulitple()>
	</cffunction>
	
	<cffunction name="run_flashInsert_mulitple">
		<cfset loc.controller.flashInsert(success="Hooray!!!", error="WTF!")>
		<cfset assert("loc.controller.flash('success') IS 'Hooray!!!'")>
		<cfset assert("loc.controller.flash('error') IS 'WTF!'")>
	</cffunction>

</cfcomponent>

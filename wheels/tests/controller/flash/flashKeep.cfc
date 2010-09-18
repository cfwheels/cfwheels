<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setup.cfm">
	
	<cffunction name="test_flashKeep_saves_flash_items">
		<cfset run_flashKeep_saves_flash_items()>
		<cfset controller.$setFlashStorage("cookie")>
		<cfset run_flashKeep_saves_flash_items()>
	</cffunction>

	<cffunction name="run_flashKeep_saves_flash_items">
		<cfset controller.flashInsert(tony="Petruzzi", per="Djurner", james="Gibson")>
		<cfset controller.flashKeep("per,james")>
		<cfset controller.$flashClear()>
		<cfset assert('controller.flashCount() eq 2')>
		<cfset assert('!controller.flashKeyExists("tony")')>
		<cfset assert('controller.flashKeyExists("per")')>
		<cfset assert('controller.flashKeyExists("james")')>
		<cfset assert('controller.flash("per") eq "Djurner"')>
		<cfset assert('controller.flash("james") eq "Gibson"')>
	</cffunction>
	
</cfcomponent>
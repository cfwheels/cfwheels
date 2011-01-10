<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setup.cfm">
	
	<cffunction name="test_flashKeep_saves_flash_items">
		<cfset run_flashKeep_saves_flash_items()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_flashKeep_saves_flash_items()>
	</cffunction>
	
	<cffunction name="test_flashKeep_saves_flash_entire">
		<cfset run_flashKeep_saves_flash_entire()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_flashKeep_saves_flash_entire()>
	</cffunction>

	<cffunction name="run_flashKeep_saves_flash_items">
		<cfset loc.controller.flashInsert(tony="Petruzzi", per="Djurner", james="Gibson")>
		<cfset loc.controller.flashKeep("per,james")>
		<cfset loc.controller.$flashClear()>
		<cfset assert('loc.controller.flashCount() eq 2')>
		<cfset assert('!loc.controller.flashKeyExists("tony")')>
		<cfset assert('loc.controller.flashKeyExists("per")')>
		<cfset assert('loc.controller.flashKeyExists("james")')>
		<cfset assert('loc.controller.flash("per") eq "Djurner"')>
		<cfset assert('loc.controller.flash("james") eq "Gibson"')>
	</cffunction>
	
	<cffunction name="run_flashKeep_saves_flash_entire">
		<cfset loc.controller.flashInsert(tony="Petruzzi", per="Djurner", james="Gibson")>
		<cfset loc.controller.flashKeep()>
		<cfset loc.controller.$flashClear()>
		<cfset assert('loc.controller.flashCount() eq 3')>
		<cfset assert('loc.controller.flashKeyExists("tony")')>
		<cfset assert('loc.controller.flashKeyExists("per")')>
		<cfset assert('loc.controller.flashKeyExists("james")')>
		<cfset assert('loc.controller.flash("tony") eq "Petruzzi"')>
		<cfset assert('loc.controller.flash("per") eq "Djurner"')>
		<cfset assert('loc.controller.flash("james") eq "Gibson"')>
	</cffunction>
	
</cfcomponent>
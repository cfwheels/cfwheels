<cfcomponent extends="wheels.test">

	<cfinclude template="testhelper.cfm">

	<cffunction name="test_installing_and_uninstall_lastest_version_of_plugin">
		<cfset loc = {}>
		<cfset loc.e = "0.3.5">
		<cfset loc.r = global.plugins.$installPlugin("TestScaffold")>
		<cfset assert("!structisempty(loc.r)")>
		<cfset assert("loc.r.version eq loc.e")>
		<cfset assert("global.plugins.$isInstalledPlugin('TestScaffold', loc.e) eq true")>
		<cfset global.plugins.$uninstallPlugin('TestScaffold', loc.e)>
		<cfset assert("global.plugins.$isInstalledPlugin('TestScaffold', loc.e) eq false")>
	</cffunction>

	<cffunction name="test_installing_and_uninstall_previous_version_of_plugin">
		<cfset loc = {}>
		<cfset loc.e = "0.3.1">
		<cfset loc.r = global.plugins.$installPlugin("TestScaffold", loc.e)>
		<cfset assert("!structisempty(loc.r)")>
		<cfset assert("loc.r.version eq loc.e")>
		<cfset assert("global.plugins.$isInstalledPlugin('TestScaffold', loc.e) eq true")>
		<cfset global.plugins.$uninstallPlugin('TestScaffold', loc.e)>
		<cfset assert("global.plugins.$isInstalledPlugin('TestScaffold', loc.e) eq false")>
	</cffunction>

	<cffunction name="test_installing_and_uninstall_nonexistent_version_of_plugin_which_should_install_the_latest">
		<cfset loc = {}>
		<cfset loc.e = "0.3.5">
		<cfset loc.r = global.plugins.$installPlugin("TestScaffold", "0.1.9")>
		<cfset assert("!structisempty(loc.r)")>
		<cfset assert("loc.r.version eq loc.e")>
		<cfset assert("global.plugins.$isInstalledPlugin('TestScaffold', loc.e) eq true")>
		<cfset global.plugins.$uninstallPlugin('TestScaffold', loc.e)>
		<cfset assert("global.plugins.$isInstalledPlugin('TestScaffold', loc.e) eq false")>
	</cffunction>

</cfcomponent>
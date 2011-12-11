<cfcomponent>

	<cfinclude template="testhelper.cfm">

	<cffunction name="test_repo_exists">
		<cfset assert("global.plugins.$existsRepo(global.repo)")>
	</cffunction>

	<cffunction name="test_repo_set">
		<cfset assert("global.plugins.$getRepo() eq global.repo")>
	</cffunction>

	<cffunction name="test_repo_lists_correct_number_of_available_plugins_and_version">
		<cfset loc = {}>
		<cfset loc.plugins = global.plugins.$inspectPlugins()>
		<cfset halt(false, "loc.plugins")>
		<cfset assert("StructKeyExists(loc.plugins, 'TestScaffold')")>
		<cfset assert("arraylen(loc.plugins['TestScaffold']) eq 2")>
		<cfset assert("StructKeyExists(loc.plugins, 'TestModelValidators')")>
		<cfset assert("arraylen(loc.plugins['TestModelValidators']) eq 1")>
		<cfset assert("StructKeyExists(loc.plugins, 'TestFlashHelpers')")>
		<cfset assert("arraylen(loc.plugins['TestFlashHelpers']) eq 1")>
	</cffunction>

	<cffunction name="test_get_latest_version_of_a_plugin">
		<cfset loc = {}>
		<cfset loc.plugin = global.plugins.$selectPlugin("TestScaffold")>
		<cfset halt(false, "loc.plugin")>
		<cfset loc.r = loc.plugin.version>
		<cfset loc.e = "0.3.5">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_get_particular_version_of_a_plugin">
		<cfset loc = {}>
		<cfset loc.plugin = global.plugins.$selectPlugin(name="TestScaffold", version="0.3.1")>
		<cfset halt(false, "loc.plugin")>
		<cfset loc.r = loc.plugin.version>
		<cfset loc.e = "0.3.1">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_get_nonexistent_version_of_a_plugin_should_get_latest_version">
		<cfset loc = {}>
		<cfset loc.plugin = global.plugins.$selectPlugin(name="TestScaffold", version="0.1.9")>
		<cfset halt(false, "loc.plugin")>
		<cfset loc.r = loc.plugin.version>
		<cfset loc.e = "0.3.5">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
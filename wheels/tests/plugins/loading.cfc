<cfcomponent extends="wheels.test">

	<cfinclude template="testhelper.cfm">

	<cffunction name="test_loading_and_unloading_plugin">
		<cfset loc = {}>
		<cfset global.plugins.$installPlugin("TestScaffold")>
		<cfset global.plugins.$loadPlugin("TestScaffold")>
		<cfset assert("global.plugins.$isloadedPlugin('TestScaffold') eq true")>
		<cfset global.plugins.$uninstallPlugin("TestScaffold")>
		<cfset assert("global.plugins.$isloadedPlugin('TestScaffold') eq false")>
	</cffunction>

	<cffunction name="testing_cannot_load_incompatable_plugins">
		<cfset loc = {}>
		<cfset global.plugins.$installPlugin("TestScaffold")>
		<cfset global.plugins.$installPlugin("TestScaffoldIncompatable")>
		<cfset global.plugins.$loadPlugin("TestScaffold")>
		<cfset assert("global.plugins.$isloadedPlugin('TestScaffold') eq true")>
		<cfset loc.e = raised("global.plugins.$loadPlugin('TestScaffoldIncompatable')")>
		<cfset loc.r = "Wheels.IncompatiblePlugin">
		<cfset assert("loc.e eq loc.r")>
		<cfset global.plugins.$uninstallPlugin("TestScaffold")>
		<cfset global.plugins.$uninstallPlugin("TestScaffoldIncompatable")>
	</cffunction>

</cfcomponent>
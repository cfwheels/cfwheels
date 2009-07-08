<cfcomponent extends="wheels.test">

	<cfinclude template="testhelper.cfm">
	
	<cffunction name="_setup">
		<cfset global.plugins.$installPlugin("TestScaffold")>
		<cfset global.plugins.$installPlugin("TestScaffoldIncompatable")>
	</cffunction>
	
	<cffunction name="_teardown">
		<cfset global.plugins.$uninstallPlugin("TestScaffold")>
		<cfset global.plugins.$uninstallPlugin("TestScaffoldIncompatable")>
	</cffunction>

	<cffunction name="test_loading_and_unloading_plugin">
		<cfset global.plugins.$unloadAllPlugins()>
		<cfset global.plugins.$loadPlugin("TestScaffold")>
		<cfset assert("global.plugins.$isloadedPlugin('TestScaffold') eq true")>
 		<cfset global.plugins.$unloadPlugin("TestScaffold")>
		<cfset assert("global.plugins.$isloadedPlugin('TestScaffold') eq false")>
	</cffunction>

	<cffunction name="test_cannot_load_incompatable_plugins">
		<cfset loc = {}>
		<cfset global.plugins.$loadPlugin("TestScaffold")>
		<cfset assert("global.plugins.$isloadedPlugin('TestScaffold') eq true")>
		<cfset loc.e = raised("global.plugins.$loadPlugin('TestScaffoldIncompatable')")>
		<cfset loc.r = "Wheels.IncompatiblePlugin">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
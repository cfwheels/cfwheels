<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.config = {
			path="wheels"
			,fileName="Plugins"
			,method="init"
			,pluginPath="/wheelsMapping/tests/_assets/plugins/overwriting"
			,deletePluginDirectories=false
			,overwritePlugins=true
			,loadIncompatiblePlugins=true
		}>
		
		<cfset $writeTestFile()>
	</cffunction>
	
	<cffunction name="$pluginObj">
		<cfargument name="config" type="struct" required="true">
		<cfreturn $createObjectFromRoot(argumentCollection=arguments.config)>
	</cffunction>
	
	<cffunction name="$writeTestFile">
		<cffile action="write" file="#$testFile()#" output="overwritten" addnewline="false">
	</cffunction>
	
	<cffunction name="$readTestFile">
		<cfset var FileContent = "">
		<cffile action="read" file="#$testFile()#" variable="FileContent">
		<cfreturn FileContent>
	</cffunction>
	
	<cffunction name="$testFile">
		<cfset var theFile = "">
		<cfset theFile = [loc.config.pluginPath, "TestGlobalMixins", "index.cfm"]>
		<cfset theFile = ExpandPath(ArrayToList(theFile, "/"))>
		<cfreturn theFile>
	</cffunction>

	<cffunction name="test_overwrite_plugins">
		<cfset loc.fileContentBefore = $readTestFile()>
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.fileContentAfter = $readTestFile()>
		<cfset assert('loc.fileContentBefore eq "overwritten"')>
		<cfset assert('loc.fileContentAfter neq "overwritten"')>
	</cffunction>
	
	<cffunction name="test_do_not_overwrite_plugins">
		<cfset loc.config.overwritePlugins = false>
		<cfset loc.fileContentBefore = $readTestFile()>
		<cfset loc.PluginObj = $pluginObj(loc.config)>
		<cfset loc.fileContentAfter = $readTestFile()>
		<cfset assert('loc.fileContentBefore eq "overwritten"')>
		<cfset assert('loc.fileContentAfter eq "overwritten"')>
	</cffunction>
	
</cfcomponent>
<cfscript>
system = createObject("java", "java.lang.System");

paths = [
	'eventPath'
	,'filePath'
	,'imagePath'
	,'javascriptPath'
	,'modelPath'
	,'modelComponentPath'
	,'pluginPath'
	,'pluginComponentPath'
	,'stylesheetPath'
	,'viewPath'
	,'controllerPath'
	,'assetQueryString'
	,'assetPaths'
];
environment = [
	'hostName'
	,'environment'
	,'allowEnvironmentSwitchViaUrl'
	,'redirectAfterReload'
	,'ipExceptions'
	,'showDebugInformation'
	,'urlRewriting'
];

csrf = [
	'csrfStore'
	,'csrfCookieEncryptionAlgorithm'
	,'csrfCookieEncryptionSecretKey'
	,'csrfCookieEncryptionEncoding'
	,'csrfCookieName'
	,'csrfCookieDomain'
	,'csrfCookieEncodeValue'
	,'csrfCookieHttpOnly'
	,'csrfCookiePath'
	,'csrfCookiePreserveCase'
	,'csrfCookieSecure'
];

cors = [
	'allowCorsRequests'
	,'accessControlAllowOrigin'
	,'accessControlAllowMethods'
	,'accessControlAllowMethodsByRoute'
	,'accessControlAllowCredentials'
	,'accessControlAllowHeaders'
];


settings =  [

	{
	  name: 'Error Handling',
	  values = [
		//'errorEmailServer' // Check this
		'errorEmailAddress'
		,'errorEmailSubject'
		,'excludeFromErrorEmail'
		,'sendEmailOnError'
		,'showErrorInformation'
		]
	},
	{
	  name: 'Caching',
	  values = [
		//'cacheRoutes' // Check this
		'cacheActions'
		,'cacheControllerConfig'
		,'cacheCullInterval'
		,'cacheCullPercentage'
		,'cacheDatabaseSchema'
		,'cacheFileChecking'
		,'cacheImages'
		,'cacheModelConfig'
		,'cachePages'
		,'cachePartials'
		,'cacheQueries'
		,'clearQueryCacheOnReload'
		,'defaultCacheTime'
		,'maximumItemsToCache'
		]
	},
	{
	  name: 'Migrator',
	  values = [
	'autoMigrateDatabase'
	,'migratorTableName'
	,'createMigratorTable'
	,'writeMigratorSQLFiles'
	,'migratorObjectCase'
	,'allowMigrationDown'
		]
	},
	{
	  name: 'Plugins',
	  values = [
	'deletePluginDirectories'
	,'loadIncompatiblePlugins'
	,'overwritePlugins'
	,'showIncompatiblePlugins'
		]
	},
	{
	  name: 'Models',
	  values = [

	//'afterFindCallbackLegacySupport' // Check
	'automaticValidations'
	,'setUpdatedAtOnCreate'
	,'softDeleteProperty'
	,'tableNamePrefix'
	,'timeStampOnCreateProperty'
	,'timeStampOnUpdateProperty'
	,'transactionMode'
	,'useExpandedColumnAliases'
	,'modelRequireConfig'
		]
	},
	{
	  name: 'Other',
	  values = [
	//'loadDefaultRoutes' Check
	'obfuscateUrls'
	,'booleanAttributes'
	//,'disableEngineCheck'
	,'encodeURLs'
	,'encodeHtmlTags'
	,'encodeHtmlAttributes'
	,'uncountables'
	,'irregulars'
	,'flashAppend'
	,'formats'
	,'mimetypes'
		]
	}
];

</cfscript>

<cfinclude template="../layout/_header.cfm">

<cfoutput>
<div class="ui container">

#pageHeader("System Information", "Note, these settings reflect the currently loaded environment")#

<div class="ui top attached tabular menu stackable">
		<a class="item active" data-tab="system">System</a>
		<a class="item" data-tab="security">Security</a>
	<cfloop array="#settings#" item="s" index="i">
		<a class="item" data-tab="tab-#i#">#s.name#</a>
	</cfloop>
</div>
#startTab(tab='system', active=true)#

	#startTable("System")#
		<tr>
			<td class='four wide'>CFML Engine</td>
			<td class='eight wide'>#get("serverName")# #get("serverVersion")#</td>
		</tr>
		<tr>
			<td>CFWheels Version</td><td>#get("version")#</td>
		</tr>
		<tr>
			<td>Datasource Name</td><td>#get("dataSourceName")#</td>
		</tr>
		<tr>
			<td>Java Runtime</td><td>#system.getProperty("java.runtime.name")#</td>
		</tr>
		<tr>
			<td>Java Version</td><td>#system.getProperty("java.version")#</td>
		</tr>
	#endTable()#

	#startTable("Environment")#
		#outputSetting(environment)#
	#endTable()#

	#startTable("Paths")#
		#outputSetting(paths)#
	#endTable()#
#endTab()#

#startTab(tab='security')#

	#startTable("CSRF")#
		#outputSetting(csrf)#
	#endTable()#

	#startTable("CORS")#
		#outputSetting(cors)#
	#endTable()#

#endTab()#

<cfloop array="#settings#" item="s" index="i">
	#startTab(tab='tab-#i#')#
		#startTable(s.name)#
			#outputSetting(s.values)#
		#endTable()#
	#endTab()#
</cfloop>
</div>

<cfinclude template="../layout/_footer.cfm">
</cfoutput>

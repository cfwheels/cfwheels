<cfscript>
system = CreateObject("java", "java.lang.System");

paths = [
	'eventPath',
	'filePath',
	'imagePath',
	'javascriptPath',
	'modelPath',
	'modelComponentPath',
	'pluginPath',
	'pluginComponentPath',
	'stylesheetPath',
	'viewPath',
	'controllerPath',
	'assetQueryString',
	'assetPaths'
];

components = ['enablePluginsComponent', 'enableMigratorComponent', 'enablePublicComponent'];
environment = [
	'hostName',
	'environment',
	'allowEnvironmentSwitchViaUrl',
	'redirectAfterReload',
	'ipExceptions',
	'showDebugInformation',
	'urlRewriting'
];

csrf = [
	'csrfStore',
	'csrfCookieEncryptionAlgorithm',
	'csrfCookieEncryptionSecretKey',
	'csrfCookieEncryptionEncoding',
	'csrfCookieName',
	'csrfCookieDomain',
	'csrfCookieEncodeValue',
	'csrfCookieHttpOnly',
	'csrfCookiePath',
	'csrfCookiePreserveCase',
	'csrfCookieSecure'
];

cors = [
	'allowCorsRequests',
	'accessControlAllowOrigin',
	'accessControlAllowMethods',
	'accessControlAllowMethodsByRoute',
	'accessControlAllowCredentials',
	'accessControlAllowHeaders'
];


settings = [
	{
		name = 'Error Handling',
		values = [
			// 'errorEmailServer' // Check this
			'errorEmailAddress',
			'errorEmailSubject',
			'excludeFromErrorEmail',
			'sendEmailOnError',
			'showErrorInformation'
		]
	},
	{
		name = 'Caching',
		values = [
			// 'cacheRoutes' // Check this
			'cacheActions',
			'cacheControllerConfig',
			'cacheCullInterval',
			'cacheCullPercentage',
			'cacheDatabaseSchema',
			'cacheDatePart',
			'cacheFileChecking',
			'cacheImages',
			'cacheModelConfig',
			'cachePages',
			'cachePartials',
			'cacheQueries',
			'cacheQueriesDuringRequest',
			'clearQueryCacheOnReload',
			'defaultCacheTime',
			'maximumItemsToCache'
		]
	},
	{
		name = 'Migrator',
		values = [
			'autoMigrateDatabase',
			'migratorTableName',
			'createMigratorTable',
			'writeMigratorSQLFiles',
			'migratorObjectCase',
			'allowMigrationDown'
		]
	},
	{
		name = 'Plugins',
		values = [
			'deletePluginDirectories',
			'loadIncompatiblePlugins',
			'overwritePlugins',
			'showIncompatiblePlugins'
		]
	},
	{
		name = 'Models',
		values = [
			// 'afterFindCallbackLegacySupport' // Check
			'automaticValidations',
			'setUpdatedAtOnCreate',
			'softDeleteProperty',
			'tableNamePrefix',
			'timeStampOnCreateProperty',
			'timeStampOnUpdateProperty',
			'transactionMode',
			'useExpandedColumnAliases',
			'modelRequireConfig'
		]
	},
	{
		name = 'Other',
		values = [
			// 'loadDefaultRoutes' Check
			'obfuscateUrls',
			'booleanAttributes',
			// ,'disableEngineCheck'
			'encodeURLs',
			'encodeHtmlTags',
			'encodeHtmlAttributes',
			'uncountables',
			'irregulars',
			'flashAppend',
			'formats',
			'mimetypes'
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
			<cfloop from="1" to="#ArrayLen(settings)#" index="s">
				<a class="item" data-tab="tab-#s#">#settings[s]['name']#</a>
			</cfloop>
			<a class="item" data-tab="utils">Utils</a>
		</div>
		#startTab(tab = 'system', active = true)#

		#startTable("System")#
		<tr>
			<td class='four wide'>CFML Engine</td>
			<td class='eight wide'>#get("serverName")##get("serverVersion")#</td>
		</tr>
		<tr>
			<td>CFWheels Version</td>
			<td>#get("version")#</td>
		</tr>
		<tr>
			<td>Java Runtime</td>
			<td>#system.getProperty("java.runtime.name")#</td>
		</tr>
		<tr>
			<td>Java Version</td>
			<td>#system.getProperty("java.version")#</td>
		</tr>
		#endTable()#

		#startTable("Database")#

		<cfscript>
		try {
			db = $$getAllDatabaseInformation();
		} catch (any e) {
			dbError = e;
		}
		</cfscript>

		<tr>
			<td class='four wide'>Datasource Name</td>
			<td class='eight wide'>#get("dataSourceName")#</td>
		</tr>

		<cfif IsDefined("dbError")>
			<tr>
				<td colspan="2">
					<div class="ui error message">
						<div class="header">#dbError.message#</div>
						#dbError.detail#
					</div>
				</td>
			</tr>
		<cfelse>
			<tr>
				<td>Migrator Adapter Name</td>
				<td>#db.adapterName#</td>
			</tr>
			<tr>
				<td>Product Name</td>
				<td>#db.info.database_productName#</td>
			</tr>
			<tr>
				<td>Version</td>
				<td>#db.info.database_version#</td>
			</tr>
			<tr>
				<td>Driver Name</td>
				<td>#db.info.driver_name#</td>
			</tr>
			<tr>
				<td>Driver Version</td>
				<td>#db.info.driver_version#</td>
			</tr>
			<tr>
				<td>JDBC Version</td>
				<td>#db.info.jdbc_major_version#.#db.info.jdbc_minor_version#</td>
			</tr>
		</cfif>
		#endTable()#

		#startTable("Environment")#
		#outputSetting(environment)#
		#endTable()#

		#startTable("Paths")#
		#outputSetting(paths)#
		#endTable()#

		#startTable("Components")#
		#outputSetting(components)#
		#endTable()#

		#endTab()#

		#startTab(tab = 'security')#

		#startTable("CSRF")#
		#outputSetting(csrf)#
		#endTable()#

		#startTable("CORS")#
		#outputSetting(cors)#
		#endTable()#

		#endTab()#

		<cfloop from="1" to="#ArrayLen(settings)#" index="s">
			#startTab(tab = 'tab-#s#')#
			#startTable(settings[s]['name'])#
			#outputSetting(settings[s]['values'])#
			#endTable()#
			#endTab()#
		</cfloop>

		#startTab(tab = 'utils')#
		<div class="ui three column grid">
			<div class="column">
				<div class="ui card fluid">
					<div class="content">
						<div class="header">Documentation</div>
						<div class="description">
							<p>Download generated documentation as JSON</p>
							<a href="#urlFor(route = "wheelsDocs", params = "format=json")#" target="_blank" ,>
								<i class='icon download'></i>
								Export Docs as JSON
							</a>
						</div>
					</div>
				</div>
			</div>
			<div class="column">
				<div class="ui card fluid">
					<div class="content">
						<div class="header">Build Release</div>
						<div class="description">
							<p>Build a zip for production distribution</p>
							<a href="#urlFor(route = "wheelsBuild")#" target="_blank">
								<i class='icon zip'></i>
								Create Zip
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
		#endTab()#
	</div>
	<!--/container-->

	<cfinclude template="../layout/_footer.cfm">
</cfoutput>

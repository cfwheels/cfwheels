<cfapplication name="myAppName" clientmanagement="false" sessionmanagement="true">
<!--- 
	IMPORTANT: Only use this file if you have ColdFusion MX 6.1
	If you have ColdFusion MX 7 or higher you should use Application.cfc instead and can safely delete this file
--->

<cfif NOT structKeyExists(application, "initialized")>
	
	<cflock scope="application" type="exclusive" timeout="30">

		<!--- Include settings from the user --->
		<cfset application.settings = structNew()>
		<cfinclude template="/config/environment.cfm" />
		<cfinclude template="/config/database.cfm" />

		<!--- Component paths --->
		<cfset application.componentPathTo = structNew()>
		<cfset application.filePathTo = structNew()>
		<cfset application.componentPathTo.controllers = "app.controllers">
		<cfset application.filePathTo.controllers = "/app/controllers">
		<cfset application.componentPathTo.models = "app.models">
		<cfset application.filePathTo.models = "/app/models">
		<cfset application.componentPathTo.generatedModels = application.componentPathTo.models & ".generated">
		<cfset application.filePathTo.generatedModels = application.filePathTo.models & "/generated">
		
		<!--- App directory paths --->
		<cfset application.pathTo = structNew()>
		<cfset application.pathTo.app = "/app">
		<cfset application.pathTo.views = application.pathTo.app & "/views">
		<cfset application.pathTo.layouts = application.pathTo.views & "/layouts">
		<cfset application.pathTo.helpers = application.pathTo.app & "/helpers">
		<cfset application.pathTo.includes = application.settings.folderLocation & "/includes">
		<cfset application.pathTo.config = "/config">
		
		<!--- Default public paths --->
		<cfset application.pathTo.images = "/images">
		<cfset application.pathTo.stylesheets = "/stylesheets">
		<cfset application.pathTo.javascripts = "/javascripts">
		
		<!--- File system paths --->
		<cfset application.pathTo.webroot = expandPath("/")>
		<cfset application.pathTo.cfwheels = expandPath(application.settings.folderLocation)>
		
		<!--- Setup some sensible defaults --->
		<cfset application.default = structNew()>
		<cfset application.default.action = "index">
		<cfset application.default.errorPages = structNew()>
		<cfset application.default.errorPages.404 = "/404.cfm">
		<cfset application.default.errorPages.pageNotFound = "/404.cfm">
		<cfset application.default.errorPages.500 = "/500.cfm">
		<cfset application.default.errorPages.applicationError = "/500.cfm">
		
		<!--- Include some Wheels specific stuff --->
		<cfinclude template="#application.pathTo.includes#/application_includes.cfm">
		
		<!--- Take the framework functions and save them to application --->
		<cfset application.core = structNew()>
		<cfinclude template="#application.pathTo.includes#/core_includes.cfm">

	</cflock>

	<cfset application.initialized = true>

</cfif>
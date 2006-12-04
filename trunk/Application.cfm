<!--- 
	IMPORTANT: Only use this file if you have ColdFusion MX 6.1
	If you have ColdFusion MX 7 or higher you should use Application.cfc instead and can safely delete this file
--->

<cfapplication name="#listLast(getDirectoryFromPath(getBaseTemplatePath()),'/')#" clientmanagement="false" sessionmanagement="true">

<cferror exception="cfwheels" template="/error.cfm" type="exception">

<!--- Reload all application variables --->
<cfif structKeyExists(url,'reload')>
	<cfset application.initialized = false>
</cfif>

<cfif NOT structKeyExists(application, "initialized") OR NOT application.initialized>
	
	<cflock scope="application" type="exclusive" timeout="10">

		<!--- Component paths --->
		<cfset application.componentPathTo = structNew()>
		<cfset application.filePathTo = structNew()>
		<cfset application.componentPathTo.controllers = "app.controllers">
		<cfset application.filePathTo.controllers = "/app/controllers">
		<cfset application.componentPathTo.models = "app.models">
		<cfset application.filePathTo.models = "/app/models">
		<!---
		<cfset application.componentPathTo.generatedModels = application.componentPathTo.models & ".generated">
		<cfset application.filePathTo.generatedModels = application.filePathTo.models & "/generated">
		--->
		
		<!--- App directory paths --->
		<cfset application.pathTo = structNew()>
		<cfset application.pathTo.app = "/app">
		<cfset application.pathTo.cfwheels = "/cfwheels">
		<cfset application.pathTo.config = "/config">
		<cfset application.pathTo.scripts = "/script/index.cfm">
		<cfset application.pathTo.views = application.pathTo.app & "/views">
		<cfset application.pathTo.layouts = application.pathTo.views & "/layouts">
		<cfset application.pathTo.helpers = application.pathTo.app & "/helpers">
		<cfset application.pathTo.includes = application.pathTo.cfwheels & "/includes">
		
		<!--- Default public paths --->
		<cfset application.pathTo.images = "/images">
		<cfset application.pathTo.stylesheets = "/stylesheets">
		<cfset application.pathTo.javascripts = "/javascripts">
		<cfset application.templates.pageNotFound = "/404.cfm">
		<cfset application.templates.applicationError = "/500.cfm">
		
		<!--- File system paths --->
		<cfset application.absolutePathTo = structNew()>
		<cfset application.absolutePathTo.webroot = expandPath("/")>
		<cfset application.absolutePathTo.cfwheels = expandPath(application.pathTo.cfwheels)>
		
		<!--- Create the defaults structure --->
		<cfset application.default = structNew()>
		
		<!--- Include some Wheels specific stuff --->
		<cfinclude template="#application.pathTo.includes#/application_includes.cfm">
		
		<!--- Take the framework functions and save them to application --->
		<cfset application.core = structNew()>
		<cfinclude template="#application.pathTo.includes#/core_includes.cfm">

		<!--- Include environment and database connection info --->
		<cfinclude template="#application.pathTo.config#/environment.ini" />
		<cfinclude template="#application.pathTo.config#/database.ini" />

	</cflock>

	<cfset application.initialized = true>

</cfif>

<!--- Clear out session data --->
<cfif structKeyExists(url,'clearsession')>
	<cfset structClear(session)>
</cfif>
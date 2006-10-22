<cfcomponent displayname="Application Controller" hint="The base class of all controllers">
	
	<!--- Include functions that should be available to all controllers --->
	<cfif fileExists(expandPath("#application.filePathTo.controllers#/application_functions.cfm"))>
		<cfinclude template="#application.filePathTo.controllers#/application_functions.cfm">
	</cfif>
	
	<cfset variables.beforeFilters = arrayNew(1)>
	<cfset variables.afterFilters = arrayNew(1)>

	<cffunction name="init" access="public" output="false" hint="Called when a controller is instantiated">
		
		<!--- Include common functions for everything --->
		<cfinclude template="#application.pathTo.includes#/controller_includes.cfm">
		
		<!--- Include helpers if they exist --->
		<cfif fileExists(expandPath("#application.pathTo.helpers#/application_helper.cfm"))>
			<cfinclude template="#application.pathTo.helpers#/application_helper.cfm">
		</cfif>
		<cfif fileExists(expandPath("#application.pathTo.helpers#/#request.params.controller#_helper.cfm"))>
			<cfinclude template="#application.pathTo.helpers#/#request.params.controller#_helper.cfm">
		</cfif>
		
		<cfreturn this>
	
	</cffunction>
	
	
	<cffunction name="renderToString" access="public" returntype="string" output="false" hint="Calls render and returns the results as a string">
		
		<cfreturn render(arguments=arguments, saveToString=true)>

	</cffunction>
	
	
	<cffunction name="render" access="public" returntype="string" output="true" hint="Renders all visual stuff for a given action">
		<!--- Types of rendering --->
		<cfargument name="action" type="string" required="false" default="" hint="The action to render">
		<cfargument name="controller" type="string" required="false" default="#request.params.controller#" hint="The controller to render">
		<cfargument name="file" type="string" required="false" default="" hint="The file to render (absolute path)">
		<cfargument name="template" type="string" required="false" default="" hint="The template to render (use relative path)">
		<cfargument name="partial" type="string" required="false" default="" hint="The partial to render">
		<cfargument name="text" type="string" required="false" default="" hint="String to render">
		<cfargument name="nothing" type="string" required="false" default="">
		<!--- layout and status applies to all types of rendering --->
		<cfargument name="layout" type="string" required="false" default="">
		<cfargument name="status" type="numeric" required="false" default=200>
		<!--- useFullPath applies to file rendering only --->
		<cfargument name="useFullPath" type="boolean" required="false" default="false" hint="If TRUE the rendering will be done relative to the template root (app/views). Applies to file rendering only">
		<!--- This is only set when called from the renderToString function above --->
		<cfargument name="saveToString" type="boolean" required="false" default="false" hint="If TRUE the result of the rendering will be returned as a string and not rendered to the browser">

		<cfset var arg = "">
		<cfset var renderResult = "">
		
		<!--- layout was not passed in so set the default for it depending on the type of rendering to be done --->
		<cfif arguments.layout IS "">
			<cfif arguments.action IS NOT "" OR arguments.template IS NOT "">
				<cfset arguments.layout = true>
			<cfelse>
				<cfset arguments.layout = false>		
			</cfif>
		</cfif>

		<!--- Never render a layout with the nothing option --->
		<cfif arguments.nothing IS true>
			<cfset arguments.layout = false>				
		</cfif>

		<cfif arguments.status IS NOT 200>
			<cfheader statusCode="#arguments.status#">
		</cfif>

		<cfif arguments.partial IS NOT "">
			<!--- Set local variables for partial --->
			<cfloop collection="#arguments#" item="arg">
				<cfif NOT listFindNoCase("action,controller,file,template,partial,text,nothing,layout,status,useFullPath,saveToString", arg)>
					<cfset "request._render.locals.#arg#" = evaluate("arguments.#arg#")>
				</cfif>
			</cfloop>
		</cfif>

		<!--- Set some variables to be used in contentForLayout (we want to be able to call this function without arguments from layout files) --->
		<cfset request._render.controller = arguments.controller>
		<cfif arguments.action IS NOT "">
			<cfset request._render.action = arguments.action>
		</cfif>
		<cfif arguments.file IS NOT "">
			<cfset request._render.file = arguments.file>
		</cfif>
		<cfif arguments.template IS NOT "">
			<cfset request._render.template = arguments.template>
		</cfif>
		<cfif arguments.partial IS NOT "">
			<cfset request._render.partial = arguments.partial>
		</cfif>
		<cfif arguments.text IS NOT "">
			<cfset request._render.text = arguments.text>
		</cfif>
		<cfif arguments.nothing IS NOT "">
			<cfset request._render.nothing = arguments.nothing>
		</cfif>
		<cfif arguments.useFullPath IS NOT "">
			<cfset request._render.useFullPath = arguments.useFullPath>
		</cfif>

		<cfsavecontent variable="renderResult">
			<cfif arguments.layout IS NOT false>
				<cfset renderLayout(argumentCollection=arguments)>
			<cfelse>
				<cfset contentForLayout()>
			</cfif>
		</cfsavecontent>
		
		<cfif arguments.saveToString IS TRUE>
			<cfreturn renderResult>
		<cfelse>
			#renderResult#
		</cfif>
	</cffunction>
	
	
	<cffunction name="renderLayout" access="public" returntype="void" output="true" hint="Includes the layout for the given controller">
		
		<cfif arguments.layout IS NOT true AND fileExists(expandPath("#application.pathTo.layouts#/#Replace(arguments.layout, " ", "_", "ALL")#_layout.cfm"))>
			<cfinclude template="#application.pathTo.layouts#/#Replace(arguments.layout, " ", "_", "ALL")#_layout.cfm" />
		<cfelseif fileExists(expandPath("#application.pathTo.layouts#/#arguments.controller#_layout.cfm"))>
			<cfinclude template="#application.pathTo.layouts#/#arguments.controller#_layout.cfm" />
		<cfelseif fileExists(expandPath("#application.pathTo.layouts#/application_layout.cfm"))>
			<cfinclude template="#application.pathTo.layouts#/application_layout.cfm" />
		<cfelse>
			<cfset contentForLayout()>
		</cfif>

	</cffunction>


	<cffunction name="contentForLayout" access="public" returntype="void" output="true" hint="Includes the current view">
		
		<cfset var filePathForPartial = application.pathTo.views>
		<cfset var templateArrayForPartial = "">
		<cfset var directoryForPartial = "">
		<cfset var filenameForPartial = "">
		<cfset var local = "">

		<cfif structKeyExists(request._render,'partial') AND request._render.partial IS NOT "">
			<cfif structKeyExists(request._render,'locals')>
				<cfloop collection="#request._render.locals#" item="local">
					<cfset "#local#" = evaluate("request._render.locals.#local#")>
				</cfloop>
			</cfif>
			<cfif request._render.partial Contains "/">
				<!--- this is a shared partial --->
				<cfset templateArrayForPartial = ListToArray(request._render.partial, "/")>
				<cfset directoryForPartial = templateArrayForPartial[1]>
				<cfset filenameForPartial = templateArrayForPartial[2]>
			<cfelse>
				<!--- this is a normal partial --->
				<cfset directoryForPartial = request._render.controller>
				<cfset filenameForPartial = request._render.partial>
			</cfif>
			<cfset filePathForPartial = "#filePathForPartial#/#directoryForPartial#/_#Replace(filenameForPartial, " ", "_", "ALL")#.cfm">
			<cfif fileExists(expandPath(filePathForPartial))>
				<cfinclude template="#filePathForPartial#" />
			</cfif>
			<cfset request._render.partial = "">
		<cfelseif structKeyExists(request._render,'action') AND request._render.action IS NOT "">
			<cfif fileExists(expandPath("#application.pathTo.views#/#request._render.controller#/#request._render.action#.cfm"))>
				<cfinclude template="#application.pathTo.views#/#request._render.controller#/#request._render.action#.cfm">
			</cfif>				
			<cfset request._render.action = "">
		<cfelseif structKeyExists(request._render,'file') AND request._render.file IS NOT "">
			<cfif request._render.useFullPath IS TRUE>
				<cfif fileExists(expandPath("#application.pathTo.views#/#request._render.file#"))>
					<cfinclude template="#application.pathTo.views#/#request._render.file#">
				</cfif>
			<cfelse>
				<cfif fileExists(request._render.file)>
					<cffile action="read" file="#request._render.file#" variable="filecontent">
					#filecontent#
				</cfif>			
			</cfif>
			<cfset request._render.file = "">
			<cfset request._render.useFullPath = "">
		<cfelseif structKeyExists(request._render,'template') AND request._render.template IS NOT "">
			<cfif fileExists(expandPath("#application.pathTo.views#/#request._render.template#.cfm"))>
				<cfinclude template="#application.pathTo.views#/#request._render.template#.cfm">
			</cfif>
			<cfset request._render.template = "">
		<cfelseif structKeyExists(request._render,'text') AND request._render.text IS NOT "">
			#request._render.text#
			<cfset request._render.text = "">
		<cfelseif structKeyExists(request._render,'nothing') AND request._render.nothing IS NOT "">
			<cfset request._render.nothing = "">
			<cfabort>
		</cfif>
		
	</cffunction>		
	
	
	<cffunction name="redirectTo" access="public" returntype="void" output="true" hint="Redirects to another page">
		<cfargument name="link" type="string" required="no" default="" hint="The full URL to link to (only use this when not using controller/action/id type links)">
		<cfargument name="back" type="boolean" required="no" default="false" hint="When true redirects back to the referring page">
		<cfargument name="token" type="boolean" required="false" default="false" hint="Whether or not to append the url token to the URL">
	
		<!---
		[DOCS:ARGUMENTS]
		URLFor
		[DOCS:ARGUMENTS END]
		--->
	
		<cfset var url = "">
	
		<cfif arguments.link IS NOT "">
			<cfset url = arguments.link>
		<cfelseif arguments.back>
			<cfif cgi.http_referer IS NOT "">
				<cfset url = cgi.http_referer>
			<cfelse>
				<cfset url = "/">
			</cfif>
		<cfelse>
			<cfset url = URLFor(argumentCollection=application.core.createArgs(args=arguments, skipArgs="link,back,token"))>
		</cfif>
	
		<cfif arguments.token>
			<cflocation url="#url#">
		<cfelse>
			<cflocation url="#url#" addtoken="false">
		</cfif>
			
	</cffunction>
	

	<cffunction name="beforeFilter" access="public" returntype="void" output="false" hint="adds a before filter">
		<cfargument name="filters" type="string" required="true" hint="The filter(s) to add">
		<cfargument name="only" type="string" required="false" default="" hint="Execute the supplied filter(s) for these actions only">
		<cfargument name="except" type="string" required="false" default="" hint="Execute the supplied filter(s) for all actions except these">
		
		<cfset var thisFilter = structNew()>

		<cfloop list="#arguments.filters#" index="filter">
			<cfset thisFilter = structNew()>
			<cfset thisFilter.filter = trim(filter)>
			<cfset thisFilter.only = replace(arguments.only, ", ", ",", "all")>
			<cfset thisFilter.except = replace(arguments.except, ", ", ",", "all")>
			<cfset arrayAppend(variables.beforeFilters, duplicate(thisFilter))>
		</cfloop>
		
	</cffunction>


	<cffunction name="afterFilter" access="public" returntype="void" output="false" hint="adds an after filter">
		<cfargument name="filters" type="string" required="true" hint="The filter(s) to add">
		<cfargument name="only" type="string" required="false" default="" hint="Execute the supplied filter(s) for these actions only">
		<cfargument name="except" type="string" required="false" default="" hint="Execute the supplied filter(s) for all actions except these">
		
		<cfset var thisFilter = structNew()>

		<cfloop list="#arguments.filters#" index="filter">
			<cfset thisFilter = structNew()>
			<cfset thisFilter.filter = trim(filter)>
			<cfset thisFilter.only = replace(arguments.only, ", ", ",", "all")>
			<cfset thisFilter.except = replace(arguments.except, ", ", ",", "all")>
			<cfset arrayAppend(variables.afterFilters, duplicate(thisFilter))>
		</cfloop>
		
	</cffunction>
	
	
	<cffunction name="getBeforeFilters" access="public" returntype="array" output="false" hint="Returns the beforeFilters for this controller">
	
		<cfreturn variables.beforeFilters>
	
	</cffunction>
	
	
	<cffunction name="getAfterFilters" access="public" returntype="array" output="false" hint="Returns the beforeFilters for this controller">
	
		<cfreturn variables.afterFilters>
	
	</cffunction>
	

</cfcomponent>

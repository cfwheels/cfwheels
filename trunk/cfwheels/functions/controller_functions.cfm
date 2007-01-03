<cffunction name="init" returntype="any" access="public" output="false">
	
	<!--- Include view functions --->
	<cfinclude template="#application.pathTo.functions#/view_functions.cfm">
	
	<!--- Include helpers if they exist --->
	<cfif fileExists(expandPath("#application.pathTo.helpers#/application_helper.cfm"))>
		<cfinclude template="#application.pathTo.helpers#/application_helper.cfm">
	</cfif>
	<cfif fileExists(expandPath("#application.pathTo.helpers#/#request.params.controller#_helper.cfm"))>
		<cfinclude template="#application.pathTo.helpers#/#request.params.controller#_helper.cfm">
	</cfif>
	
	<cfreturn this>

</cffunction>


<cffunction name="renderToString" returntype="any" access="public" output="false">
	
	<cfset var local = structNew()>
	
	<cfset local.render_arguments = duplicate(arguments)>
	<cfset local.render_arguments.save_to_string = true>
	<cfreturn render(argumentCollection=local.render_arguments)>

</cffunction>


<cffunction name="render" returntype="any" access="public" output="true">
	<cfargument name="action" type="any" required="no" default="">
	<cfargument name="controller" type="any" required="no" default="#request.params.controller#">
	<cfargument name="file" type="any" required="no" default="">
	<cfargument name="template" type="any" required="no" default="">
	<cfargument name="partial" type="any" required="no" default="">
	<cfargument name="text" type="any" required="no" default="">
	<cfargument name="nothing" type="any" required="no" default="">
	<cfargument name="layout" type="any" required="no" default="">
	<cfargument name="status" type="any" required="no" default=200>
	<cfargument name="use_full_path" type="any" required="no" default="false">
	<cfargument name="save_to_string" type="any" required="no" default="false">

	<cfset var local = structNew()>
	
	<cfif isBoolean(arguments.nothing) AND arguments.nothing>
		<!--- Never render a layout with the nothing option --->
		<cfset arguments.layout = false>				
	<cfelseif arguments.layout IS "">
		<!--- layout was not passed in so set the default for it depending on the type of rendering to be done --->
		<cfif arguments.action IS NOT "" OR arguments.template IS NOT "">
			<cfset arguments.layout = true>
		<cfelse>
			<cfset arguments.layout = false>		
		</cfif>
	</cfif>
	
	<cfif arguments.status IS NOT 200>
		<cfheader statuscode="#arguments.status#">
	</cfif>

	<cfif arguments.partial IS NOT "">
		<!--- Set local variables for partial --->
		<cfloop collection="#arguments#" item="local.i">
			<cfif NOT listFindNoCase("action,controller,file,template,partial,text,nothing,layout,status,use_full_path,save_to_string", local.i)>
				<cfset "request._render.local_variables.#local.i#" = arguments[local.i]>
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
	<cfif arguments.use_full_path IS NOT "">
		<cfset request._render.use_full_path = arguments.use_full_path>
	</cfif>

	<cfsavecontent variable="local.render_result">
		<cfif (isBoolean(arguments.layout) AND arguments.layout) OR (NOT isBoolean(arguments.layout) AND arguments.layout IS NOT "")>
			<cfset renderLayout(argumentCollection=arguments)>
		<cfelse>
			<cfset contentForLayout()>
		</cfif>
	</cfsavecontent>
	
	<cfif arguments.save_to_string>
		<cfreturn local.render_result>
	<cfelse>
		#local.render_result#
	</cfif>
</cffunction>


<cffunction name="renderLayout" returntype="any" access="public" output="true">
	
	<cfif NOT arguments.layout AND fileExists(expandPath("#application.pathTo.layouts#/#Replace(arguments.layout, " ", "_", "all")#_layout.cfm"))>
		<!--- Another designated layout --->
		<cfinclude template="#application.pathTo.layouts#/#Replace(arguments.layout, " ", "_", "all")#_layout.cfm" />
	<cfelseif fileExists(expandPath("#application.pathTo.layouts#/#arguments.controller#_layout.cfm"))>
		<!--- The current controller's layout --->
		<cfinclude template="#application.pathTo.layouts#/#arguments.controller#_layout.cfm" />
	<cfelseif fileExists(expandPath("#application.pathTo.layouts#/application_layout.cfm"))>
		<!--- Application layout --->
		<cfinclude template="#application.pathTo.layouts#/application_layout.cfm" />
	<cfelse>
		<!--- No layout available, just display the view --->
		<cfset contentForLayout()>
	</cfif>

</cffunction>


<cffunction name="contentForLayout" returntype="any" access="public" output="true">
	
	<cfset var local = structNew()>
	<cfif structKeyExists(request._render, "partial") AND request._render.partial IS NOT "">
		<cfif structKeyExists(request._render, "local_variables")>
			<cfloop collection="#request._render.local_variables#" item="local.local_variable">
				<cfset "#local.local_variable#" = evaluate("request._render.local_variables.#local.local_variable#")>
			</cfloop>
		</cfif>
		<cfif request._render.partial Contains "/">
			<!--- this is a shared partial --->
			<cfset local.template_array_for_partial = listToArray(request._render.partial, "/")>
			<cfset local.directory_for_partial = local.template_array_for_partial[1]>
			<cfset local.filename_for_partial = local.template_array_for_partial[2]>
		<cfelse>
			<!--- this is a normal partial --->
			<cfset local.directory_for_partial = request._render.controller>
			<cfset local.filename_for_partial = request._render.partial>
		</cfif>
		<cfset local.filepath_for_partial = "#application.pathTo.views#/#local.directory_for_partial#/_#replace(local.filename_for_partial, " ", "_", "all")#.cfm">
		<cfif fileExists(expandPath(local.filepath_for_partial))>
			<cfinclude template="#local.filepath_for_partial#">
		</cfif>
		<cfset request._render.partial = "">
	<cfelseif structKeyExists(request._render, "action") AND request._render.action IS NOT "">
		<cfif fileExists(expandPath("#application.pathTo.views#/#request._render.controller#/#request._render.action#.cfm"))>
			<cfinclude template="#application.pathTo.views#/#request._render.controller#/#request._render.action#.cfm">
		</cfif>				
		<cfset request._render.action = "">
	<cfelseif structKeyExists(request._render, "file") AND request._render.file IS NOT "">
		<cfif request._render.use_full_path>
			<cfif fileExists(expandPath("#application.pathTo.views#/#request._render.file#"))>
				<cfinclude template="#application.pathTo.views#/#request._render.file#">
			</cfif>
		<cfelse>
			<cfif fileExists(request._render.file)>
				<cffile action="read" file="#request._render.file#" variable="local.filecontent">
				#local.filecontent#
			</cfif>			
		</cfif>
		<cfset request._render.file = "">
		<cfset request._render.use_full_path = "">
	<cfelseif structKeyExists(request._render, "template") AND request._render.template IS NOT "">
		<cfif fileExists(expandPath("#application.pathTo.views#/#request._render.template#.cfm"))>
			<cfinclude template="#application.pathTo.views#/#request._render.template#.cfm">
		</cfif>
		<cfset request._render.template = "">
	<cfelseif structKeyExists(request._render, "text") AND request._render.text IS NOT "">
		#request._render.text#
		<cfset request._render.text = "">
	<cfelseif structKeyExists(request._render, "nothing") AND request._render.nothing IS NOT "">
		<cfinclude template="#application.pathTo.cfwheels#/on_request_end.cfm">
		<cfabort>
	</cfif>
	
</cffunction>


<cffunction name="redirectTo" returntype="any" access="public" output="true">
	<cfargument name="link" type="any" required="no" default="">
	<cfargument name="back" type="any" required="no" default="false">
	<cfargument name="token" type="any" required="no" default="false">

	<cfset var local = structNew()>

	<cfif arguments.link IS NOT "">
		<cfset local.url = arguments.link>
	<cfelseif arguments.back>
		<cfif CGI.http_referer IS NOT "">
			<cfset local.url = CGI.http_referer>
		<cfelse>
			<cfset local.url = "/">
		</cfif>
	<cfelse>
		<cfset local.url_for_arguments = duplicate(arguments)>
		<cfset structDelete(local.url_for_arguments, "link")>
		<cfset structDelete(local.url_for_arguments, "back")>
		<cfset structDelete(local.url_for_arguments, "token")>
		<cfset local.url = urlFor(argumentCollection=local.url_for_arguments)>
	</cfif>

	<cfinclude template="#application.pathTo.cfwheels#/on_request_end.cfm">

	<cfif arguments.token>
		<cflocation url="#local.url#">
	<cfelse>
		<cflocation url="#local.url#" addtoken="false">
	</cfif>
		
</cffunction>


<cffunction name="beforeFilter" returntype="any" access="public" output="false">
	<cfargument name="filters" type="any" required="yes">
	<cfargument name="only" type="any" required="no" default="">
	<cfargument name="except" type="any" required="no" default="">
	
	<cfset var local = structNew()>

	<cfloop list="#arguments.filters#" index="local.i">
		<cfset local.this_filter = structNew()>
		<cfset local.this_filter.filter = trim(local.i)>
		<cfset local.this_filter.only = replace(arguments.only, ", ", ",", "all")>
		<cfset local.this_filter.except = replace(arguments.except, ", ", ",", "all")>
		<cfset arrayAppend(variables.before_filters, duplicate(local.this_filter))>
	</cfloop>
	
</cffunction>


<cffunction name="afterFilter" returntype="any" access="public" output="false">
	<cfargument name="filters" type="any" required="yes">
	<cfargument name="only" type="any" required="no" default="">
	<cfargument name="except" type="any" required="no" default="">
	
	<cfset var local = structNew()>

	<cfloop list="#arguments.filters#" index="local.i">
		<cfset local.this_filter = structNew()>
		<cfset local.this_filter.filter = trim(local.i)>
		<cfset local.this_filter.only = replace(arguments.only, ", ", ",", "all")>
		<cfset local.this_filter.except = replace(arguments.except, ", ", ",", "all")>
		<cfset arrayAppend(variables.after_filters, duplicate(local.this_filter))>
	</cfloop>
	
</cffunction>


<cffunction name="getBeforeFilters" returntype="any" access="public" output="false">

	<cfreturn variables.before_filters>

</cffunction>


<cffunction name="getAfterFilters" returntype="any" access="public" output="false">

	<cfreturn variables.after_filters>

</cffunction>
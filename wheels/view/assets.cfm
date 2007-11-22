<cffunction name="stylesheetLinkTag" returntype="any" access="public" output="false">
	<cfargument name="sources" type="any" required="false" default="application">
	<cfargument name="media" type="any" required="no" default="all">
	<cfset var local = structNew()>
	<cfset arguments.CFW_named_arguments = "sources,media">
	<cfset local.attributes = CFW_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.html">
		<cfoutput>
			<cfloop list="#arguments.sources#" index="local.i">
				<link rel="stylesheet" type="text/css" media="#arguments.media#" href="#application.wheels.web_path##application.settings.paths.stylesheets#/#trim(local.i)#<cfif local.i Does Not Contain ".">.css</cfif>"#local.attributes# />
			</cfloop>
		</cfoutput>
	</cfsavecontent>

	<cfreturn CFW_trimHTML(local.html)>
</cffunction>


<cffunction name="javascriptIncludeTag" returntype="any" access="public" output="false">
	<cfargument name="sources" type="any" required="false" default="application,protoculous">
	<cfset var local = structNew()>
	<cfset arguments.CFW_named_arguments = "sources">
	<cfset local.attributes = CFW_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.html">
		<cfoutput>
			<cfloop list="#arguments.sources#" index="local.i">
				<script type="text/javascript" src="#application.wheels.web_path##application.settings.paths.javascripts#/#trim(local.i)#<cfif local.i Does Not Contain ".">.js</cfif>"#local.attributes#></script>
			</cfloop>
		</cfoutput>
	</cfsavecontent>

	<cfreturn CFW_trimHTML(local.html)>
</cffunction>


<cffunction name="imageTag" returntype="any" access="public" output="false">
	<cfargument name="source" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfif application.settings.environment IS NOT "production">
		<cfinclude template="../errors/image_tag.cfm">
	</cfif>

	<cfset local.category = "image">
	<cfset local.key = CFW_hashStruct(arguments)>
	<cfset local.lock_name = local.category & local.key>
	<!--- double-checked lock --->
	<cflock name="#local.lock_name#" type="readonly" timeout="30">
		<cfset local.html = getFromCache(local.key, local.category, "internal")>
	</cflock>
	<cfif isBoolean(local.html) AND NOT local.html>
   	<cflock name="#local.lock_name#" type="exclusive" timeout="30">
			<cfset local.html = getFromCache(local.key, local.category, "internal")>
			<cfif isBoolean(local.html) AND NOT local.html>

				<cfset local.args = duplicate(arguments)>
				<cfif left(arguments.source, 7) IS "http://">
					<cfset local.source = arguments.source>
				<cfelse>
					<cfset local.source = "#application.wheels.web_path##application.settings.paths.images#/#arguments.source#">
					<cfif NOT structKeyExists(arguments, "width") OR NOT structKeyExists(arguments, "height")>
						<cfimage action="info" source="#expandPath(local.source)#" structname="local.image">
						<cfif local.image.width GT 0 AND local.image.height GT 0>
							<cfset local.args.width = local.image.width>
							<cfset local.args.height = local.image.height>
						</cfif>
					</cfif>
				</cfif>
				<cfif NOT structKeyExists(arguments, "alt")>
					<cfset local.args.alt = titleize(replaceList(spanExcluding(reverse(spanExcluding(reverse(local.source), "/")), "."), "-,_", " , "))>
				</cfif>
				<cfset local.args.CFW_named_arguments = "source">
				<cfset local.attributes = CFW_getAttributes(argumentCollection=local.args)>
				<cfset local.html = "<img src=""#local.source#""#local.attributes# />">
				<cfif application.settings.cache_images>
					<cfset addToCache(local.key, local.html, 86400, local.category, "internal")>
				</cfif>

			</cfif>
		</cflock>
	</cfif>

	<cfreturn local.html>
</cffunction>
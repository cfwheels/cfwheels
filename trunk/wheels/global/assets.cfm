<cffunction name="stylesheetLinkTag" returntype="any" access="public" output="false">
	<cfargument name="sources" type="any" required="false" default="application">
	<cfargument name="media" type="any" required="no" default="all">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "sources,media">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.html">
		<cfoutput>
			<cfloop list="#arguments.sources#" index="local.i">
				<link rel="stylesheet" type="text/css" media="#arguments.media#" href="#application.wheels.web_path#stylesheets/#trim(local.i)#<cfif local.i Does Not Contain ".">.css</cfif>"#local.attributes# />
			</cfloop>
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.html)>
</cffunction>


<cffunction name="javascriptIncludeTag" returntype="any" access="public" output="false">
	<cfargument name="sources" type="any" required="false" default="application,protoculous">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "sources">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.html">
		<cfoutput>
			<cfloop list="#arguments.sources#" index="local.i">
				<script type="text/javascript" src="#application.wheels.web_path#javascripts/#trim(local.i)#<cfif local.i Does Not Contain ".">.js</cfif>"#local.attributes#></script>
			</cfloop>
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.html)>
</cffunction>


<cffunction name="imageTag" returntype="any" access="public" output="false">
	<cfargument name="source" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.category = "image">
	<cfset local.key = hashStruct(arguments)>
	<cfset local.lock_name = local.category & local.key>
	<!--- double-checked lock --->
	<cflock name="#local.lock_name#" type="readonly" timeout="#application.settings.query_timeout#">
		<cfset local.html = getFromCache(local.key, local.category, "internal")>
	</cflock>
	<cfif isBoolean(local.html) AND NOT local.html>
   	<cflock name="#local.lock_name#" type="exclusive" timeout="#application.settings.query_timeout#">
			<cfset local.html = getFromCache(local.key, local.category, "internal")>
			<cfif isBoolean(local.html) AND NOT local.html>

				<cfset local.args = duplicate(arguments)>
				<cfif left(arguments.source, 7) IS "http://">
					<cfset local.source = arguments.source>
				<cfelse>
					<cfset local.source = "#application.wheels.web_path#images/#arguments.source#">
					<cfif NOT structKeyExists(arguments, "width") OR NOT structKeyExists(arguments, "height")>
						<cfset local.img = application.wheels.java_awt_toolkit.getDefaultToolkit().getImage(expandPath(local.source))>
						<cfset local.width = local.img.getWidth()>
						<cfset local.height = local.img.getHeight()>
						<cfif local.width GT 0 AND local.height GT 0>
							<cfset local.args.width = local.width>
							<cfset local.args.height = local.height>
						</cfif>
					</cfif>
				</cfif>
				<cfif NOT structKeyExists(arguments, "alt")>
					<cfset local.args.alt = titleize(replaceList(spanExcluding(reverse(spanExcluding(reverse(local.source), "/")), "."), "-,_", " , "))>
				</cfif>
				<cfset local.args.FL_named_arguments = "source">
				<cfset local.attributes = FL_getAttributes(argumentCollection=local.args)>
				<cfset local.html = "<img src=""#local.source#""#local.attributes# />">
				<cfset addToCache(local.key, local.html, 86400, local.category, "internal")>

			</cfif>
		</cflock>
	</cfif>

	<cfreturn local.html>
</cffunction>
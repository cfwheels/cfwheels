<cffunction name="stylesheetLinkTag" returntype="any" access="public" output="false">
	<cfargument name="sources" type="any" required="false" default="application">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfset var locals = structNew()>

	<cfset locals.result = "">
	<cfloop list="#arguments.sources#" index="locals.i">
		<cfset locals.href = "#application.wheels.webPath##application.settings.paths.stylesheets#/#trim(locals.i)#">
		<cfif locals.i Does Not Contain ".">
			<cfset locals.href = locals.href & ".css">
		</cfif>
		<cfset locals.result = locals.result & '<link rel="stylesheet" type="text/css" media="all" href="#locals.href#"#_HTMLAttributes(attributes)# />'>
	</cfloop>

	<cfreturn locals.result>
</cffunction>


<cffunction name="javascriptIncludeTag" returntype="any" access="public" output="false">
	<cfargument name="sources" type="any" required="false" default="application,protoculous">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfset var locals = structNew()>

	<cfset locals.result = "">
	<cfloop list="#arguments.sources#" index="locals.i">
		<cfset locals.src = "#application.wheels.webPath##application.settings.paths.javascripts#/#trim(locals.i)#">
		<cfif locals.i Does Not Contain ".">
			<cfset locals.src = locals.src & ".js">
		</cfif>
		<cfset locals.result = locals.result & '<script type="text/javascript" src="#locals.src#"#_HTMLAttributes(attributes)#></script>'>
	</cfloop>

	<cfreturn locals.result>
</cffunction>


<cffunction name="imageTag" returntype="any" access="public" output="false">
	<cfargument name="source" type="any" required="false" default="">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfset var locals = structNew()>
	<cfif application.settings.environment IS NOT "production">
		<cfinclude template="../errors/imagetag.cfm">
	</cfif>

	<cfset locals.category = "image">
	<cfset locals.key = _hashStruct(arguments)>
	<cfset locals.lockName = locals.category & locals.key>
	<!--- double-checked lock --->
	<cflock name="#locals.lockName#" type="readonly" timeout="30">
		<cfset locals.result = _getFromCache(locals.key, locals.category, "internal")>
	</cflock>
	<cfif isBoolean(locals.result) AND NOT locals.result>
   	<cflock name="#locals.lockName#" type="exclusive" timeout="30">
			<cfset locals.result = _getFromCache(locals.key, locals.category, "internal")>
			<cfif isBoolean(locals.result) AND NOT locals.result>

				<cfset locals.attributes = _HTMLAttributes(arguments.attributes)>
				<cfif left(arguments.source, 7) IS "http://">
					<cfset locals.src = arguments.source>
				<cfelse>
					<cfset locals.src = "#application.wheels.webPath##application.settings.paths.images#/#arguments.source#">
					<cfif arguments.attributes Does Not Contain "width" OR arguments.attributes Does Not Contain "height">
						<cfimage action="info" source="#expandPath(locals.src)#" structname="locals.image">
						<cfif locals.image.width GT 0 AND locals.image.height GT 0>
							<cfset locals.attributes = locals.attributes & " width=""#locals.image.width#"" height=""#locals.image.height#""">
						</cfif>
					</cfif>
				</cfif>
				<cfif arguments.attributes Does Not Contain "alt">
					<cfset locals.attributes = locals.attributes & " alt=""#titleize(replaceList(spanExcluding(reverse(spanExcluding(reverse(locals.src), "/")), "."), "-,_", " , "))#""">
				</cfif>
				<cfset locals.result = "<img src=""#locals.src#""#locals.attributes# />">
				<cfif application.settings.cacheImages>
					<cfset _addToCache(locals.key, locals.result, 86400, locals.category, "internal")>
				</cfif>

			</cfif>
		</cflock>
	</cfif>

	<cfreturn locals.result>
</cffunction>
<cffunction name="stylesheetLinkTag" returntype="any" access="public" output="false">
	<cfargument name="sources" type="any" required="false" default="application">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "sources">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset loc.result = "">
	<cfloop list="#arguments.sources#" index="loc.i">
		<cfset loc.href = "#application.wheels.webPath##application.settings.paths.stylesheets#/#trim(loc.i)#">
		<cfif loc.i Does Not Contain ".">
			<cfset loc.href = loc.href & ".css">
		</cfif>
		<cfset loc.result = loc.result & '<link rel="stylesheet" type="text/css" media="all" href="#loc.href#"#loc.attributes# />'>
	</cfloop>

	<cfreturn loc.result>
</cffunction>

<cffunction name="javascriptIncludeTag" returntype="any" access="public" output="false">
	<cfargument name="sources" type="any" required="false" default="application,protoculous">
	<cfset var loc = {}>
	<cfset arguments.$namedArguments = "sources">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset loc.result = "">
	<cfloop list="#arguments.sources#" index="loc.i">
		<cfset loc.src = "#application.wheels.webPath##application.settings.paths.javascripts#/#trim(loc.i)#">
		<cfif loc.i Does Not Contain ".">
			<cfset loc.src = loc.src & ".js">
		</cfif>
		<cfset loc.result = loc.result & '<script type="text/javascript" src="#loc.src#"#loc.attributes#></script>'>
	</cfloop>

	<cfreturn loc.result>
</cffunction>

<cffunction name="imageTag" returntype="any" access="public" output="false">
	<cfargument name="source" type="any" required="false" default="">
	<cfset var loc = {}>
	<cfif application.settings.environment IS NOT "production">
		<cfinclude template="../errors/imagetag.cfm">
	</cfif>

	<cfset loc.category = "image">
	<cfset loc.key = $hashStruct(arguments)>
	<cfset loc.lockName = loc.category & loc.key>
	<!--- double-checked lock --->
	<cflock name="#loc.lockName#" type="readonly" timeout="30">
		<cfset loc.result = $getFromCache(loc.key, loc.category, "internal")>
	</cflock>
	<cfif IsBoolean(loc.result) AND NOT loc.result>
   	<cflock name="#loc.lockName#" type="exclusive" timeout="30">
			<cfset loc.result = $getFromCache(loc.key, loc.category, "internal")>
			<cfif IsBoolean(loc.result) AND NOT loc.result>
				<cfset arguments.$namedArguments = "source">
				<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>
				<cfif Left(arguments.source, 7) IS "http://">
					<cfset loc.src = arguments.source>
				<cfelse>
					<cfset loc.src = "#application.wheels.webPath##application.settings.paths.images#/#arguments.source#">
					<cfif arguments.attributes Does Not Contain "width" OR arguments.attributes Does Not Contain "height">
						<cfimage action="info" source="#expandPath(loc.src)#" structname="loc.image">
						<cfif loc.image.width GT 0 AND loc.image.height GT 0>
							<cfset loc.attributes = loc.attributes & " width=""#loc.image.width#"" height=""#loc.image.height#""">
						</cfif>
					</cfif>
				</cfif>
				<cfif arguments.attributes Does Not Contain "alt">
					<cfset loc.attributes = loc.attributes & " alt=""#titleize(replaceList(spanExcluding(Reverse(spanExcluding(Reverse(loc.src), "/")), "."), "-,_", " , "))#""">
				</cfif>
				<cfset loc.result = "<img src=""#loc.src#""#loc.attributes# />">
				<cfif application.settings.cacheImages>
					<cfset $addToCache(loc.key, loc.result, 86400, loc.category, "internal")>
				</cfif>

			</cfif>
		</cflock>
	</cfif>

	<cfreturn loc.result>
</cffunction>
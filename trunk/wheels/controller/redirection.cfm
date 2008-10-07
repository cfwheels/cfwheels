<cffunction name="redirectTo" returntype="void" access="public" output="false" hint="Controller, Request, Redirects the browser to the supplied action, URL or to the referring URL.">
	<cfargument name="url" type="string" required="false" default="" hint="Address to redirect to">
	<cfargument name="back" type="boolean" required="false" default="false" hint="Whether or not to redirect back to the referring address">
	<cfargument name="addToken" type="boolean" required="false" default="false" hint="Pass-through argument; see documentation for cflocation">
	<cfargument name="statusCode" type="numeric" required="false" default="302" hint="Pass-through argument; see documentation for cflocation">
	<cfargument name="route" type="string" required="false" default="" hint="Pass-through argument; see documentation for URLFor">
	<cfargument name="controller" type="string" required="false" default="" hint="Pass-through argument; see documentation for URLFor">
	<cfargument name="action" type="string" required="false" default="" hint="Pass-through argument; see documentation for URLFor">
	<cfargument name="key" type="any" required="false" default="" hint="Pass-through argument; see documentation for URLFor">
	<cfargument name="params" type="string" required="false" default="" hint="Pass-through argument; see documentation for URLFor">
	<cfargument name="anchor" type="string" required="false" default="" hint="Pass-through argument; see documentation for URLFor">
	<cfargument name="onlyPath" type="boolean" required="false" default="true" hint="Pass-through argument; see documentation for URLFor">
	<cfargument name="host" type="string" required="false" default="" hint="Pass-through argument; see documentation for URLFor">
	<cfargument name="protocol" type="string" required="false" default="" hint="Pass-through argument; see documentation for URLFor">
	<cfset var loc = {}>

	<!---
		HISTORY:
		-

		USAGE:
		This function uses the cflocation tag to redirect the browser.
		You can redirect to a controller/action/key in your application, a specific URL or back to the referring URL.
		Internally it uses URLFor (when a controller/action/key is supplied) to build the URL to redirect to so it can also accept all arguments of URLFor.

		EXAMPLES:
		<cfif user.save()>
		  <cfset redirectTo(action="saveSuccessful")>
		</cfif>

		<cfset redirectTo(url="http://www.cfwheels.com")>

		<cfset redirectTo(back=true)>

		RELATED:
		 * RedirectingUsers (chapter)
	--->

	<cfif arguments.back>
		<cfif Len(cgi.http_referer) IS 0 OR cgi.http_referer Does Not Contain cgi.server_name>
			<cfset loc.url = "/">
		<cfelse>
			<cfset loc.url = cgi.http_referer>
		</cfif>
	<cfelse>
		<cfif arguments.url IS NOT "">
			<cfset loc.url = arguments.url>
		<cfelse>
			<cfset loc.url = URLFor(argumentCollection=arguments)>
		</cfif>
	</cfif>

	<cflocation url="#loc.url#" addToken="#arguments.addToken#" statusCode="#arguments.statusCode#">
</cffunction>

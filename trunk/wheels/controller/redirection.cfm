<cffunction name="redirectTo" returntype="void" access="public" output="false">
	<cfargument name="url" type="string" required="false" default="">
	<cfargument name="back" type="boolean" required="false" default="false">
	<cfargument name="addToken" type="boolean" required="false" default="false">
	<cfargument name="statusCode" type="numeric" required="false" default=302>
	<!--- Accepts URLFor arguments --->
	<cfset var locals = structNew()>

	<cfif arguments.back>
		<cfif len(cgi.http_referer) IS 0 OR cgi.http_referer Does Not Contain cgi.server_name>
			<cfset locals.url = "/">
		<cfelse>
			<cfset locals.url = cgi.http_referer>
		</cfif>
	<cfelse>
		<cfif arguments.url IS NOT "">
			<cfset locals.url = arguments.url>
		<cfelse>
			<cfset locals.url = URLFor(argumentCollection=arguments)>
		</cfif>
	</cfif>

	<cflocation url="#locals.url#" addToken="#arguments.addToken#" statusCode="#arguments.statusCode#">
</cffunction>

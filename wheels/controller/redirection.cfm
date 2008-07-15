<cffunction name="redirectTo" returntype="void" access="public" output="false">
	<cfargument name="url" type="string" required="false" default="">
	<cfargument name="back" type="boolean" required="false" default="false">
	<cfargument name="addToken" type="boolean" required="false" default="false">
	<cfargument name="statusCode" type="numeric" required="false" default=302>
	<!--- Accepts URLFor arguments --->
	<cfset var loc = {}>

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

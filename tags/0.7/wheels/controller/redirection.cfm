<cffunction name="redirectTo" returntype="any" access="public" output="false">
	<cfargument name="url" type="any" required="false" default="">
	<cfargument name="back" type="any" required="false" default="false">
	<cfargument name="addToken" type="any" required="false" default="false">
	<cfargument name="statusCode" type="any" required="false" default="302">
	<!--- Accepts URLFor arguments --->
	<cfset var locals = structNew()>

	<cfif arguments.back>
		<cfif len(CGI.HTTP_REFERER) IS 0 OR CGI.HTTP_REFERER Does Not Contain CGI.SERVER_NAME>
			<cfset locals.url = "/">
		<cfelse>
			<cfset locals.url = CGI.HTTP_REFERER>
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

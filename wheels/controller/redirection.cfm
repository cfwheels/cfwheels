<cffunction name="redirectTo" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="false" default="">
	<cfargument name="back" type="any" required="false" default="false">
	<cfargument name="params" type="any" required="false" default="">
	<!--- Accepts URLFor arguments --->
	<cfset var local = structNew()>

	<cfif arguments.back>
		<cfif len(CGI.http_referer) IS 0 OR CGI.http_referer Does Not Contain CGI.server_name>
			<cfset local.url = urlFor(controller=application.settings.default_controller, action=application.settings.default_action)>
		<cfelse>
			<cfset local.url = CGI.http_referer>
		</cfif>
		<cfif arguments.params IS NOT "">
			<cfset local.params = CFW_constructParams(arguments.params)>
			<cfset local.params = right(local.params, len(local.params)-1)>
			<cfif local.url Contains "?">
				<cfset local.url = local.url & "&" & local.params>
			<cfelse>
				<cfset local.url = local.url & "?" & local.params>
			</cfif>
		</cfif>
	<cfelse>
		<cfif arguments.link IS NOT "">
			<cfset local.url = arguments.link>
		<cfelse>
			<cfset local.url = URLFor(argumentCollection=arguments)>
		</cfif>
	</cfif>

	<cflocation url="#local.url#" addtoken="false">
</cffunction>

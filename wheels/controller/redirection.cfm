<cffunction name="redirectTo" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="false" default="">
	<cfargument name="back" type="any" required="false" default="false">
	<!--- Accepts URLFor arguments --->
	<cfset var local = structNew()>

	<cfif arguments.back>
		<cfif len(CGI.http_referer) IS 0 OR CGI.http_referer Does Not Contain CGI.server_name>
			<cfset local.url = urlFor(controller=application.settings.default_controller, action=application.settings.default_action)>
		<cfelse>
			<cfset local.url = CGI.http_referer>
		</cfif>
		<cfif structKeyExists(arguments, "params")>
			<cfset local.url = local.url & FL_constructParams(arguments.params)>
		</cfif>
	<cfelse>
		<cfif arguments.link IS NOT "">
			<cfset local.url = arguments.link>
		<cfelse>
			<cfset local.url = URLFor(argumentCollection=arguments)>
		</cfif>
	</cfif>

	<cfinclude template="../events/onrequestend.cfm">
	<cflocation url="#local.url#" addtoken="false">
</cffunction>

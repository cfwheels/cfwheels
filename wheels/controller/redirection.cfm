<cffunction name="redirectTo" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="false" default="">
	<cfargument name="back" type="any" required="false" default="false">
	<!--- Accepts URLFor arguments --->
	<cfset var local = structNew()>

	<cfif arguments.back>
		<cfif len(CGI.http_referer) IS 0>
			<cfthrow type="wheels" message="Wheels: Redirect To Back Error" detail="Cannot perform redirection because referer is blank.">
		<cfelse>
			<cfif structKeyExists(arguments, "params")>
				<cfset local.url = CGI.http_referer & FL_constructParams(arguments.params)>
			<cfelse>
				<cfset local.url = CGI.http_referer>
			</cfif>
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

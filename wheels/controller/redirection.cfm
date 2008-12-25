<cffunction name="redirectTo" returntype="void" access="public" output="false" hint="Controller, Request, Redirects the browser to the supplied controller/action/key, route or back to the referring page. Internally It uses the URLFor function to build the link and the cflocation tag to perform the redirect.">
	<cfargument name="back" type="boolean" required="false" default="false" hint="Set to true to redirect back to the referring page">
	<cfargument name="addToken" type="boolean" required="false" default="false" hint="See documentation for cflocation (CFML)">
	<cfargument name="statusCode" type="numeric" required="false" default="302" hint="See documentation for cflocation (CFML)">
	<cfargument name="route" type="string" required="false" default="" hint="See documentation for URLFor (Wheels)">
	<cfargument name="controller" type="string" required="false" default="" hint="See documentation for URLFor (Wheels)">
	<cfargument name="action" type="string" required="false" default="" hint="See documentation for URLFor (Wheels)">
	<cfargument name="key" type="any" required="false" default="" hint="See documentation for URLFor (Wheels)">
	<cfargument name="params" type="string" required="false" default="" hint="See documentation for URLFor (Wheels)">
	<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for URLFor (Wheels)">
	<cfargument name="onlyPath" type="boolean" required="false" default="true" hint="See documentation for URLFor (Wheels)">
	<cfargument name="host" type="string" required="false" default="" hint="See documentation for URLFor (Wheels)">
	<cfargument name="protocol" type="string" required="false" default="" hint="See documentation for URLFor (Wheels)">
	<cfargument name="port" type="numeric" required="false" default="0" hint="See documentation for URLFor (Wheels)">
	<!---
		EXAMPLES:
		<cfif user.save()>
		  <cfset redirectTo(action="saveSuccessful")>
		</cfif>

		<cfset redirectTo(controller="checkout", action="start", params="type=express", protocol="https")>

		<cfset redirectTo(route="profile", screenName="Joe")>

		<cfset redirectTo(back=true)>

		RELATED:
		 * RedirectingUsers (chapter)
		 * UsingRoutes (chapter)
	--->
	<cfscript>
		var loc = {};
		if (arguments.back)
		{
			if (!Len(cgi.http_referer))
				$throw(type="Wheels.RedirectBackError", message="Can't redirect back to the referring URL because it is blank.", extendedInfo="Catch this error in your code to handle it gracefully.");
			else if (cgi.http_referer Does Not Contain cgi.server_name)
				$throw(type="Wheels.RedirectBackError", message="Can't redirect back to the referring URL because it is not on the same domain.", extendedInfo="Catch this error in your code to handle it gracefully.");
			else
				loc.url = cgi.http_referer;
		}
		else
		{
			loc.url = URLFor(argumentCollection=arguments);
		}
		$location(url=loc.url, addToken=arguments.addToken, statusCode=arguments.statusCode);
	</cfscript>
</cffunction>

<cfoutput>
<h1>Summary</h1>
<p><strong>Error:</strong><br />#arguments.exception.cause.message#</p>
<p><strong>URL:</strong><br />http://#cgi.server_name##cgi.script_name##cgi.path_info#<cfif cgi.query_string IS NOT "">?#cgi.query_string#</cfif></p>
<p><strong>Method:</strong><br />#cgi.request_method#</p>
<p><strong>Referrer:</strong><br />#cgi.http_referer#</p>
<p><strong>IP Address:</strong><br />#cgi.remote_addr#</p>
<p><strong>Date & Time:</strong><br />#DateFormat(now(), "MMMM D, YYYY")# at #TimeFormat(now(), "h:MM TT")#</p>
<h1>Error</h1>
<cfloop collection="#arguments.exception.cause#" item="loc.i">
	<cfif IsSimpleValue(arguments.exception.cause[loc.i]) AND loc.i IS NOT "StackTrace" AND Len(arguments.exception.cause[loc.i]) IS NOT 0>
		<p><strong>#loc.i#:</strong><br />#arguments.exception.cause[loc.i]#</p>
	</cfif>
</cfloop>
<p><strong>Context:</strong>
<cfloop index="loc.i" from="1" to="#ArrayLen(arguments.exception.cause.tagContext)#">
	<br />Line #arguments.exception.cause.tagContext[loc.i]["line"]# in #arguments.exception.cause.tagContext[loc.i]["template"]#
</cfloop>
</p>
<cfset loc.scopes = "Application,Session,CGI,Request,Form,URL,Cookie">
<cfloop list="#loc.scopes#" index="loc.i">
	<cftry>
		<h1>#loc.i#</h1>
		<cfset loc.thisScope = Evaluate(loc.i)>
		<cfloop collection="#loc.thisScope#" item="loc.j">
			<cfif IsSimpleValue(loc.thisScope[loc.j]) AND Len(loc.thisScope[loc.j]) IS NOT 0>
				<p><strong>#loc.j#:</strong><br />#loc.thisScope[loc.j]#</p>
			</cfif>
		</cfloop>
	<cfcatch>
	</cfcatch>
	</cftry>
</cfloop>
</cfoutput>
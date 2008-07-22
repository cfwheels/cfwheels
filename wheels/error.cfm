<cfoutput>
<h1>Summary</h1>
<ul>
	<li><strong>Error:</strong><br />#arguments.exception.cause.message#</li>
	<li><strong>URL:</strong><br />http://#cgi.server_name##cgi.script_name##cgi.path_info#<cfif cgi.query_string IS NOT "">?#cgi.query_string#</cfif></li>
	<li><strong>Method:</strong><br />#cgi.request_method#</li>
	<li><strong>Referrer:</strong><br />#cgi.http_referer#</li>
	<li><strong>IP Address:</strong><br />#cgi.remote_addr#</li>
	<li><strong>Date & Time:</strong><br />#dateFormat(now(), "MMMM D, YYYY")# at #timeFormat(now(), "h:MM TT")#</li>
</ul>
<h1>Error</h1>
<ul>
<cfloop collection="#arguments.exception.cause#" item="loc.i">
	<cfif isSimpleValue(arguments.exception.cause[loc.i]) AND loc.i IS NOT "StackTrace" AND Len(arguments.exception.cause[loc.i]) IS NOT 0>
		<li><strong>#loc.i#:</strong><br />#arguments.exception.cause[loc.i]#</li>
	</cfif>
</cfloop>
	<li><strong>Context:</strong><br />
	<cfloop index="loc.i" from="1" to="#arrayLen(arguments.exception.cause.tagContext)#">
		Line #arguments.exception.cause.tagContext[loc.i]["line"]# in #arguments.exception.cause.tagContext[loc.i]["template"]#<br />
	</cfloop>
	</li>
</ul>
<cfset loc.scopes = "CGI,Request,Form,URL,Cookie">
<cfloop list="#loc.scopes#" index="loc.i">
	<cfset loc.thisScope = evaluate(loc.i)>
	<cfif structCount(loc.thisScope) GT 0>
		<h1>#loc.i#</h1>
		<ul>
		<cfloop collection="#loc.thisScope#" item="loc.j">
			<cfif isSimpleValue(loc.thisScope[loc.j]) AND Len(loc.thisScope[loc.j]) IS NOT 0>
				<li><strong>#loc.j#:</strong><br />#loc.thisScope[loc.j]#</li>
			</cfif>
		</cfloop>
		</ul>
	</cfif>
</cfloop>
<h1>Session</h1>
<ul>
<cfloop collection="#session#" item="loc.k">
	<cfif IsSimpleValue(session[loc.k]) AND Len(session[loc.k]) IS NOT 0>
		<li><strong>#loc.k#:</strong><br />#session[loc.k]#</li>
	</cfif>
</cfloop>
</ul>
<h1>Application</h1>
<ul>
<cfloop collection="#application#" item="loc.l">
	<cfif isSimpleValue(application[loc.l]) AND Len(application[loc.l]) IS NOT 0>
		<li><strong>#loc.l#:</strong><br />#application[loc.l]#</li>
	</cfif>
</cfloop>
</ul>
</cfoutput>
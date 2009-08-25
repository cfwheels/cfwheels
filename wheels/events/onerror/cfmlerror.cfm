<cfoutput>
<h1>Summary</h1>
<p><strong>Error:</strong><br />#arguments.exception.cause.message#<cfif arguments.exception.cause.detail IS NOT ""><br />#arguments.exception.cause.detail#</cfif></p>
<p><strong>Location:</strong><br />Line #arguments.exception.cause.tagContext[1]["line"]# in #arguments.exception.cause.tagContext[1]["template"]#</p>
<p><strong>URL:</strong><br />http://#cgi.server_name##cgi.script_name##cgi.path_info#<cfif cgi.query_string IS NOT "">?#cgi.query_string#</cfif></p>
<p><strong>IP Address:</strong><br />#cgi.remote_addr#</p>
<p><strong>Date & Time:</strong><br />#DateFormat(now(), "MMMM D, YYYY")# at #TimeFormat(now(), "h:MM TT")#</p>
<cfset loc.scopes = "CGI,Form,URL,Application,Session,Request,Cookie,Arguments.Exception.Cause">
<cfloop list="#loc.scopes#" index="loc.i">
	<cftry>
		<h2>#ListLast(loc.i, ".")#</h2>
		<cfdump var="#Evaluate(loc.i)#" format="text" showUDFs="false" hide="wheels">
	<cfcatch>
	</cfcatch>
	</cftry>
</cfloop>
</cfoutput>
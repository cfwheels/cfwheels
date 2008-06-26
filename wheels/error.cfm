<cfoutput>
<h1>Summary</h1>
<ul>
	<li><strong>Error:</strong><br />#arguments.exception.cause.message#</li>
	<li><strong>URL:</strong><br />http://#CGI.server_name##CGI.SCRIPT_NAME##CGI.PATH_INFO#<cfif CGI.QUERY_STRING IS NOT "">?#CGI.QUERY_STRING#</cfif></li>
	<li><strong>Method:</strong><br />#CGI.REQUEST_METHOD#</li>
	<li><strong>Referrer:</strong><br />#CGI.HTTP_REFERER#</li>
	<li><strong>IP Address:</strong><br />#CGI.REMOTE_ADDR#</li>
	<li><strong>Date & Time:</strong><br />#dateFormat(now(), "MMMM D, YYYY")# at #timeFormat(now(), "h:MM TT")#</li>
</ul>
<h1>Error</h1>
<ul>
<cfloop collection="#arguments.exception.cause#" item="locals.i">
	<cfif isSimpleValue(arguments.exception.cause[locals.i]) AND locals.i IS NOT "StackTrace" AND len(arguments.exception.cause[locals.i]) IS NOT 0>
		<li><strong>#locals.i#:</strong><br />#arguments.exception.cause[locals.i]#</li>
	</cfif>
</cfloop>
	<li><strong>Context:</strong><br />
	<cfloop index="locals.i" from="1" to="#arrayLen(arguments.exception.cause.tagContext)#">
		Line #arguments.exception.cause.tagContext[locals.i]["line"]# in #arguments.exception.cause.tagContext[locals.i]["template"]#<br />
	</cfloop>
	</li>
</ul>
<cfset locals.scopes = "CGI,Request,Form,URL,Cookie">
<cfloop list="#locals.scopes#" index="locals.i">
	<cfset locals.thisScope = evaluate(locals.i)>
	<cfif structCount(locals.thisScope) GT 0>
		<h1>#locals.i#</h1>
		<ul>
		<cfloop collection="#locals.thisScope#" item="locals.j">
			<cfif isSimpleValue(locals.thisScope[locals.j]) AND len(locals.thisScope[locals.j]) IS NOT 0>
				<li><strong>#locals.j#:</strong><br />#locals.thisScope[locals.j]#</li>
			</cfif>
		</cfloop>
		</ul>
	</cfif>
</cfloop>
<h1>Session</h1>
<ul>
<cflock scope="session" type="readonly" timeout="5">
	<cfloop collection="#session#" item="locals.k">
		<cfif isSimpleValue(session[locals.k]) AND len(session[locals.k]) IS NOT 0>
			<li><strong>#locals.k#:</strong><br />#session[locals.k]#</li>
		</cfif>
	</cfloop>
</cflock>
</ul>
<h1>Application</h1>
<ul>
<cfloop collection="#application#" item="locals.l">
	<cfif isSimpleValue(application[locals.l]) AND len(application[locals.l]) IS NOT 0>
		<li><strong>#locals.l#:</strong><br />#application[locals.l]#</li>
	</cfif>
</cfloop>
</ul>
</cfoutput>
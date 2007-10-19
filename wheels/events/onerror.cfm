<cfif application.settings.send_email_on_error>
	<cfmail to="#application.settings.error_email_address#" from="#application.settings.error_email_address#" subject="#application.applicationname# error" type="html" server="#application.settings.error_mail_server#">
		<h1>Summary</h1>
		<ul>
			<li><strong>Error:</strong><br />#arguments.exception.cause.message#</li>
			<li><strong>URL:</strong><br />http://#CGI.server_name##CGI.script_name##CGI.path_info#<cfif CGI.query_string IS NOT "">?#CGI.query_string#</cfif></li>
			<li><strong>Method:</strong><br />#CGI.request_method#</li>
			<li><strong>Referrer:</strong><br />#CGI.http_referer#</li>
			<li><strong>IP Address:</strong><br />#CGI.remote_addr#</li>
			<li><strong>Date & Time:</strong><br />#dateFormat(now(), "MMMM D, YYYY")# at #timeFormat(now(), "h:MM TT")#</li>
		</ul>
		<h1>Error</h1>
		<ul>
		<cfloop collection="#arguments.exception.cause#" item="local.i">
			<cfif isSimpleValue(arguments.exception.cause[local.i]) AND local.i IS NOT "StackTrace" AND len(arguments.exception.cause[local.i]) IS NOT 0>
				<li><strong>#local.i#:</strong><br />#arguments.exception.cause[local.i]#</li>
			</cfif>
		</cfloop>
			<li><strong>Context:</strong><br />
			<cfloop index="local.i" from="1" to="#arrayLen(arguments.exception.cause.tagContext)#">
				Line #arguments.exception.cause.tagContext[local.i]["line"]# in #arguments.exception.cause.tagContext[local.i]["template"]#<br />
			</cfloop>
			</li>
		</ul>
		<cfset local.scopes = "CGI,Request,Form,URL,Session,Cookie">
		<cfloop list="#local.scopes#" index="local.i">
			<cfset local.this_scope = evaluate(local.i)>
			<cfif structCount(local.this_scope) GT 0>
				<h1>#local.i#</h1>
				<ul>
				<cfloop collection="#local.this_scope#" item="local.j">
					<cfif isSimpleValue(local.this_scope[local.j]) AND len(local.this_scope[local.j]) IS NOT 0>
						<li><strong>#local.j#:</strong><br />#local.this_scope[local.j]#</li>
					</cfif>
				</cfloop>
				</ul>
			</cfif>
		</cfloop>
		<h1>Application</h1>
		<ul>
		<cfloop collection="#Application#" item="local.k">
			<cfif isSimpleValue(Application[local.k]) AND len(Application[local.k]) IS NOT 0>
				<li><strong>#local.k#:</strong><br />#Application[local.k]#</li>
			</cfif>
		</cfloop>
		</ul>
	</cfmail>
</cfif>
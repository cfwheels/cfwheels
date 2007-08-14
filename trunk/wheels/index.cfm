<cftry>
	<cfoutput>#application.wheels.dispatch.request()#</cfoutput>
<cfcatch>
		<cfif application.settings.environment IS NOT "production">
			<!--- Rethrow the error to let ColdFusion handle it if we're in development or testing mode --->
			<cfrethrow>
		<cfelse>
			<cftry>
				<!--- Run the on request end code since it does not get executed for errors --->
				<cfinclude template="events/onrequestend.cfm">
				<cfif application.settings.send_email_on_error>
					<!--- Send an email with error details (wrap with try/catch so we avoid showing an error message on screen when there is an error sending the email itself) --->
					<cfmail to="#application.settings.error_email_address#" from="#application.settings.error_email_address#" subject="#application.applicationname# error" type="html">
						<h1>Summary</h1>
						<ul>
							<li><strong>Error:</strong><br />#cfcatch.message#</li>
							<li><strong>URL:</strong><br />http://#CGI.server_name##CGI.script_name##CGI.path_info#<cfif CGI.query_string IS NOT "">?#CGI.query_string#</cfif></li>
							<li><strong>Method:</strong><br />#CGI.request_method#</li>
							<li><strong>Referrer:</strong><br />#CGI.http_referer#</li>
							<li><strong>IP Address:</strong><br />#CGI.remote_addr#</li>
							<li><strong>Date & Time:</strong><br />#dateFormat(now(), "MMMM D, YYYY")# at #timeFormat(now(), "h:MM TT")#</li>
						</ul>
						<h1>Error</h1>
						<ul>
						<cfloop collection="#cfcatch#" item="local.i">
							<cfif isSimpleValue(cfcatch[local.i]) AND local.i IS NOT "StackTrace" AND len(cfcatch[local.i]) IS NOT 0>
								<li><strong>#local.i#:</strong><br />#cfcatch[local.i]#</li>
							</cfif>
						</cfloop>
							<li><strong>Context:</strong><br />
							<cfloop index="local.i" from="1" to="#arrayLen(cfcatch.tagContext)#">
								Line #cfcatch.tagContext[local.i]["line"]# in #cfcatch.tagContext[local.i]["template"]#<br />
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
			<cfcatch>
			</cfcatch>
			</cftry>
			<!--- Show the error page --->
			<cfinclude template="../events/on_error.cfm">
		</cfif>
</cfcatch>
</cftry>

<cfif isDefined("request.wheels.show_debug_info") AND request.wheels.show_debug_info AND application.settings.environment IS NOT "production">
	<cfset request.wheels.execution.component_total = getTickCount() - request.wheels.execution.component_total>
	<div style="clear:both;margin-top:100px;text-align:left;background:#ececec;padding:10px;border-top:2px solid #808080;border-bottom:2px solid #808080;">
	<cfoutput>
	<table cellspacing="0">
	<tr>
		<td valign="top"><strong>Environment:</strong></td>
		<td>#application.settings.environment#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Total Execution Time:</strong></td>
		<td>#request.wheels.execution.component_total#ms</td>
	</tr>
	<tr>
		<td valign="top"><strong>Execution Time Breakdown:</strong></td>
		<td>
		<cfset keys = structSort(request.wheels.execution.components, "numeric", "desc")>
		<ul style="list-style: none;">
		<cfloop from="1" to="#arrayLen(keys)#" index="i">
			<li>#request.wheels.execution.components[keys[i]]#ms - #lCase(keys[i])#</li>
		</cfloop>
		</ul>
	</td>
	</tr>
	<tr>
		<td valign="top"><strong>Query Execution Time:</strong></td>
		<td>#request.wheels.execution.query_total#ms</td>
	</tr>
	<tr>
		<td valign="top"><strong>Query Execution Time Breakdown:</strong></td>
		<td>
		<cfset keys = structSort(request.wheels.execution.queries, "numeric", "desc")>
		<ul style="list-style: none;">
		<cfloop from="1" to="#arrayLen(keys)#" index="i">
			<li>#request.wheels.execution.queries[keys[i]]#ms - #lCase(keys[i])#</li>
		</cfloop>
		</ul>
	</td>
	</tr>
	<tr>
		<td valign="top"><strong>Partial Execution Time:</strong></td>
		<td>#request.wheels.execution.partial_total#ms</td>
	</tr>
	<tr>
		<td valign="top"><strong>Partial Execution Time Breakdown:</strong></td>
		<td>
		<cfset keys = structSort(request.wheels.execution.partials, "numeric", "desc")>
		<ul style="list-style: none;">
		<cfloop from="1" to="#arrayLen(keys)#" index="i">
			<li>#request.wheels.execution.partials[keys[i]]#ms - #lCase(keys[i])#</li>
		</cfloop>
		</ul>
	</td>
	</tr>
	</table>
	</cfoutput>
	</div>
</cfif>

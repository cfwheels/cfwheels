<cfoutput>
	<h1>Summary</h1>
	<p>
		<strong>Error:</strong><br>
		<cfif StructKeyExists(arguments.exception, "rootcause") and StructKeyExists(arguments.exception.rootcause, "message")>
			#arguments.exception.rootcause.message#
			<cfif arguments.exception.rootcause.detail IS NOT ""><br>#arguments.exception.rootcause.detail#</cfif>
		<cfelse>
			A root cause was not provided.
		</cfif>
	</p>
	<cfif StructKeyExists(arguments.exception, "cause") && StructKeyExists(arguments.exception.cause, "tagContext") && ArrayLen(arguments.exception.cause.tagContext)>
		<cfset loc.tagContext = arguments.exception.cause.tagContext>
	<cfelseif StructKeyExists(arguments.exception, "rootCause") && StructKeyExists(arguments.exception.rootCause, "tagContext") && ArrayLen(arguments.exception.rootCause.tagContext)>
		<cfset loc.tagContext = arguments.exception.rootCause.tagContext>
	</cfif>
	<cfif StructKeyExists(loc, "tagContext")>
		<p><strong>Location:</strong><br>
		<cfset loc.path = GetDirectoryFromPath(GetBaseTemplatePath())>
		<cfset loc.pos = 0>
		<cfloop array="#arguments.exception.cause.tagContext#" index="loc.i">
			<cfset loc.pos = loc.pos + 1>
			<cfset loc.template = Replace(arguments.exception.cause.tagContext[loc.pos].template, loc.path, "")>
			<!--- show all non wheels lines --->
			<cfif loc.template Does Not Contain "wheels" AND FindOneOf("/\", loc.template) IS NOT 0>
				Line #arguments.exception.cause.tagContext[loc.pos].line# in #loc.template#<br>
			</cfif>
		</cfloop>
		</p>
	</cfif>
	<cfif IsDefined("application.wheels.rewriteFile")>
		<p>
			<strong>URL:</strong><br>
			#LCase(ListFirst(cgi.server_protocol, "/"))#://#cgi.server_name##Replace(cgi.script_name, "/#application.wheels.rewriteFile#", "")##cgi.path_info#<cfif cgi.query_string IS NOT "">?#cgi.query_string#</cfif>
		</p>
	</cfif>
	<cfif Len(cgi.http_referer)>
		<p><strong>Referrer:</strong><br>#cgi.http_referer#</p>
	</cfif>
	<p><strong>Method:</strong><br>#cgi.request_method#</p>
	<p><strong>IP Address:</strong><br>#cgi.remote_addr#</p>
	<cfif IsDefined("application.wheels.hostName")>
		<p><strong>Host Name:</strong><br>#application.wheels.hostName#</p>
	</cfif>
	<p><strong>User Agent:</strong><br>#cgi.http_user_agent#</p>
	<p><strong>Date & Time:</strong><br>#DateFormat(now(), "MMMM D, YYYY")# at #TimeFormat(now(), "h:MM TT")#</p>
	<cfset loc.scopes = "CGI,Form,URL,Application,Session,Request,Cookie,Arguments.Exception">
	<cfset loc.skip = "">
	<cfif IsDefined("application.wheels.excludeFromErrorEmail")>
		<cfset loc.skip = application.wheels.excludeFromErrorEmail>
	</cfif>
	<!--- always skip cause since it's just a copy of rootCause anyway --->
	<cfset loc.skip = ListAppend(loc.skip, "exception.cause")>
	<h1>Details</h1>
	<cfloop list="#loc.scopes#" index="loc.i">
		<cfset loc.scopeName = ListLast(loc.i, ".")>
		<cfif NOT ListFindNoCase(loc.skip, loc.scopeName) AND IsDefined(loc.scopeName)>
			<cftry>
				<cfset loc.scope = Evaluate(loc.i)>
				<cfif IsStruct(loc.scope)>
					<p><strong>#loc.scopeName#</strong>
					<cfset loc.hide = "wheels">
					<cfloop list="#loc.skip#" index="loc.j">
						<cfif loc.j Contains "." AND ListFirst(loc.j, ".") IS loc.scopeName>
							<cfset loc.hide = ListAppend(loc.hide, ListRest(loc.j, "."))>
						</cfif>
					</cfloop>
					<cfdump var="#loc.scope#" format="text" showUDFs="false" hide="#loc.hide#">
					</p>
				</cfif>
				<cfcatch type="any"><!--- just keep going, we need to send out error emails ---></cfcatch>
			</cftry>
		</cfif>
	</cfloop>
</cfoutput>
<cfoutput>
	<!--- cfformat-ignore-start --->
	<div class="ui container">
		<h1>Summary</h1>
		<p>
			<strong>Error:</strong>
			<br>
			<cfif
				StructKeyExists(arguments.exception, "rootcause")
				&& StructKeyExists(arguments.exception.rootcause, "message")
			>
				#arguments.exception.rootcause.message#
				<cfif arguments.exception.rootcause.detail IS NOT "">
					<br>#arguments.exception.rootcause.detail#
				</cfif>
			<cfelse>
				A root cause was not provided.
			</cfif>
		</p>
		<cfif
			StructKeyExists(arguments.exception, "cause")
			&& StructKeyExists(arguments.exception.cause, "tagContext")
			&& ArrayLen(arguments.exception.cause.tagContext)
		>
			<cfset local.tagContext = Duplicate(arguments.exception.cause.tagContext)>
		<cfelseif
			StructKeyExists(arguments.exception, "rootCause")
			&& StructKeyExists(arguments.exception.rootCause, "tagContext")
			&& ArrayLen(arguments.exception.rootCause.tagContext)
		>
			<cfset local.tagContext = Duplicate(arguments.exception.rootCause.tagContext)>
		<cfelseif
			StructKeyExists(arguments.exception, "tagContext")
			&& ArrayLen(arguments.exception.tagContext)
		>
			<cfset local.tagContext = Duplicate(arguments.exception.tagContext)>
		</cfif>
		<cfif StructKeyExists(local, "tagContext")>
			<p>
				<strong>Location:</strong>
				<br>
				<cfset local.path = GetDirectoryFromPath(GetBaseTemplatePath())>
				<cfset local.pos = 0>
				<cfloop array="#local.tagContext#" index="local.i">
					<cfset local.pos = local.pos + 1>
					<cfset local.template = Replace(local.tagContext[local.pos].template, local.path, "")>
					<cfset local.template = Replace(local.template, "/wheels../", "")>
					#local.template#:#local.tagContext[local.pos].line#<br>
				</cfloop>
			</p>
		</cfif>
		<cfif IsDefined("application.wheels.rewriteFile")>
			<p>
				<strong>URL:</strong>
				<br>
				http<cfif cgi.http_x_forwarded_proto EQ "https" OR cgi.server_port_secure EQ "true">s</cfif>://#cgi.server_name##Replace(cgi.script_name, "/#application.wheels.rewriteFile#", "")#<cfif IsDefined("request.cgi.path_info")>#request.cgi.path_info#<cfelse>#cgi.path_info#</cfif><cfif cgi.query_string IS NOT "">?#cgi.query_string#</cfif>
			</p>
		</cfif>
		<cfif Len(cgi.http_referer)>
			<p>
				<strong>Referrer:</strong>
				<br>#cgi.http_referer#
			</p>
		</cfif>
		<p>
			<strong>Method:</strong>
			<br>#cgi.request_method#
		</p>
		<p>
			<strong>IP Address:</strong>
			<br>#cgi.remote_addr#
		</p>
		<cfif IsDefined("application.wheels.hostName")>
			<p>
				<strong>Host Name:</strong>
				<br>#application.wheels.hostName#
			</p>
		</cfif>
		<p>
			<strong>User Agent:</strong>
			<br>#cgi.http_user_agent#
		</p>
		<p>
			<strong>Date & Time:</strong>
			<br>#DateFormat(Now(), "MMMM D, YYYY")# at #TimeFormat(Now(), "h:MM TT")#
		</p>
		<cfset local.scopes = "CGI,Form,URL,Application,Session,Request,Cookie,Arguments.Exception">
		<cfset local.skip = "">
		<cfif IsDefined("application.wheels.excludeFromErrorEmail")>
			<cfset local.skip = application.wheels.excludeFromErrorEmail>
		</cfif>
		<!--- always skip cause since it's just a copy of rootCause anyway --->
		<cfset local.skip = ListAppend(local.skip, "exception.cause")>
		<h1>Details</h1>
		<cfloop list="#local.scopes#" index="local.i">
			<cfset local.scopeName = ListLast(local.i, ".")>
			<cfif NOT ListFindNoCase(local.skip, local.scopeName) AND IsDefined(local.scopeName)>
				<cftry>
					<cfset local.scope = Evaluate(local.i)>
					<cfif IsStruct(local.scope)>
						<p>
							<strong>#local.scopeName#</strong>
							<cfset local.hide = "wheels">
							<cfloop list="#local.skip#" index="local.j">
								<cfif local.j Contains "." AND ListFirst(local.j, ".") IS local.scopeName>
									<cfset local.hide = ListAppend(local.hide, ListRest(local.j, "."))>
								</cfif>
							</cfloop>
							<pre>
								<cfdump var="#local.scope#" format="text" showUDFs="false" hide="#local.hide#">
							</pre>
						</p>
					</cfif>
					<cfcatch type="any"><!--- just keep going, we need to send out error emails ---></cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</div>
	<!--- cfformat-ignore-end --->
</cfoutput>

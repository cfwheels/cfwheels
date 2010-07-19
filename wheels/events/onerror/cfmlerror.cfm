<cfoutput>
<h1>Summary</h1>
<p><strong>Error:</strong><br />#arguments.exception.cause.message#<cfif arguments.exception.cause.detail IS NOT ""><br />#arguments.exception.cause.detail#</cfif></p>
<p><strong>Location:</strong><br /><cfif StructKeyExists(arguments.exception.cause, "tagContext") && ArrayLen(arguments.exception.cause.tagContext)>Line #arguments.exception.cause.tagContext[1]["line"]# in #arguments.exception.cause.tagContext[1]["template"]#<cfelse>Unknown</cfif></p>
<cfif IsDefined("application.wheels.rewriteFile")>
	<p><strong>URL:</strong><br />http://#request.cgi.server_name##Replace(request.cgi.script_name, "/#application.wheels.rewriteFile#", "")##request.cgi.path_info#<cfif request.cgi.query_string IS NOT "">?#request.cgi.query_string#</cfif></p>
</cfif>
<p><strong>IP Address:</strong><br />#request.cgi.remote_addr#</p>
<p><strong>Date & Time:</strong><br />#DateFormat(now(), "MMMM D, YYYY")# at #TimeFormat(now(), "h:MM TT")#</p>
<cfset loc.scopes = "CGI,Form,URL,Application,Session,Request,Cookie,Arguments.Exception">
<cfset loc.skip = get("excludeFromErrorEmail")>
<cfloop list="#loc.scopes#" index="loc.i">
	<cfset loc.scopeName = ListLast(loc.i, ".")>
	<cfif NOT ListFindNoCase(loc.skip, loc.scopeName) AND IsDefined(loc.scopeName) AND IsStruct(loc.scopeName)>
		<cfset loc.scopeCopy = Duplicate(Evaluate(loc.i))>
		<cfloop list="#loc.skip#" index="loc.j">
			<cfif loc.j Contains "." AND ListFirst(loc.j, ".") IS loc.scopeName AND StructKeyExists(loc.scopeCopy, ListRest(loc.j, "."))>
				<cfset StructDelete(loc.scopeCopy, ListRest(loc.j, "."))>
			</cfif>
		</cfloop>
		<h2>#loc.scopeName#</h2>
		<cfdump var="#loc.scopeCopy#" format="text" showUDFs="false" hide="wheels">
	</cfif>
</cfloop>
</cfoutput>
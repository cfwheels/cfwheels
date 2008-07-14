<cffunction name="URLFor" returntype="string" access="private" output="false">
	<cfargument name="route" type="string" required="false" default="">
	<cfargument name="controller" type="string" required="false" default="">
	<cfargument name="action" type="string" required="false" default="">
	<cfargument name="id" type="numeric" required="false" default=0>
	<cfargument name="params" type="string" required="false" default="">
	<cfargument name="anchor" type="string" required="false" default="">
	<cfargument name="onlyPath" type="boolean" required="false" default="true">
	<cfargument name="host" type="string" required="false" default="">
	<cfargument name="protocol" type="string" required="false" default="">
	<cfset var locals = structNew()>

	<!--- build the link --->
	<cfif len(arguments.route) IS 0 AND len(arguments.controller) IS 0 AND len(arguments.action) IS 0 AND arguments.id IS 0 AND len(arguments.params) IS 0>
		<cfset locals.url = "/">
	<cfelse>
		<cfset locals.url = application.wheels.webPath & listLast(CGI.SCRIPT_NAME, "/")>
		<cfif len(arguments.route) IS NOT 0>
			<!--- link for a named route --->
			<cfset locals.route = application.wheels.routes[application.wheels.namedRoutePositions[arguments.route]]>
			<cfloop list="#locals.route.pattern#" index="locals.i" delimiters="/">
				<cfif locals.i Contains "[">
					<!--- get param from arguments --->
					<cfset locals.url = locals.url & "/" & arguments[mid(locals.i, 2, len(locals.i)-2)]>
				<cfelse>
					<!--- add hard coded param from route --->
					<cfset locals.url = locals.url & "/" & locals.i>
				</cfif>
			</cfloop>
		<cfelse>
			<!--- link based on controller/action/id --->
			<cfif len(arguments.controller) IS NOT 0>
				<!--- add controller from arguments --->
				<cfset locals.url = locals.url & "/" & arguments.controller>
			<cfelse>
				<!--- keep the controller name from the current request --->
				<cfset locals.url = locals.url & "/" & variables.params.controller>
			</cfif>
			<cfif len(arguments.action) IS NOT 0>
				<!--- add the action --->
				<cfset locals.url = locals.url & "/" & arguments.action>
			</cfif>
			<cfif arguments.id IS NOT 0>
				<!--- add the id and obfuscate if necessary --->
				<cfif application.settings.obfuscateURLs>
					<cfset locals.url = locals.url & "/" & obfuscateParam(arguments.id)>
				<cfelse>
					<cfset locals.url = locals.url & "/" & arguments.id>
				</cfif>
			</cfif>
		</cfif>
		<cfif len(arguments.params) IS NOT 0>
			<!--- add the params and obfuscate if necessary --->
			<cfset locals.url = locals.url & $constructParams(arguments.params)>
		</cfif>
		<cfif len(arguments.anchor) IS NOT 0>
			<!--- add the anchor --->
			<cfset locals.url = locals.url & "##" & arguments.anchor>
		</cfif>
		<!--- Fix when URL rewriting is in use --->
		<cfset locals.url = replace(locals.url, "rewrite.cfm/", "")>
	</cfif>

	<cfif NOT arguments.onlyPath>
		<!--- add host and protocol --->
		<cfif len(arguments.host) IS NOT 0>
			<cfset locals.url = arguments.host & locals.url>
		<cfelse>
			<cfset locals.url = CGI.SERVER_NAME & locals.url>
		</cfif>
		<cfif len(arguments.protocol) IS NOT 0>
			<cfset locals.url = arguments.protocol & "://" & locals.url>
		<cfelse>
			<cfset locals.url = lCase(spanExcluding(CGI.SERVER_PROTOCOL, "/")) & "://" & locals.url>
		</cfif>
	</cfif>

	<cfreturn lCase(locals.url)>
</cffunction>

<cffunction name="isGet" returntype="boolean" access="public" output="false" hint="Returns whether the request was a normal (GET) request or not">
	<!---
		EXAMPLES:
		<cfset requestIsGet = isGet()>
	--->
	<cfif CGI.REQUEST_METHOD IS "get">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="isPost" returntype="boolean" access="public" output="false" hint="Returns whether the request came from a form submission or not">
	<!---
		EXAMPLES:
		<cfset requestIsPost = isPost()>
	--->
	<cfif CGI.REQUEST_METHOD IS "post">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="isAjax" returntype="boolean" access="public" output="false" hint="Returns whether the page was called from JavaScript or not">
	<!---
		EXAMPLES:
		<cfset requestIsAjax = isAjax()>
	--->
	<cfif CGI.HTTP_X_REQUESTED_WITH IS "XMLHTTPRequest">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="sendEmail" returntype="void" access="public" output="false">
	<cfargument name="template" type="string" required="true">
	<cfargument name="layout" type="any" required="false" default="false">
	<cfset var local = structNew()>

	<cfsavecontent variable="request.wheels.response">
		<cfinclude template="../../views/email/#replaceNoCase(arguments.template, '.cfm', '')#.cfm">
	</cfsavecontent>

	<cfif (isBoolean(arguments.layout) AND arguments.layout) OR (arguments.layout IS NOT "false")>
		<cfif NOT isBoolean(arguments.layout)>
			<cfsavecontent variable="request.wheels.response">
				<cfinclude template="../../views/layouts/#replace(arguments.layout, ' ', '', 'all')#.cfm">
			</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="request.wheels.response">
				<cfinclude template="../../views/layouts/email.cfm">
			</cfsavecontent>
		</cfif>
	</cfif>

	<cfset locals.attributes = structCopy(arguments)>
	<cfset locals.cfmailAttributes = "from,to,bcc,cc,charset,debug,failto,group,groupcasesensitive,mailerid,maxrows,mimeattach,password,port,priority,query,replyto,server,spoolenable,startrow,subject,timeout,type,username,useSSL,useTLS,wraptext">
	<cfloop collection="#locals.attributes#" item="locals.i">
		<cfif listFindNoCase(locals.cfmailAttributes, locals.i) IS 0>
			<cfset structDelete(locals.attributes, locals.i)>
		</cfif>
	</cfloop>

	<cfmail from="#arguments.from#" to="#arguments.to#" subject="#arguments.subject#" attributecollection="#locals.attributes#">#trim(request.wheels.response)#</cfmail>

	<!--- delete the response so that Wheels does not think we have rendered an actual response to the browser --->
	<cfset structDelete(request.wheels, "response")>

</cffunction>

<cffunction name="sendFile" returntype="void" access="public" output="false">
	<cfargument name="file" type="string" required="true">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false" default="">
	<cfargument name="disposition" type="string" required="false" default="attachment">
	<cfset var locals = structNew()>

	<cfset arguments.file = replace(arguments.file, "\", "/", "all")>
	<cfset locals.path = reverse(listRest(reverse(arguments.file), "/"))>
	<cfset locals.folder = application.settings.paths.files>
	<cfif len(locals.path) IS NOT 0>
		<cfset locals.folder = locals.folder & "/" & locals.path>
		<cfset locals.file = replace(arguments.file, locals.path, "")>
		<cfset locals.file = right(locals.file, len(locals.file)-1)>
	<cfelse>
		<cfset locals.file = arguments.file>
	</cfif>
	<cfset locals.folder = expandPath(locals.folder)>
	<cfif NOT fileExists(locals.folder & "/" & locals.file)>
		<cfdirectory action="list" directory="#locals.folder#" name="locals.match" filter="#locals.file#.*">
		<cfif locals.match.recordcount IS 0>
			<cfthrow type="wheels" message="File not found" detail="Make sure a file with the name <tt>#locals.file#</tt> exists in the <tt>#locals.folder#</tt> folder.">
		</cfif>
		<cfset locals.file = locals.file & "." & listLast(locals.match.name, ".")>
	</cfif>

	<cfset locals.fullPath = locals.folder & "/" & locals.file>

	<cfif len(arguments.name) IS NOT 0>
		<cfset locals.name = arguments.name>
	<cfelse>
		<cfset locals.name = locals.file>
	</cfif>

	<cfset locals.extension = listLast(locals.file, ".")>
	<cfif locals.extension IS "txt">
		<cfset locals.type = "text/plain">
	<cfelseif locals.extension IS "gif">
		<cfset locals.type = "image/gif">
	<cfelseif locals.extension IS "jpg">
		<cfset locals.type = "image/jpg">
	<cfelseif locals.extension IS "png">
		<cfset locals.type = "image/png">
	<cfelseif locals.extension IS "wav">
		<cfset locals.type = "audio/wav">
	<cfelseif locals.extension IS "mp3">
		<cfset locals.type = "audio/mpeg3">
	<cfelseif locals.extension IS "pdf">
		<cfset locals.type = "application/pdf">
	<cfelseif locals.extension IS "zip">
		<cfset locals.type = "application/zip">
	<cfelseif locals.extension IS "ppt">
		<cfset locals.type = "application/powerpoint">
	<cfelseif locals.extension IS "doc">
		<cfset locals.type = "application/word">
	<cfelseif locals.extension IS "xls">
		<cfset locals.type = "application/excel">
	<cfelse>
		<cfset locals.type = "application/octet-stream">
	</cfif>

	<cfheader name="content-disposition" value="#arguments.disposition#; filename=""#locals.name#""">
	<cfcontent type="#locals.type#" file="#locals.fullPath#">

</cffunction>
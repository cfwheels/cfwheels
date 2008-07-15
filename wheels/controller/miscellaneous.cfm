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
	<cfset var loc = {}>

	<!--- build the link --->
	<cfif Len(arguments.route) IS 0 AND Len(arguments.controller) IS 0 AND Len(arguments.action) IS 0 AND arguments.id IS 0 AND Len(arguments.params) IS 0>
		<cfset loc.url = "/">
	<cfelse>
		<cfset loc.url = application.wheels.webPath & listLast(cgi.script_name, "/")>
		<cfif Len(arguments.route) IS NOT 0>
			<!--- link for a named route --->
			<cfset loc.route = application.wheels.routes[application.wheels.namedRoutePositions[arguments.route]]>
			<cfloop list="#loc.route.pattern#" index="loc.i" delimiters="/">
				<cfif loc.i Contains "[">
					<!--- get param from arguments --->
					<cfset loc.url = loc.url & "/" & arguments[mid(loc.i, 2, Len(loc.i)-2)]>
				<cfelse>
					<!--- add hard coded param from route --->
					<cfset loc.url = loc.url & "/" & loc.i>
				</cfif>
			</cfloop>
		<cfelse>
			<!--- link based on controller/action/id --->
			<cfif Len(arguments.controller) IS NOT 0>
				<!--- add controller from arguments --->
				<cfset loc.url = loc.url & "/" & arguments.controller>
			<cfelse>
				<!--- keep the controller name from the current request --->
				<cfset loc.url = loc.url & "/" & variables.params.controller>
			</cfif>
			<cfif Len(arguments.action) IS NOT 0>
				<!--- add the action --->
				<cfset loc.url = loc.url & "/" & arguments.action>
			</cfif>
			<cfif arguments.id IS NOT 0>
				<!--- add the id and obfuscate if necessary --->
				<cfif application.settings.obfuscateURLs>
					<cfset loc.url = loc.url & "/" & obfuscateParam(arguments.id)>
				<cfelse>
					<cfset loc.url = loc.url & "/" & arguments.id>
				</cfif>
			</cfif>
		</cfif>
		<cfif Len(arguments.params) IS NOT 0>
			<!--- add the params and obfuscate if necessary --->
			<cfset loc.url = loc.url & $constructParams(arguments.params)>
		</cfif>
		<cfif Len(arguments.anchor) IS NOT 0>
			<!--- add the anchor --->
			<cfset loc.url = loc.url & "##" & arguments.anchor>
		</cfif>
		<!--- Fix when URL rewriting is in use --->
		<cfset loc.url = replace(loc.url, "rewrite.cfm/", "")>
	</cfif>

	<cfif NOT arguments.onlyPath>
		<!--- add host and protocol --->
		<cfif Len(arguments.host) IS NOT 0>
			<cfset loc.url = arguments.host & loc.url>
		<cfelse>
			<cfset loc.url = cgi.server_name & loc.url>
		</cfif>
		<cfif Len(arguments.protocol) IS NOT 0>
			<cfset loc.url = arguments.protocol & "://" & loc.url>
		<cfelse>
			<cfset loc.url = lCase(spanExcluding(cgi.server_protocol, "/")) & "://" & loc.url>
		</cfif>
	</cfif>

	<cfreturn lCase(loc.url)>
</cffunction>

<cffunction name="isGet" returntype="boolean" access="public" output="false" hint="Returns whether the request was a normal (GET) request or not">
	<!---
		EXAMPLES:
		<cfset requestIsGet = isGet()>
	--->
	<cfif cgi.request_method IS "get">
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
	<cfif cgi.request_method IS "post">
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
	<cfif cgi.http_x_requested_with IS "XMLHTTPRequest">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="sendEmail" returntype="void" access="public" output="false">
	<cfargument name="template" type="string" required="true">
	<cfargument name="layout" type="any" required="false" default="false">
	<cfset var loc = {}>

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

	<cfset loc.attributes = structCopy(arguments)>
	<cfset loc.cfmailAttributes = "from,to,bcc,cc,charset,debug,failto,group,groupcasesensitive,mailerid,maxrows,mimeattach,password,port,priority,query,replyto,server,spoolenable,startrow,subject,timeout,type,username,useSSL,useTLS,wraptext">
	<cfloop collection="#loc.attributes#" item="loc.i">
		<cfif listFindNoCase(loc.cfmailAttributes, loc.i) IS 0>
			<cfset StructDelete(loc.attributes, loc.i)>
		</cfif>
	</cfloop>

	<cfmail from="#arguments.from#" to="#arguments.to#" subject="#arguments.subject#" attributecollection="#loc.attributes#">#trim(request.wheels.response)#</cfmail>

	<!--- delete the response so that Wheels does not think we have rendered an actual response to the browser --->
	<cfset StructDelete(request.wheels, "response")>

</cffunction>

<cffunction name="sendFile" returntype="void" access="public" output="false">
	<cfargument name="file" type="string" required="true">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false" default="">
	<cfargument name="disposition" type="string" required="false" default="attachment">
	<cfset var loc = {}>

	<cfset arguments.file = replace(arguments.file, "\", "/", "all")>
	<cfset loc.path = Reverse(ListRest(Reverse(arguments.file), "/"))>
	<cfset loc.folder = application.settings.paths.files>
	<cfif Len(loc.path) IS NOT 0>
		<cfset loc.folder = loc.folder & "/" & loc.path>
		<cfset loc.file = replace(arguments.file, loc.path, "")>
		<cfset loc.file = Right(loc.file, Len(loc.file)-1)>
	<cfelse>
		<cfset loc.file = arguments.file>
	</cfif>
	<cfset loc.folder = expandPath(loc.folder)>
	<cfif NOT fileExists(loc.folder & "/" & loc.file)>
		<cfdirectory action="list" directory="#loc.folder#" name="loc.match" filter="#loc.file#.*">
		<cfif loc.match.recordcount IS 0>
			<cfthrow type="Wheels" message="File Not Found" extendedInfo="Make sure a file with the name <tt>#loc.file#</tt> exists in the <tt>#loc.folder#</tt> folder.">
		</cfif>
		<cfset loc.file = loc.file & "." & listLast(loc.match.name, ".")>
	</cfif>

	<cfset loc.fullPath = loc.folder & "/" & loc.file>

	<cfif Len(arguments.name) IS NOT 0>
		<cfset loc.name = arguments.name>
	<cfelse>
		<cfset loc.name = loc.file>
	</cfif>

	<cfset loc.extension = listLast(loc.file, ".")>
	<cfif loc.extension IS "txt">
		<cfset loc.type = "text/plain">
	<cfelseif loc.extension IS "gif">
		<cfset loc.type = "image/gif">
	<cfelseif loc.extension IS "jpg">
		<cfset loc.type = "image/jpg">
	<cfelseif loc.extension IS "png">
		<cfset loc.type = "image/png">
	<cfelseif loc.extension IS "wav">
		<cfset loc.type = "audio/wav">
	<cfelseif loc.extension IS "mp3">
		<cfset loc.type = "audio/mpeg3">
	<cfelseif loc.extension IS "pdf">
		<cfset loc.type = "application/pdf">
	<cfelseif loc.extension IS "zip">
		<cfset loc.type = "application/zip">
	<cfelseif loc.extension IS "ppt">
		<cfset loc.type = "application/powerpoint">
	<cfelseif loc.extension IS "doc">
		<cfset loc.type = "application/word">
	<cfelseif loc.extension IS "xls">
		<cfset loc.type = "application/excel">
	<cfelse>
		<cfset loc.type = "application/octet-stream">
	</cfif>

	<cfheader name="content-disposition" value="#arguments.disposition#; filename=""#loc.name#""">
	<cfcontent type="#loc.type#" file="#loc.fullPath#">

</cffunction>
<cffunction name="CFW_trimHTML" returntype="any" access="private" output="false">
	<cfargument name="str" type="any" required="true">
	<cfreturn replaceList(trim(arguments.str), "#chr(9)#,#chr(10)#,#chr(13)#", ",,")>
</cffunction>


<cffunction name="CFW_getAttributes" returntype="any" access="private" output="false">
	<cfset var local = structNew()>

	<cfset local.attributes = "">
	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i Does Not Contain "_" AND listFindNoCase(arguments.CFW_named_arguments, local.i) IS 0>
			<cfset local.attributes = "#local.attributes# #lCase(local.i)#=""#arguments[local.i]#""">
		</cfif>
	</cfloop>

	<cfreturn local.attributes>
</cffunction>


<cffunction name="CFW_constructParams" returntype="any" access="private" output="false">
	<cfargument name="params" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.delim = "?">
	<cfif application.settings.obfuscate_urls>
		<cfset local.params = "">
		<cfloop list="#arguments.params#" delimiters="&" index="local.i">
			<cfset local.temp = listToArray(local.i, "=")>
			<cfset local.params = local.params & local.delim & local.temp[1] & "=">
			<cfif arrayLen(local.temp) IS 2>
				<cfset local.params = local.params & encryptParam(local.temp[2])>
			</cfif>
			<cfset local.delim = "&">
		</cfloop>
	<cfelse>
		<cfset local.params = local.delim & arguments.params>
	</cfif>

	<cfreturn local.params>
</cffunction>


<cffunction name="URLFor" returntype="any" access="private" output="false">
	<cfargument name="controller" type="any" required="false" default="">
	<cfargument name="action" type="any" required="false" default="">
	<cfargument name="id" type="any" required="false" default=0>
	<cfargument name="anchor" type="any" required="false" default="">
	<cfargument name="only_path" type="any" required="false" default="true">
	<cfargument name="host" type="any" required="false" default="">
	<cfargument name="protocol" type="any" required="false" default="">
	<cfargument name="params" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfif len(arguments.controller) IS NOT 0>
		<cfset local.new_controller = arguments.controller>
	<cfelse>
		<cfset local.new_controller = variables.params.controller>
	</cfif>

	<cfif len(arguments.action) IS NOT 0>
		<cfset local.new_action = arguments.action>
	<cfelse>
		<cfif local.new_controller IS variables.params.controller>
			<!--- Keep the action only if controller stays the same --->
			<cfset local.new_action = variables.params.action>
		</cfif>
	</cfif>

	<cfif arguments.id IS NOT 0>
		<cfset local.new_id = arguments.id>
	<cfelse>
		<cfif structKeyExists(variables.params, "id") AND len(variables.params.id) IS NOT 0 AND local.new_controller IS variables.params.controller AND local.new_action IS variables.params.action>
			<!--- Keep the ID only if controller and action stays the same --->
			<cfset local.new_id = variables.params.id>
		</cfif>
	</cfif>

	<!--- Build the link --->
	<cfset local.url = application.wheels.web_path & listLast(CGI.script_name, "/")>

	<!--- Add the controller to the link --->
	<cfset local.url = local.url & "/#local.new_controller#">

	<!--- Fix when URL rewriting is in use --->

	<cfset local.url = replace(local.url, "index_rewrite.cfm/", "")>

	<cfif structKeyExists(local, "new_action")>
		<!--- Add the action to the link --->
		<cfset local.url = local.url & "/#local.new_action#">
	</cfif>

	<cfif structKeyExists(local, "new_id")>
		<!--- Add the id to the link --->
		<cfif application.settings.obfuscate_urls>
			<cfset local.new_id = encryptParam(local.new_id)>
		</cfif>
		<cfset local.url = local.url & "/#local.new_id#">
	</cfif>

	<cfif len(arguments.params) IS NOT 0>
		<!--- add the params to the link --->
		<cfset local.url = local.url & CFW_constructParams(arguments.params)>
	</cfif>

	<cfif len(arguments.anchor) IS NOT 0>
		<cfset local.url = local.url & "##" & arguments.anchor>
	</cfif>

	<cfif NOT arguments.only_path>
		<cfif len(arguments.host) IS NOT 0>
			<cfset local.url = arguments.host & local.url>
		<cfelse>
			<cfset local.url = CGI.server_name & local.url>
		</cfif>
		<cfif len(arguments.protocol) IS NOT 0>
			<cfset local.url = arguments.protocol & "://" & local.url>
		<cfelse>
			<cfset local.url = lCase(spanExcluding(CGI.server_protocol, "/")) & "://" & local.url>
		</cfif>
	</cfif>

	<cfreturn lCase(local.url)>
</cffunction>


<cffunction name="contentForLayout" returntype="any" access="public" output="false">
	<cfreturn request.wheels.response>
</cffunction>

<cffunction name="linkTo" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="false" default="">
	<cfargument name="text" type="any" required="false" default="">
	<cfargument name="confirm" type="any" required="false" default="">
	<!--- Accepts URLFor arguments --->
	<cfset var local = structNew()>
	<cfset local.named_arguments = "link,text,confirm,controller,action,id,anchor,only_path,host,protocol,params">
	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<!--- Since a non-numeric id was passed in we assume it is meant as a HTML attribute and therefore remove it from the named arguments list so that it will be set in the attributes --->
		<cfset local.named_arguments = listDeleteAt(local.named_arguments, listFindNoCase(local.named_arguments, "id"))>
	</cfif>

	<cfset local.attributes = "">
	<cfloop collection="#arguments#" item="local.i">
		<cfif listFindNoCase(local.named_arguments, local.i) IS 0>
			<cfset local.attributes = "#local.attributes# #lCase(local.i)#=""#arguments[local.i]#""">
		</cfif>
	</cfloop>

	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<cfset structDelete(arguments, "id")>
	</cfif>

	<cfif len(arguments.link) IS NOT 0>
		<cfset local.href = arguments.link>
	<cfelse>
		<cfset local.href = URLFor(argumentCollection=arguments)>
	</cfif>

	<cfif len(arguments.text) IS NOT 0>
		<cfset local.text = arguments.text>
	<cfelse>
		<cfset local.text = local.href>
	</cfif>

	<cfif len(arguments.confirm) IS NOT 0>
		<cfset local.html = "<a href=""#HTMLEditFormat(local.href)#"" onclick=""return confirm('#JSStringFormat(arguments.confirm)#');""#local.attributes#>#local.text#</a>">
	<cfelse>
		<cfset local.html = "<a href=""#HTMLEditFormat(local.href)#""#local.attributes#>#local.text#</a>">
	</cfif>

	<cfreturn local.html>
</cffunction>


<cffunction name="isGet" returntype="any" access="public" output="false">
	<cfif CGI.request_method IS "get">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="isPost" returntype="any" access="public" output="false">
	<cfif CGI.request_method IS "post">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="isAjax" returntype="any" access="public" output="false">
	<cfif CGI.HTTP_x_requested_with IS "XMLHTTPRequest">
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="sendEmail" returntype="any" access="public" output="false">
	<cfargument name="template" type="any" required="true">
	<cfargument name="layout" type="any" required="false" default="false">
	<cfset var local = structNew()>

	<cfsavecontent variable="request.wheels.response">
		<cfinclude template="../../views/email/#replaceNoCase(arguments.template, '.cfm', '')#.cfm">
	</cfsavecontent>

	<cfif (isBoolean(arguments.layout) AND arguments.layout) OR (arguments.layout IS NOT "false")>
		<cfif NOT isBoolean(arguments.layout)>
			<cfsavecontent variable="request.wheels.response">
				<cfinclude template="../../views/layouts/#replace(arguments.layout, ' ', '_', 'all')#_layout.cfm">
			</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="request.wheels.response">
				<cfinclude template="../../views/layouts/email_layout.cfm">
			</cfsavecontent>
		</cfif>
	</cfif>

	<cfset local.attributes = structCopy(arguments)>
	<cfset local.cfmail_valid_attributes = "from,to,bcc,cc,charset,debug,failto,group,groupcasesensitive,mailerid,maxrows,mimeattach,password,port,priority,query,replyto,server,spoolenable,startrow,subject,timeout,type,username,useSSL,useTLS,wraptext">
	<cfloop collection="#local.attributes#" item="local.i">
		<cfif listFindNoCase(local.cfmail_valid_attributes, local.i) IS 0>
			<cfset structDelete(local.attributes, local.i)>
		</cfif>
	</cfloop>

	<cfmail attributecollection="#local.attributes#">
	#request.wheels.response#
	</cfmail>

	<!--- set to false so that Wheels does not think we have rendered an actual response to the browser --->
	<cfset request.wheels.response = false>

</cffunction>


<cffunction name="sendFile" returntype="any" access="public" output="false">
	<cfargument name="path" required="true">
	<cfargument name="filename" required="false" default="">
	<cfargument name="type" required="false" default="">
	<cfargument name="disposition" required="false" default="attachment">
	<cfset var local = structNew()>

	<cfset local.file_directory = expandPath(application.settings.paths.files)>

	<cfif arguments.path Contains ".">
		<cfset local.path = arguments.path>
	<cfelse>
		<cfdirectory action="list" directory="#local.file_directory#" name="local.match" filter="#arguments.path#.*">
		<cfset local.path = arguments.path & "." & listLast(local.match.name, ".")>
	</cfif>

	<cfset local.filename = listLast(local.path, "/")>

	<cfset local.extension = listLast(local.path, ".")>
	<cfif local.extension IS "txt">
		<cfset local.type = "text/plain">
	<cfelseif local.extension IS "gif">
		<cfset local.type = "image/gif">
	<cfelseif local.extension IS "jpg">
		<cfset local.type = "image/jpg">
	<cfelseif local.extension IS "png">
		<cfset local.type = "image/png">
	<cfelseif local.extension IS "wav">
		<cfset local.type = "audio/wav">
	<cfelseif local.extension IS "mp3">
		<cfset local.type = "audio/mpeg3">
	<cfelseif local.extension IS "pdf">
		<cfset local.type = "application/pdf">
	<cfelseif local.extension IS "zip">
		<cfset local.type = "application/zip">
	<cfelseif local.extension IS "ppt">
		<cfset local.type = "application/powerpoint">
	<cfelseif local.extension IS "doc">
		<cfset local.type = "application/word">
	<cfelseif local.extension IS "xls">
		<cfset local.type = "application/excel">
	<cfelse>
		<cfset local.type = "application/octet-stream">
	</cfif>

	<cfset local.file = "#local.file_directory#/#local.path#">

	<cfheader name="content-disposition" value="#arguments.disposition#; filename=#local.filename#">
	<cfcontent type="#local.type#" file="#local.file#">

	<cfreturn true>
</cffunction>


<cffunction name="getControllerClassData" returntype="any" access="public" output="false">
	<cfreturn variables.wheels>
</cffunction>
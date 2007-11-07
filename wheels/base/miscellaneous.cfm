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


<cffunction name="addRoute" returntype="any" access="public" output="false">
	<cfargument name="pattern" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfif NOT structKeyExists(arguments, "controller") AND arguments.pattern Does Not Contain "[controller]">
		<cfset arguments.controller = application.settings.default_controller>
	</cfif>

	<cfif NOT structKeyExists(arguments, "action") AND arguments.pattern Does Not Contain "[action]">
		<cfset arguments.action = application.settings.default_action>
	</cfif>

	<cfset local.this_route = structNew()>
	<cfset local.this_route.pattern = arguments.pattern>
	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i IS NOT "pattern">
			<cfset local.this_route[local.i] = arguments[local.i]>
		</cfif>
	</cfloop>

	<cfset arrayAppend(application.wheels.routes, local.this_route)>

</cffunction>


<cffunction name="model" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset var local = structNew()>
	<cfif application.settings.environment IS NOT "production">
		<cfinclude template="../errors/model.cfm">
	</cfif>

	<cfif NOT structKeyExists(application.wheels.models, arguments.name)>
   	<cflock name="model_lock" type="exclusive" timeout="30">
			<cfif NOT structKeyExists(application.wheels.models, arguments.name)>
				<cfset application.wheels.models[arguments.name] = createObject("component", "models.#lCase(arguments.name)#")._initModelClass(arguments.name)>
			</cfif>
		</cflock>
	</cfif>

	<cfreturn application.wheels.models[arguments.name]>
</cffunction>


<cffunction name="_controller" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset var local = structNew()>

	<cfif NOT structKeyExists(application.wheels.controllers, arguments.name)>
   	<cflock name="controller_lock" type="exclusive" timeout="30">
			<cfif NOT structKeyExists(application.wheels.controllers, arguments.name)>
				<cfset application.wheels.controllers[arguments.name] = createObject("component", "controllers.#lCase(arguments.name)#")._initControllerClass(arguments.name)>
			</cfif>
		</cflock>
	</cfif>

	<cfreturn application.wheels.controllers[arguments.name]>
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


<cffunction name="hashStruct" returntype="any" access="public" output="false">
	<cfargument name="args" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.output = "">
	<cfloop collection="#arguments.args#" item="local.i">
		<cfif isSimpleValue(arguments.args[local.i])>
			<cfset local.element = lCase(local.i) & "=" & """" & lCase(arguments.args[local.i]) & """">
			<cfset local.output = listAppend(local.output, local.element, chr(7))>
		</cfif>
	</cfloop>
	<cfset local.output = hash(listSort(local.output, "text", "asc", chr(7)))>

	<cfreturn local.output>
</cffunction>


<cffunction name="encryptParam" returntype="any" access="public" output="false">
	<cfargument name="param" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.encrypted_param = arguments.param>

	<cfif isNumeric(local.encrypted_param)>
		<cfset local.length = len(local.encrypted_param)>
		<cfset local.a = (10^local.length) + reverse(local.encrypted_param)>
		<cfset local.b = "0">
		<cfloop from="1" to="#local.length#" index="local.i">
			<cfset local.b = (local.b + left(right(local.encrypted_param, local.i), 1))>
		</cfloop>
		<cfset local.encrypted_param = formatbaseN((local.b+154),16) & formatbasen(bitxor(local.a,461),16)>
	</cfif>

	<cfreturn local.encrypted_param>
</cffunction>

<cffunction name="decryptParam" returntype="any" access="public" output="false">
	<cfargument name="param" type="any" required="true">
	<cfset var local = structNew()>

	<cftry>
		<cfset local.checksum = left(arguments.param, 2)>
		<cfset local.decrypted_param = right(arguments.param, (len(arguments.param)-2))>
		<cfset local.z = bitxor(inputbasen(local.decrypted_param,16),461)>
		<cfset local.decrypted_param = "">
		<cfloop from="1" to="#(len(local.z)-1)#" index="local.i">
				<cfset local.decrypted_param = local.decrypted_param & left(right(local.z, local.i),1)>
		</cfloop>
		<cfset local.checksumtest = "0">
		<cfloop from="1" to="#len(local.decrypted_param)#" index="local.i">
				<cfset local.checksumtest = (local.checksumtest + left(right(local.decrypted_param, local.i),1))>
		</cfloop>
		<cfif left(tostring(formatbaseN((local.checksumtest+154),10)),2) IS NOT left(inputbaseN(local.checksum, 16),2)>
			<cfset local.decrypted_param = arguments.param>
		</cfif>
		<cfcatch>
			<cfset local.decrypted_param = arguments.param>
		</cfcatch>
	</cftry>

	<cfreturn local.decrypted_param>
</cffunction>


<cffunction name="setPaginationInfo" returntype="any" access="public" output="false">
	<cfargument name="query" type="any" required="true">
	<cfargument name="current_page" type="any" required="true">
	<cfargument name="total_pages" type="any" required="true">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfset var local = structNew()>

	<cfset request.wheels[arguments.handle] = structNew()>
	<cfset request.wheels[arguments.handle].current_page = arguments.current_page>
	<cfset request.wheels[arguments.handle].total_pages = arguments.total_pages>
	<cfset request.wheels[arguments.handle].total_records = arguments.query.recordcount>

	<cfreturn true>
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
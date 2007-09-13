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
	<cfargument name="model_name" type="any" required="true">
	<cfset var local = structNew()>

	<cfif NOT structKeyExists(application.wheels.models, arguments.model_name)>
   	<cflock name="model_lock" type="exclusive" timeout="10">
			<cfif NOT structKeyExists(application.wheels.models, arguments.model_name)>
				<cfset application.wheels.models[arguments.model_name] = createObject("component", "#application.wheels.cfc_path#models.#lCase(arguments.model_name)#").FL_initModel()>
			</cfif>
		</cflock>
	</cfif>

	<cfreturn application.wheels.models[arguments.model_name]>
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
		<cfset local.url = local.url & FL_constructID(local.new_id)>
	</cfif>

	<cfif len(arguments.params) IS NOT 0>
		<!--- add the params to the link --->
		<cfset local.url = local.url & FL_constructParams(arguments.params)>
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


<cffunction name="FL_constructID" returntype="any" access="private" output="false">
	<cfargument name="id" type="any" required="true">

	<cfif application.settings.obfuscate_urls>
		<cfset arguments.id = encryptParam(arguments.id)>
	</cfif>
	<cfset arguments.id = "/#arguments.id#">

	<cfreturn arguments.id>
</cffunction>


<cffunction name="FL_constructParams" returntype="any" access="private" output="false">
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
	<cfargument name="to" type="any" required="false" default="">
	<cfargument name="from" type="any" required="false" default="">
	<cfargument name="cc" type="any" required="false" default="">
	<cfargument name="bcc" type="any" required="false" default="">
	<cfargument name="subject" type="any" required="false" default="">
	<cfargument name="type" type="any" required="false" default="text">
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

	<cfmail subject="#arguments.subject#" to="#arguments.to#" from="#arguments.from#" cc="#arguments.cc#" bcc="#arguments.bcc#" type="#arguments.type#">
	#request.wheels.response#
	</cfmail>

	<!--- set to false so that Wheels does not think we have rendered an actual response to the browser --->
	<cfset request.wheels.response = false>

</cffunction>


<cffunction name="contentForLayout" returntype="any" access="public" output="false">
	<cfreturn request.wheels.response>
</cffunction>


<cffunction name="distanceOfTimeInWords" returntype="any" access="public" output="false">
	<cfargument name="from_time" type="any" required="true">
	<cfargument name="to_time" type="any" required="true">
	<cfargument name="include_seconds" type="any" required="false" default="false">
	<cfset var local = structNew()>

	<cfset local.minute_diff = dateDiff("n", arguments.from_time, arguments.to_time)>
	<cfset local.second_diff = dateDiff("s", arguments.from_time, arguments.to_time)>
	<cfset local.hours = 0>
	<cfset local.days = 0>
	<cfset local.output = "">

	<cfif local.minute_diff LT 1>
		<cfif arguments.include_seconds>
			<cfif local.second_diff LTE 5>
				<cfset local.output = "less than 5 seconds">
			<cfelseif local.second_diff LTE 10>
				<cfset local.output = "less than 10 seconds">
			<cfelseif local.second_diff LTE 20>
				<cfset local.output = "less than 20 seconds">
			<cfelseif local.second_diff LTE 40>
				<cfset local.output = "half a minute">
			<cfelse>
				<cfset local.output = "less than a minute">
			</cfif>
		<cfelse>
			<cfset local.output = "less than a minute">
		</cfif>
	<cfelseif local.minute_diff LT 2>
		<cfset local.output = "1 minute">
	<cfelseif local.minute_diff LTE 45>
		<cfset local.output = local.minute_diff & " minutes">
	<cfelseif local.minute_diff LTE 90>
		<cfset local.output = "about 1 hour">
	<cfelseif local.minute_diff LTE 1440>
		<cfset local.hours = ceiling(local.minute_diff/60)>
		<cfset local.output = "about #local.hours# hours">
	<cfelseif local.minute_diff LTE 2880>
		<cfset local.output = "1 day">
	<cfelse>
		<cfset local.days = int(local.minute_diff/60/24)>
		<cfset local.output = local.days & " days">
	</cfif>

	<cfreturn local.output>
</cffunction>


<cffunction name="timeAgoInWords" returntype="any" access="public" output="false">
	<cfargument name="from_time" type="any" required="true">
	<cfargument name="include_seconds" type="any" required="false" default="false">

	<cfset arguments.to_time = now()>

	<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
</cffunction>


<cffunction name="cycle" returntype="any" access="public" output="false">
	<cfargument name="values" type="any" required="true">
	<cfargument name="name" type="any" required="false" default="default">
	<cfset var local = structNew()>

	<cfif NOT isDefined("request.wheels.cycle.#arguments.name#")>
		<cfset "request.wheels.cycle.#arguments.name#" = listGetAt(arguments.values, 1)>
	<cfelse>
		<cfset local.found_at = listFindNoCase(arguments.values, request.wheels.cycle[arguments.name])>
		<cfif local.found_at IS listLen(arguments.values)>
			<cfset local.found_at = 0>
		</cfif>
		<cfset "request.wheels.cycle.#arguments.name#" = listGetAt(arguments.values, local.found_at + 1)>
	</cfif>

	<cfreturn request.wheels.cycle[arguments.name]>
</cffunction>


<cffunction name="truncate" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfargument name="length" type="any" required="true">
	<cfargument name="truncate_string" type="any" required="false" default="...">
	<cfset var local = structNew()>

	<cfif len(arguments.text) GT arguments.length>
		<cfset local.output = left(arguments.text, arguments.length-3) & arguments.truncate_string>
	<cfelse>
		<cfset local.output = arguments.text>
	</cfif>

	<cfreturn local.output>
</cffunction>


<cffunction name="simpleFormat" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfset var local = structNew()>

	<!--- Replace single newline characters with HTML break tags and double newline characters with HTML paragraph tags --->
	<cfset local.output = trim(arguments.text)>
	<cfset local.output = replace(local.output, "#chr(10)##chr(10)#", "</p><p>", "all")>
	<cfset local.output = replace(local.output, "#chr(10)#", "<br />", "all")>
	<cfif local.output IS NOT "">
		<cfset local.output = "<p>" & local.output & "</p>">
	</cfif>

	<cfreturn local.output>
</cffunction>


<cffunction name="autoLink" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfargument name="link" type="any" required="no" default="all">
	<cfargument name="attributes" type="any" required="no" default="">
	<cfset var local = structNew()>

	<cfset local.url_regex = "(?ix)([^(url=)|(href=)'""])(((https?)://([^:]+\:[^@]*@)?)([\d\w\-]+\.)?[\w\d\-\.]+\.(com|net|org|info|biz|tv|co\.uk|de|ro|it)(( / [\w\d\.\-@%\\\/:]* )+)?(\?[\w\d\?%,\.\/\##!@:=\+~_\-&amp;]*(?<![\.]))?)">
	<cfset local.mail_regex = "(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))">

	<cfif len(arguments.attributes) IS NOT 0>
		<!--- Add a space to the beginning so it can be directly inserted in the HTML link element below --->
		<cfset arguments.attributes = " " & arguments.attributes>
	</cfif>

	<cfset local.output = arguments.text>
	<cfif arguments.link IS NOT "urls">
		<!--- Auto link all email addresses --->
		<!--- <cfset local.output = REReplaceNoCase(local.output, "(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))", "<a href=""mailto:\1""#arguments.attributes#>\1</a>", "all")> --->
		<cfset local.output = REReplaceNoCase(local.output, local.mail_regex, "<a href=""mailto:\1""#arguments.attributes#>\1</a>", "all")>
	</cfif>
	<cfif arguments.link IS NOT "email_addresses">
		<!--- Auto link all URLs --->
		<!--- <cfset local.output = REReplaceNoCase(local.output, "(\b(?:https?|ftp)://(?:[a-z\d-]+\.)+[a-z]{2,6}(?:/\S*)?)", "<a href=""\1""#arguments.attributes#>\1</a>", "all")> --->
		<cfset local.output = local.output.ReplaceAll(local.url_regex, "$1<a href=""$2""#arguments.attributes#>$2</a>")>
	</cfif>

	<cfreturn local.output>
</cffunction>

<cffunction name="highlight" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfargument name="phrase" type="any" required="yes">
	<cfargument name="class" type="any" required="no" default="highlight">
	<cfreturn REReplaceNoCase(arguments.text, "(#arguments.phrase#)", "<span class=""#arguments.class#"">\1</span>", "all")>
</cffunction>


<cffunction name="stripTags" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfreturn REReplaceNoCase(arguments.text, "<[a-z].*?>(.*?)</[a-z]>", "\1" , "all")>
</cffunction>


<cffunction name="stripLinks" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfreturn REReplaceNoCase(arguments.text, "<a.*?>(.*?)</a>", "\1" , "all")>
</cffunction>


<cffunction name="excerpt" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfargument name="phrase" type="any" required="true">
	<cfargument name="radius" type="any" required="false" default="100">
	<cfargument name="excerpt_string" type="any" required="false" default="...">
	<cfset var local = structNew()>

	<cfset local.pos = findNoCase(arguments.phrase, arguments.text, 1)>
	<cfif local.pos IS NOT 0>
		<cfset local.excerpt_string_start = arguments.excerpt_string>
		<cfset local.excerpt_string_end = arguments.excerpt_string>
		<cfset local.start = local.pos-arguments.radius>
		<cfif local.start LTE 0>
			<cfset local.start = 1>
			<cfset local.excerpt_string_start = "">
		</cfif>
		<cfset local.count = len(arguments.phrase)+(arguments.radius*2)>
		<cfif local.count GT (len(arguments.text)-local.start)>
			<cfset local.excerpt_string_end = "">
		</cfif>
		<cfset local.output = local.excerpt_string_start & mid(arguments.text, local.start, local.count) & local.excerpt_string_end>
	<cfelse>
		<cfset local.output = "">
	</cfif>

	<cfreturn local.output>
</cffunction>


<cffunction name="paginationHasPrevious" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfif request.wheels[arguments.handle].current_page GT 1>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="paginationHasNext" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfif request.wheels[arguments.handle].current_page LT request.wheels[arguments.handle].total_pages>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="paginationTotalPages" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfreturn request.wheels[arguments.handle].total_pages>
</cffunction>


<cffunction name="paginationCurrentPage" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfreturn request.wheels[arguments.handle].current_page>
</cffunction>


<cffunction name="paginationLinks" returntype="any" access="public" output="false">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfargument name="name" type="any" required="false" default="page">
	<cfargument name="window_size" type="any" required="false" default=2>
	<cfargument name="always_show_anchors" type="any" required="false" default="true">
	<cfargument name="link_to_current_page" type="any" required="false" default="false">
	<cfargument name="prepend_to_link" type="any" required="false" default="">
	<cfargument name="append_to_link" type="any" required="false" default="">
	<cfargument name="class_for_current" type="any" required="false" default="">
	<cfargument name="params" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfset local.current_page = request.wheels[arguments.handle].current_page>
	<cfset local.total_pages = request.wheels[arguments.handle].total_pages>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfif arguments.always_show_anchors>
				<cfif (local.current_page - arguments.window_size) GT 1>
					<cfset local.link_to_arguments.params = "#arguments.name#=1">
					<cfif len(arguments.params) IS NOT 0>
						<cfset local.link_to_arguments.params = local.link_to_arguments.params & "&" & arguments.params>
					</cfif>
					<cfset local.link_to_arguments.text = 1>
					#linkTo(argumentCollection=local.link_to_arguments)# ...
				</cfif>
			</cfif>
			<cfloop from="1" to="#local.total_pages#" index="local.i">
				<cfif (local.i GTE (local.current_page - arguments.window_size) AND local.i LTE local.current_page) OR (local.i LTE (local.current_page + arguments.window_size) AND local.i GTE local.current_page)>
					<cfset local.link_to_arguments.params = "#arguments.name#=#local.i#">
					<cfif len(arguments.params) IS NOT 0>
						<cfset local.link_to_arguments.params = local.link_to_arguments.params & "&" & arguments.params>
					</cfif>
					<cfset local.link_to_arguments.text = local.i>
					<cfif len(arguments.class_for_current) IS NOT 0 AND local.current_page IS local.i>
						<cfset local.link_to_arguments.attributes = "class=#arguments.class_for_current#">
					<cfelse>
						<cfset local.link_to_arguments.attributes = "">
					</cfif>
					<cfif len(arguments.prepend_to_link) IS NOT 0>#arguments.prepend_to_link#</cfif><cfif local.current_page IS NOT local.i OR arguments.link_to_current_page>#linkTo(argumentCollection=local.link_to_arguments)#<cfelse><cfif len(arguments.class_for_current) IS NOT 0><span class="#arguments.class_for_current#">#local.i#</span><cfelse>#local.i#</cfif></cfif><cfif len(arguments.append_to_link) IS NOT 0>#arguments.append_to_link#</cfif>
				</cfif>
			</cfloop>
			<cfif arguments.always_show_anchors>
				<cfif local.total_pages GT (local.current_page + arguments.window_size)>
					<cfset local.link_to_arguments.params = "#arguments.name#=#local.total_pages#">
					<cfif len(arguments.params) IS NOT 0>
						<cfset local.link_to_arguments.params = local.link_to_arguments.params & "&" & arguments.params>
					</cfif>
					<cfset local.link_to_arguments.text = local.total_pages>
				... #linkTo(argumentCollection=local.link_to_arguments)#
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="FL_trimHTML" returntype="any" access="private" output="false">
	<cfargument name="str" type="any" required="true">
	<cfreturn replaceList(trim(arguments.str), "#chr(9)#,#chr(10)#,#chr(13)#", ",,")>
</cffunction>


<cffunction name="FL_getAttributes" returntype="any" access="private" output="false">
	<cfset var local = structNew()>

	<cfset local.attributes = "">
	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i Does Not Contain "_" AND listFindNoCase(arguments.FL_named_arguments, local.i) IS 0>
			<cfset local.attributes = "#local.attributes# #lCase(local.i)#=""#arguments[local.i]#""">
		</cfif>
	</cfloop>

	<cfreturn local.attributes>
</cffunction>

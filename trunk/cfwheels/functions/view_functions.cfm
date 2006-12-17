<cffunction name="stylesheetLinkTag" returntype="any" access="public" output="false">
	<cfargument name="file" type="any" required="yes">
	<cfargument name="media" type="any" required="no" default="all">

	<cfset var local = structNew()>
	
	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfloop list="#arguments.file#" index="local.i"><link rel="stylesheet" href="#application.pathTo.stylesheets#/#trim(local.i)#.css" type="text/css" media="#arguments.media#" /></cfloop>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="javascriptIncludeTag" returntype="any" access="public" output="false">
	<cfargument name="file" type="any" required="true">
	
	<cfset var local = structNew()>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfloop list="#arguments.file#" index="local.i"><script src="#application.pathTo.javascripts#/#trim(local.i)#.js" type="text/javascript"></script></cfloop>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="imageTag" returntype="any" access="public" output="false">
	<cfargument name="source" type="any" required="yes">
	<cfargument name="size" type="any" required="no" default="">
	<cfargument name="attributes" type="any" required="false" default="">
	
	<cfset var local = structNew()>

	<cfif left(arguments.source, 1) IS "/">
		<cfset local.src = arguments.source>
	<cfelse>
		<cfset local.src = "#application.pathTo.images#/#arguments.source#">
	</cfif>
	
	<cfif arguments.size IS NOT "">
		<cfset local.size_array = listToArray(arguments.size, "x")>
	</cfif>
	
	<cfsavecontent variable="local.output">
		<cfoutput>
			<img src="#local.src#"<cfif arguments.size IS NOT ""> width="#local.size_array[1]#" height="#local.size_array[2]#"</cfif> #arguments.attributes# />
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="mailTo" returntype="any" access="public" output="false">
	<cfargument name="email_address" type="any" required="yes">
	<cfargument name="encode" type="any" required="no" default="false">
	<cfargument name="attributes" type="any" required="no" default="">
	
	<cfset var local = structNew()>

	<cfset arguments.link = "mailto:#arguments.email_address#">
	<cfif NOT structKeyExists(arguments, "text")>
		<cfset arguments.text = arguments.email_address>	
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#linkTo(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfif arguments.encode>
		<cfset local.js = "document.write('#trim(local.output)#');">
		<cfset local.encoded = "">
		<cfloop from="1" to="#len(local.js)#" index="local.i">
			<cfset local.encoded = local.encoded & "%" & right("0" & formatBaseN(asc(mid(local.js,local.i,1)),16),2)>
		</cfloop>
		<cfset local.output = "<script type=""text/javascript"" language=""javascript"">eval(unescape('#local.encoded#'))</script>">
	</cfif>

	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="linkTo" returntype="any" access="public" output="false">
	<cfargument name="link" type="string" required="no" default="">
	<cfargument name="text" type="string" required="no" default="">
	<cfargument name="confirm" type="string" required="no" default="">
	<cfargument name="params" type="string" required="no" default="">
	<cfargument name="attributes" type="any" required="no" default="">

	<cfset var local = structNew()>
	
	<cfif arguments.link IS NOT "">
		<cfset local.href = arguments.link>
	<cfelse>
		<cfset local.href = urlFor(argumentCollection=arguments)>
	</cfif>
	
	<cfif arguments.text IS NOT "">
		<cfset local.link_text = arguments.text>
	<cfelse>
		<cfset local.link_text = local.href>	
	</cfif>
	
	<cfsavecontent variable="local.output">
		<cfoutput>	
			<a href="#local.href#"<cfif arguments.confirm IS NOT ""> onclick="return confirm('#JSStringFormat(arguments.confirm)#');"</cfif> #arguments.attributes#>#local.link_text#</a>
		</cfoutput>
	</cfsavecontent>

	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="linkToUnlessCurrent" returntype="any" access="public" output="false">

	<cfset var local = structNew()>
	
	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfif isCurrentPage(argumentCollection=arguments)>
				#arguments.text#
			<cfelse>
				#linkTo(argumentCollection=arguments)#
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="simpleFormat" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
		
	<cfset var local = structNew()>
	
	<cfsavecontent variable="local.output">
		<cfoutput>
			<p>#replace(replace(replace(replace(arguments.text, "#chr(13)##chr(10)##chr(13)##chr(10)#", "</p><p>", "all"), "#chr(13)##chr(10)#", "<br />", "all"), "#chr(10)##chr(10)#", "</p><p>", "all"), "#chr(10)#", "<br />", "all")#</p>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="truncate" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="yes">
	<cfargument name="length" type="any" required="yes">
	<cfargument name="truncate_string" type="any" required="no" default="...">

	<cfset var local = structNew()>
	
	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfif len(arguments.text) GT arguments.length>
				#left(arguments.text, (arguments.length-3))##arguments.truncate_string#
			<cfelse>
				#arguments.text#
			</cfif>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="paginationLinks" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="yes">
	<cfargument name="name" type="any" required="no" default="page">
	<cfargument name="window_size" type="any" required="no" default=2>
	<cfargument name="link_to_current_page" type="any" required="no" default="false">
	<cfargument name="prepend_to_link" type="any" required="no" default="">
	<cfargument name="append_to_link" type="any" required="no" default="">
	<cfargument name="class_for_current" type="any" required="no" default="">
	<cfargument name="always_show_anchors" type="any" required="no" default="true">

	<cfset var local = structNew()>

	<cfset local.this_object = evaluate("#arguments.object_name#")>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfif arguments.always_show_anchors>
				<cfif (local.this_object.paginator.current_page - arguments.window_size) GT 1>
					<cfset local.link_to_arguments.params = "#arguments.name#=1">
					<cfset local.link_to_arguments.text = local.i>
					#linkTo(argumentCollection=local.link_to_arguments)# ...
				</cfif>
			</cfif>
			<cfloop from="1" to="#local.this_object.paginator.total_pages#" index="local.i">
				<cfif (local.i GTE (local.this_object.paginator.current_page - arguments.window_size) AND local.i LTE local.this_object.paginator.current_page) OR (local.i LTE (local.this_object.paginator.current_page + arguments.window_size) AND local.i GTE local.this_object.paginator.current_page)>
					<cfset local.link_to_arguments.params = "#arguments.name#=#local.i#">
					<cfset local.link_to_arguments.text = local.i>
					<cfif arguments.class_for_current IS NOT "" AND local.this_object.paginator.current_page IS local.i>
						<cfset local.link_to_arguments.attributes = "class=#arguments.class_for_current#">
					<cfelse>
						<cfset local.link_to_arguments.attributes = "">
					</cfif>
					<cfif arguments.prepend_to_link IS NOT "">#arguments.prepend_to_link#</cfif><cfif local.this_object.paginator.current_page IS NOT local.i OR arguments.link_to_current_page>#linkTo(argumentCollection=local.link_to_arguments)#<cfelse><cfif arguments.class_for_current IS NOT ""><span class="#arguments.class_for_current#">#local.i#</span><cfelse>#local.i#</cfif></cfif><cfif arguments.append_to_link IS NOT "">#arguments.append_to_link#</cfif>
				</cfif>
			</cfloop>
			<cfif arguments.always_show_anchors>
				<cfif local.this_object.paginator.total_pages GT (local.this_object.paginator.current_page + arguments.window_size)>
					<cfset local.link_to_arguments.params = "#arguments.name#=#local.this_object.paginator.total_pages#">
					<cfset local.link_to_arguments.text = local.this_object.paginator.total_pages>
				... #linkTo(argumentCollection=local.link_to_arguments)#
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="isCurrentPage" returntype="any" access="private" output="false">
	<cfif replace(urlFor(argumentCollection=arguments), "/dispatch.cfm?wheelsaction=", "") IS request.currentrequest>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>


<cffunction name="URLFor" returntype="any" access="private" output="false">
	<cfargument name="controller" type="any" required="no" default="">
	<cfargument name="action" type="any" required="no" default="">
	<cfargument name="id" type="any" required="no" default=0>
	<cfargument name="anchor" type="any" required="no" default="">
	<cfargument name="only_path" type="any" required="no" default="true">
	<cfargument name="trailing_slash" type="any" required="no" default="false">
	<cfargument name="host" type="any" required="no" default="">
	<cfargument name="protocol" type="any" required="no" default="">
	<cfargument name="params" type="any" required="no" default="">
	
	<cfset var local = structNew()>

	<cfif arguments.controller IS NOT "">
		<cfset local.new_controller = arguments.controller>
	<cfelse>
		<cfset local.new_controller = request.params.controller>
	</cfif>

	<cfif arguments.action IS NOT "">
		<cfset local.new_action = arguments.action>
	<cfelse>
		<cfif local.new_controller IS request.params.controller>
			<!--- Keep the action only if controller stays the same --->
			<cfset local.new_action = request.params.action>
		</cfif>
	</cfif>

	<cfif arguments.id IS NOT 0>
		<cfset local.new_id = arguments.id>
	<cfelse>
		<cfif structKeyExists(request.params, "id") AND request.params.id IS NOT "" AND local.new_controller IS request.params.controller AND local.new_action IS request.params.action>
			<!--- Keep the ID only if controller and action stays the same --->
			<cfset local.new_id = request.params.id>
		</cfif>
	</cfif>

	<cfset local.url = "/#local.new_controller#/#local.new_action#">
	
	<cfif structKeyExists(local, "new_id") AND local.new_id IS NOT "">
		<cfset local.url = local.url & "/#local.new_id#">	
	</cfif>
	<cfif arguments.params IS NOT "">
		<cfif cgi.script_name Contains "dispatch.cfm">
			<!--- URL rewriting is not on so use "&" --->
			<cfset local.url = local.url & "&">
		<cfelse>
			<!--- URL rewriting is on so use "?" --->
			<cfset local.url = local.url & "?">
		</cfif>
		<cfset local.url = local.url & "#arguments.params#">
	</cfif>
	<cfif arguments.trailing_slash>
		<cfset local.url = local.url & "/">	
	</cfif>
	<cfif arguments.anchor IS NOT "">
		<cfset local.url = local.url & "###arguments.anchor#">
	</cfif>

	<cfif cgi.script_name Contains "dispatch.cfm">
		<cfset local.url = "/dispatch.cfm?wheelsaction=" & local.url>
	</cfif>

	<cfif NOT arguments.only_path>
		<cfif arguments.host IS NOT "">
			<cfset local.url = arguments.host & local.url>	
		<cfelse>
			<cfset local.url = cgi.server_name & local.url>	
		</cfif>
		<cfif arguments.protocol IS NOT "">
			<cfset local.url = arguments.protocol & "://" & local.url>	
		<cfelse>
			<cfset local.url = lCase(spanExcluding(cgi.server_protocol, "/")) & "://" & local.url>	
		</cfif>
	</cfif>

	<cfreturn local.url>
</cffunction>


<cffunction name="capitalize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	
	<cfreturn uCase(left(arguments.text,1)) & lCase(right(arguments.text,len(arguments.text)-1))>
</cffunction>


<cffunction name="distanceOfTimeInWords" returntype="any" access="public" output="false">
	<cfargument name="from_time" type="any" required="yes">
	<cfargument name="to_time" type="any" required="yes">
	<cfargument name="include_seconds" type="any" required="no" default="false">
	
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
		<cfset output = "about #local.hours# hours">
	<cfelseif local.minute_diff LTE 2880>
		<cfset local.output = "1 day">
	<cfelse>
		<cfset local.days = int(local.minute_diff/60/24)>
		<cfset local.output = local.days & " days">
	</cfif>

	<cfreturn local.output>
</cffunction>


<cffunction name="timeAgoInWords" returntype="any" access="public" output="false">
	<cfargument name="from_time" type="any" required="yes">
	<cfargument name="include_seconds" type="any" required="no" default="false">
	
	<cfset arguments.to_time = now()>
	
	<cfreturn distanceOfTimeInWords(argumentCollection=arguments)>
</cffunction>


<cffunction name="errorMessageOn" returntype="any" access="public" output="false">
	<cfargument name="object" type="any" required="yes">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="prepend_text" type="any" required="no" default="">
	<cfargument name="append_text" type="any" required="no" default="">
	<cfargument name="class" type="any" required="no" default="formError">
	<cfargument name="error_display" type="any" required="false" default="div">

	<cfset var output = "">
	<cfset var error = "">

	<cfset error = arguments.object.errorsOn(arguments.field)>
	<cfif NOT isBoolean(error)>
		<cfsavecontent variable="output">
			<cfoutput>
				<#arguments.error_display# class="#arguments.class#">#arguments.prepend_text##error[1]##arguments.append_text#</#arguments.error_display#>
			</cfoutput>
		</cfsavecontent>
	</cfif>
	
	<cfreturn output>
</cffunction>


<cffunction name="errorMessagesFor" returntype="any" access="public" output="false">
	<cfargument name="object" type="any" required="true">
	<cfargument name="header_tag" type="any" required="false" default="h2">
	<cfargument name="id" type="any" required="false" default="error_explanation">
	<cfargument name="class" type="any" required="false" default="error_explanation">
	<cfargument name="list_only" type="any" required="false" default="false">

	<cfset var output = "">
	<cfset var errors = arrayNew(1)>

	<cfif NOT arguments.object.errorsIsEmpty()>
		<cfset errors = arguments.object.errorsFullMessages()>
		<cfsavecontent variable="output">
			<cfoutput>
				<div id="#arguments.id#" class="#arguments.class#">
					<cfif NOT arguments.list_only>
						<#arguments.header_tag#>#arrayLen(errors)# error<cfif arrayLen(errors) GT 1>s</cfif> prevented this #arguments.object.getModelName()# from being saved</#arguments.header_tag#>
						<p>There were problems with the following fields:</p>
					</cfif>
					<ul>
						<cfloop from="1" to="#arrayLen(errors)#" index="i">
							<li>#errors[i]#</li>
						</cfloop>
					</ul>
				</div>
			</cfoutput>
		</cfsavecontent>
	</cfif>
	
	<cfreturn output>
</cffunction>


<cffunction name="startFormTag" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="no" default="">
	<cfargument name="name" type="any" required="no" default="form">
	<cfargument name="method" type="any" required="no" default="post">
	<cfargument name="multipart" type="any" required="no" default="false">
	<cfargument name="spam_protection" type="any" required="no" default="false">
	<cfargument name="attributes" type="any" required="no" default="">
	
	<cfset var local = structNew()>

	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfif arguments.link IS NOT "">
		<cfset local.url = arguments.link>
	<cfelse>
		<cfset local.url = URLFor(argumentCollection=arguments)>
	</cfif>

	<cfif arguments.spam_protection>
		<cfset local.onsubmit = "this.action='#left(local.url, int((len(local.url)/2)))#'+'#right(local.url, ceiling((len(local.url)/2)))#';">
		<cfset local.url = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<form name="#arguments.name#" id="#arguments.name#" action="#local.url#" method="#arguments.method#"<cfif arguments.multipart> enctype="multipart/form-data"</cfif><cfif structKeyExists(local, "onsubmit")> onsubmit="#local.onsubmit#"</cfif> #arguments.attributes#>
		</cfoutput>
	</cfsavecontent>	

	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="formRemoteTag" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="no" default="">
	<cfargument name="name" type="any" required="no" default="form">
	<cfargument name="method" type="any" required="no" default="post">
	<cfargument name="spam_protection" type="any" required="no" default="false">
	<cfargument name="attributes" type="any" required="no" default="">
	<!--- Ajax call specific stuff --->
	<cfargument name="update" type="any" required="no" default="">
	<cfargument name="insertion" type="any" required="no" default="">
	<cfargument name="serialize" type="any" required="no" default="false">
	<cfargument name="on_loading" type="any" required="no" default="">
	<cfargument name="on_complete" type="any" required="no" default="">
	<cfargument name="on_success" type="any" required="no" default="">
	<cfargument name="on_failure" type="any" required="no" default="">
	
	<cfset var local = structNew()>

	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfif arguments.link IS NOT "">
		<cfset local.url = arguments.link>
	<cfelse>
		<cfset local.url = URLFor(argumentCollection=arguments)>
	</cfif>
	
	<cfset local.ajax_call = "new Ajax.">
	
	<!--- Figure out the parameters for the Ajax call --->
	<cfif arguments.update IS NOT "">
		<cfset local.ajax_call = local.ajax_call & "Updater('#arguments.update#',">
	<cfelse>
		<cfset local.ajax_call = local.ajax_call & "Request(">
	</cfif>
	
	<cfset local.ajax_call = local.ajax_call & "'#local.url#', { asynchronous:true">
	
	<cfif arguments.insertion IS NOT "">
		<cfset local.ajax_call = local.ajax_call & ",insertion:Insertion.#arguments.insertion#">
	</cfif>
	
	<cfif arguments.serialize>
		<cfset local.ajax_call = local.ajax_call & ",parameters:Form.serialize(this)">
	</cfif>
	
	<cfif arguments.on_loading IS NOT "">
		<cfset local.ajax_call = local.ajax_call & ",onLoading:#arguments.on_loading#">
	</cfif>

	<cfif arguments.on_complete IS NOT "">
		<cfset local.ajax_call = local.ajax_call & ",onComplete:#arguments.on_complete#">
	</cfif>
	
	<cfif arguments.on_success IS NOT "">
		<cfset local.ajax_call = local.ajax_call & ",onSuccess:#arguments.on_success#">
	</cfif>
	
	<cfif arguments.on_failure IS NOT "">
		<cfset local.ajax_call = local.ajax_call & ",onFailure:#arguments.on_failure#">
	</cfif>
	
	<cfset local.ajax_call = local.ajax_call & "});">
	
	<cfif arguments.spam_protection>
		<cfset local.url = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<form name="#arguments.name#" id="#arguments.name#" action="#local.url#" method="#arguments.method#" onsubmit="#local.ajax_call# return false;" #arguments.attributes#>
		</cfoutput>
	</cfsavecontent>	
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="endFormTag" returntype="any" access="public" output="false">

	<cfreturn "</form>">
</cffunction>


<cffunction name="textField" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="yes">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="label_attributes" type="any" required="false" default="">

	<cfset var local = structNew()>

	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfset local.obj = evaluate(arguments.object_name)>
	<cfset local.error = NOT isBoolean(local.obj.errorsOn(arguments.field))>
	<cfif structKeyExists(local.obj, arguments.field)>
		<cfset local.value = local.obj[arguments.field]>
	<cfelse>
		<cfset local.value = "">
	</cfif>

	<cfif local.error>
		<cfif arguments.attributes Contains "class=">
			<cfset arguments.attributes = replace(arguments.attributes, "class=""", "class=""field_with_errors ")>
		<cfelse>
			<cfset arguments.attributes = "class='field_with_errors'">
		</cfif>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>			
			<label for="#listLast(arguments.object_name,".")#_#arguments.field#" #arguments.label_attributes#>#arguments.label#
			<input type="text" name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" value="#local.value#" #arguments.attributes# />
			</label>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="textFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="label_attributes" type="any" required="false" default="">

	<cfset var local = structNew()>
	
	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfif arguments.value IS NOT "">
		<cfset local.value = arguments.value>
	<cfelse>
		<cfset local.value = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<label for="#arguments.name#" #arguments.label_attributes#>#arguments.label#
			<input type="text" name="#arguments.name#" id="#arguments.name#" value="#local.value#" #arguments.attributes# />
			</label>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="passwordField" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="yes">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="label_attributes" type="any" required="false" default="">

	<cfset var local = structNew()>

	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfset local.obj = evaluate(arguments.object_name)>
	<cfset local.error = NOT isBoolean(local.obj.errorsOn(arguments.field))>
	<cfif structKeyExists(local.obj, arguments.field)>
		<cfset local.value = local.obj[arguments.field]>
	<cfelse>
		<cfset local.value = "">
	</cfif>

	<cfif local.error>
		<cfif arguments.attributes Contains "class=">
			<cfset arguments.attributes = replace(arguments.attributes, "class=""", "class=""field_with_errors ")>
		<cfelse>
			<cfset arguments.attributes = "class='field_with_errors'">
		</cfif>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>			
			<label for="#listLast(arguments.object_name,".")#_#arguments.field#" #arguments.label_attributes#>#arguments.label#
			<cfif local.error>
				<div class="field_with_errors">
			</cfif>
			<input type="password" name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" value="#local.value#" #arguments.attributes# />
			<cfif local.error>
				</div>
			</cfif>
			</label>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="passwordFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="label_attributes" type="any" required="false" default="">

	<cfset var local = structNew()>
	
	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfif arguments.value IS NOT "">
		<cfset local.value = arguments.value>
	<cfelse>
		<cfset local.value = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<label for="#arguments.name#" #arguments.label_attributes#>#arguments.label#
			<input type="password" name="#arguments.name#" id="#arguments.name#" value="#local.value#" #arguments.attributes# />
			</label>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="textArea" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="yes">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="label_attributes" type="any" required="false" default="">

	<cfset var local = structNew()>

	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfset local.obj = evaluate(arguments.object_name)>
	<cfset local.error = NOT isBoolean(local.obj.errorsOn(arguments.field))>
	<cfif structKeyExists(local.obj, arguments.field)>
		<cfset local.value = local.obj[arguments.field]>
	<cfelse>
		<cfset local.value = "">
	</cfif>

	<cfif local.error>
		<cfif arguments.attributes Contains "class=">
			<cfset arguments.attributes = replace(arguments.attributes, "class=""", "class=""field_with_errors ")>
		<cfelse>
			<cfset arguments.attributes = "class='field_with_errors'">
		</cfif>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>			
			<label for="#listLast(arguments.object_name,".")#_#arguments.field#" #arguments.label_attributes#>#arguments.label#
			<cfif local.error>
				<div class="field_with_errors">
			</cfif>
			<textarea name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" #arguments.attributes#>#local.value#</textarea>
			<cfif local.error>
				</div>
			</cfif>
			</label>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="textAreaTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="label_attributes" type="any" required="false" default="">

	<cfset var local = structNew()>
	
	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfif arguments.value IS NOT "">
		<cfset local.value = arguments.value>
	<cfelse>
		<cfset local.value = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<label for="#arguments.name#" #arguments.label_attributes#>#arguments.label#
			<textarea name="#arguments.name#" id="#arguments.name#" #arguments.attributes#>#local.value#</textarea>
			</label>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="hiddenField" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="yes">
	<cfargument name="field" type="any" required="yes">
	<cfargument name="attributes" type="any" required="false" default="">

	<cfset var local = structNew()>

	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfset local.obj = evaluate(arguments.object_name)>
	<cfif structKeyExists(local.obj, arguments.field)>
		<cfset local.value = local.obj[arguments.field]>
	<cfelse>
		<cfset local.value = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>			
			<input type="hidden" name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" value="#local.value#" #arguments.attributes# />
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="hiddenFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="attributes" type="any" required="false" default="">

	<cfset var local = structNew()>
	
	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfif arguments.value IS NOT "">
		<cfset local.value = arguments.value>
	<cfelse>
		<cfset local.value = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<input type="hidden" name="#arguments.name#" id="#arguments.name#" value="#local.value#" #arguments.attributes# />
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="fileFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="label_attributes" type="any" required="false" default="">

	<cfset var local = structNew()>
	
	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfif arguments.value IS NOT "">
		<cfset local.value = arguments.value>
	<cfelse>
		<cfset local.value = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<label for="#arguments.name#" #arguments.label_attributes#>#arguments.label#
			<input type="file" name="#arguments.name#" id="#arguments.name#" value="#local.value#" #arguments.attributes# />
			</label>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="submitTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="attributes" type="any" required="false" default="">
	<cfargument name="disable_with" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false" default="submit">

	<cfset var local = structNew()>

	<cfif arguments.attributes IS NOT "">
		<cfset arguments.attributes = replace(arguments.attributes, "'", """", "all")>
	</cfif>

	<cfif arguments.disable_with IS NOT "">
		<cfset local.onclick = "this.disabled=true;this.value='#arguments.disable_with#';this.form.submit();">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<input type="#arguments.type#" name="#arguments.name#" id="#arguments.name#" value="#local.value#"<cfif arguments.disable_with IS NOT ""> onclick="#local.onclick#"</cfif> #arguments.attributes# />
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn trimIt(local.output)>
</cffunction>


<cffunction name="trimIt" returntype="any" access="private" output="false">
	<cfargument name="str" type="any" required="yes">
	<cfreturn replaceList(trim(arguments.str), " >,#chr(9)#,#chr(10)#,#chr(13)#", ">,,")>
</cffunction>

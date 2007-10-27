<cffunction name="startFormTag" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="false" default="">
	<cfargument name="method" type="any" required="false" default="post">
	<cfargument name="multipart" type="any" required="false" default="false">
	<cfargument name="spam_protection" type="any" required="false" default="false">
	<cfargument name="with_token" type="any" required="false" default="false">
	<!--- Accepts URLFor arguments --->
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "link,method,multipart,spam_protection,with_token,controller,action,id,anchor,only_path,host,protocol,params">
	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<!--- Since a non-numeric id was passed in we assume it is meant as a HTML attribute and therefore remove it from the named arguments list so that it will be set in the attributes --->
		<cfset arguments.FL_named_arguments = listDeleteAt(arguments.FL_named_arguments, listFindNoCase(arguments.FL_named_arguments, "id"))>
	</cfif>
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>
	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<cfset structDelete(arguments, "id")>
	</cfif>

	<cfset request.wheels.current_form_method = arguments.method>

	<cfif len(arguments.link) IS NOT 0>
		<cfset local.url = arguments.link>
	<cfelse>
		<cfset local.url = URLFor(argumentCollection=arguments)>
	</cfif>
	<cfset local.url = HTMLEditFormat(local.url)>

	<cfif arguments.spam_protection>
		<cfset local.onsubmit = "this.action='#left(local.url, int((len(local.url)/2)))#'+'#right(local.url, ceiling((len(local.url)/2)))#';">
		<cfset local.url = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<form action="#local.url#" method="#arguments.method#"<cfif arguments.multipart> enctype="multipart/form-data"</cfif><cfif structKeyExists(local, "onsubmit")> onsubmit="#local.onsubmit#"</cfif>#local.attributes#>
			<cfif arguments.with_token>
				<cfset saveFormToken()>
				#hiddenFieldTag(name="token", value=getFormToken())#
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="formRemoteTag" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="false" default="">
	<cfargument name="method" type="any" required="false" default="post">
	<cfargument name="spam_protection" type="any" required="false" default="false">
	<cfargument name="with_token" type="any" required="false" default="false">
	<cfargument name="update" type="any" required="false" default="">
	<cfargument name="insertion" type="any" required="false" default="">
	<cfargument name="serialize" type="any" required="false" default="false">
	<cfargument name="on_loading" type="any" required="false" default="">
	<cfargument name="on_complete" type="any" required="false" default="">
	<cfargument name="on_success" type="any" required="false" default="">
	<cfargument name="on_failure" type="any" required="false" default="">
	<!--- Accepts URLFor arguments --->
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "link,method,spam_protection,with_token,update,insertion,serialize,on_loading,on_complete,on_success,on_failure,controller,action,id,anchor,only_path,host,protocol,params">
	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<!--- Since a non-numeric id was passed in we assume it is meant as a HTML attribute and therefore remove it from the named arguments list so that it will be set in the attributes --->
		<cfset arguments.FL_named_arguments = listDeleteAt(arguments.FL_named_arguments, listFindNoCase(arguments.FL_named_arguments, "id"))>
	</cfif>
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>
	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<cfset structDelete(arguments, "id")>
	</cfif>

	<cfif len(arguments.link) IS NOT 0>
		<cfset local.url = arguments.link>
	<cfelse>
		<cfset local.url = URLFor(argumentCollection=arguments)>
	</cfif>

	<cfset local.ajax_call = "new Ajax.">

	<!--- Figure out the parameters for the Ajax call --->
	<cfif len(arguments.update) IS NOT 0>
		<cfset local.ajax_call = local.ajax_call & "Updater('#arguments.update#',">
	<cfelse>
		<cfset local.ajax_call = local.ajax_call & "Request(">
	</cfif>

	<cfset local.ajax_call = local.ajax_call & "'#local.url#', { asynchronous:true">

	<cfif len(arguments.insertion) IS NOT 0>
		<cfset local.ajax_call = local.ajax_call & ",insertion:Insertion.#arguments.insertion#">
	</cfif>

	<cfif arguments.serialize>
		<cfset local.ajax_call = local.ajax_call & ",parameters:Form.serialize(this)">
	</cfif>

	<cfif len(arguments.on_loading) IS NOT 0>
		<cfset local.ajax_call = local.ajax_call & ",onLoading:#arguments.on_loading#">
	</cfif>

	<cfif len(arguments.on_complete) IS NOT 0>
		<cfset local.ajax_call = local.ajax_call & ",onComplete:#arguments.on_complete#">
	</cfif>

	<cfif len(arguments.on_success) IS NOT 0>
		<cfset local.ajax_call = local.ajax_call & ",onSuccess:#arguments.on_success#">
	</cfif>

	<cfif len(arguments.on_failure) IS NOT 0>
		<cfset local.ajax_call = local.ajax_call & ",onFailure:#arguments.on_failure#">
	</cfif>

	<cfset local.ajax_call = local.ajax_call & "});">

	<cfif arguments.spam_protection>
		<cfset local.url = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<form action="#local.url#" method="#arguments.method#" onsubmit="#local.ajax_call# return false;"#local.attributes#>
			<cfif arguments.with_token>
				<cfset saveFormToken()>
				#hiddenFieldTag(name="token", value=getFormToken())#
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="endFormTag" returntype="any" access="public" output="false">
	<cfif structKeyExists(request.wheels, "current_form_method")>
		<cfset structDelete(request.wheels, "current_form_method")>
	</cfif>
	<cfreturn "</form>">
</cffunction>


<cffunction name="submitTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="false" default="commit">
	<cfargument name="value" type="any" required="false" default="Save changes">
	<cfargument name="image" type="string" required="false" default="">
	<cfargument name="disable" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value,image,disable">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfif len(arguments.disable) IS NOT 0>
		<cfset local.onclick = "this.disabled=true;">
		<cfif len(arguments.image) IS 0 AND NOT isBoolean(arguments.disable)>
			<cfset local.onclick = local.onclick & "this.value='#arguments.disable#';">
		</cfif>
		<cfset local.onclick = local.onclick & "this.form.submit();">
	</cfif>

	<cfif len(arguments.image) IS NOT 0>
		<cfset local.source = "#application.wheels.web_path##application.settings.paths.images#/#arguments.image#">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<input name="#arguments.name#" id="#arguments.name#" value="#arguments.value#"<cfif len(arguments.image) IS 0> type="submit"<cfelse> type="image" src="#local.source#"</cfif><cfif len(arguments.disable) IS NOT 0> onclick="#local.onclick#"</cfif>#local.attributes# />
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>

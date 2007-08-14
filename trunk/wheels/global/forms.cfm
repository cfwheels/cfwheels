<cffunction name="errorMessagesFor" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfset var local = structNew()>
	<cfif NOT structKeyExists(arguments, "class")>
		<cfset arguments.class = "error-messages">
	</cfif>
	<cfset arguments.FL_named_arguments = "object_name">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfset local.object = evaluate(arguments.object_name)>
	<cfset local.errors = local.object.allErrors()>
	<cfset local.output = "">

	<cfif isArray(local.errors)>
		<cfsavecontent variable="local.output">
			<cfoutput>
				<ul#local.attributes#>
					<cfloop from="1" to="#arrayLen(local.errors)#" index="local.i">
						<li>#local.errors[local.i]#</li>
					</cfloop>
				</ul>
			</cfoutput>
		</cfsavecontent>
	</cfif>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="errorMessageOn" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfargument name="prepend_text" type="any" required="false" default="">
	<cfargument name="append_text" type="any" required="false" default="">
	<cfargument name="wrapper_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfif NOT structKeyExists(arguments, "class")>
		<cfset arguments.class = "error-message">
	</cfif>
	<cfset arguments.FL_named_arguments = "object_name,field,prepend_text,append_text,wrapper_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfset local.object = evaluate(arguments.object_name)>
	<cfset local.error = local.object.errorsOn(arguments.field)>
	<cfset local.output = "">

	<cfif NOT isBoolean(local.error)>
		<cfsavecontent variable="local.output">
			<cfoutput>
				<#arguments.wrapper_element##local.attributes#>#arguments.prepend_text##local.error[1]##arguments.append_text#</#arguments.wrapper_element#>
			</cfoutput>
		</cfsavecontent>
	</cfif>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


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
	<cfreturn "</form>">
</cffunction>


<cffunction name="textField" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "object_name,field,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<input type="text" name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" value="#FL_formValue(argumentCollection=arguments)#"#local.attributes# />
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="textFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<input name="#arguments.name#" id="#arguments.name#" type="text" value="#FL_formValue(argumentCollection=arguments)#"#local.attributes# />
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="radioButton" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfargument name="tag_value" type="any" required="true">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "object_name,field,tag_value,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<input type="radio" name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" value="#arguments.tag_value#"<cfif arguments.tag_value IS FL_formValue(argumentCollection=arguments)> checked="checked"</cfif>#local.attributes# />
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="radioButtonTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="checked" type="any" required="false" default="false">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value,checked,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<input name="#arguments.name#" id="#arguments.name#" type="radio" value="#FL_formValue(argumentCollection=arguments)#"<cfif arguments.checked> checked="checked"</cfif>#local.attributes# />
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="checkBox" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfargument name="checked_value" type="any" required="false" default="1">
	<cfargument name="unchecked_value" type="any" required="false" default="0">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "object_name,field,checked_value,unchecked_value,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfset local.value = FL_formValue(argumentCollection=arguments)>
	<cfif (isBoolean(local.value) AND local.value) OR (isNumeric(local.value) AND local.value GTE 1)>
		<cfset local.checked = true>
	<cfelse>
		<cfset local.checked = false>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<input type="checkbox" name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" value="#arguments.checked_value#"<cfif local.checked> checked="checked"</cfif>#local.attributes# />
	    <input name="#listLast(arguments.object_name,".")#[#arguments.field#]" type="hidden" value="#arguments.unchecked_value#" />
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="checkBoxTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="1">
	<cfargument name="checked" type="any" required="false" default="false">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value,checked,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<input name="#arguments.name#" id="#arguments.name#" type="checkbox" value="#arguments.value#"<cfif arguments.checked> checked="checked"</cfif>#local.attributes# />
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="passwordField" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "object_name,field,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<input type="password" name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" value="#FL_formValue(argumentCollection=arguments)#"#local.attributes# />
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="passwordFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<input name="#arguments.name#" id="#arguments.name#" type="password" value="#FL_formValue(argumentCollection=arguments)#"#local.attributes# />
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="hiddenField" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "object_name,field">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<input type="hidden" name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" value="#FL_formValue(argumentCollection=arguments)#"#local.attributes# />
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="hiddenFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<input name="#arguments.name#" id="#arguments.name#" type="hidden" value="#FL_formValue(argumentCollection=arguments)#"#local.attributes# />
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="textArea" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "object_name,field,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfset local.output = "">
	<cfset local.output = local.output & FL_formBeforeElement(argumentCollection=arguments)>
	<cfset local.output = local.output & "<textarea name=""#listLast(arguments.object_name, '.')#[#arguments.field#]"" id=""#listLast(arguments.object_name, '.')#_#arguments.field#""#local.attributes#>">
	<cfset local.output = local.output & FL_formValue(argumentCollection=arguments)>
	<cfset local.output = local.output & "</textarea>">
	<cfset local.output = local.output & FL_formAfterElement(argumentCollection=arguments)>

	<cfreturn local.output>
</cffunction>


<cffunction name="textAreaTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfset local.output = "">
	<cfset local.output = local.output & FL_formBeforeElement(argumentCollection=arguments)>
	<cfset local.output = local.output & "<textarea name=""#arguments.name#"" id=""#arguments.name#""#local.attributes#>">
	<cfset local.output = local.output & FL_formValue(argumentCollection=arguments)>
	<cfset local.output = local.output & "</textarea>">
	<cfset local.output = local.output & FL_formAfterElement(argumentCollection=arguments)>

	<cfreturn local.output>
</cffunction>


<cffunction name="fileField" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "object_name,field,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<input type="file" name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" value=""#local.attributes# />
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="fileFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<input type="file" name="#arguments.name#" id="#arguments.name#" value="#FL_formValue(argumentCollection=arguments)#"#local.attributes# />
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
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
		<cfset local.source = "#application.wheels.web_path#images/#arguments.image#">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<input name="#arguments.name#" id="#arguments.name#" value="#arguments.value#"<cfif len(arguments.image) IS 0> type="submit"<cfelse> type="image" src="#local.source#"</cfif><cfif len(arguments.disable) IS NOT 0> onclick="#local.onclick#"</cfif>#local.attributes# />
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="select" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfargument name="options" type="any" required="true">
	<cfargument name="include_blank" type="any" required="false" default="false">
	<cfargument name="multiple" type="any" required="false" default="false">
	<cfargument name="value_field" type="any" required="false" default="id">
	<cfargument name="text_field" type="any" required="false" default="name">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "object_name,field,options,include_blank,multiple,value_field,text_field,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfset local.output = "">
	<cfset local.output = local.output & FL_formBeforeElement(argumentCollection=arguments)>
	<cfset local.output = local.output & "<select name=""#listLast(arguments.object_name,'.')#[#arguments.field#]"" id=""#listLast(arguments.object_name,'.')#_#arguments.field#"">">
	<cfif arguments.multiple>
		<cfset local.output = local.output & " multiple">
	</cfif>
	<cfset local.output = local.output & local.attributes>
	<cfif NOT isBoolean(arguments.include_blank) OR arguments.include_blank>
		<cfif NOT isBoolean(arguments.include_blank)>
			<cfset local.text = arguments.include_blank>
		<cfelse>
			<cfset local.text = "">
		</cfif>
		<cfset local.output = local.output & "<option value="""">#local.text#</option>">
	</cfif>
	<cfset local.output = local.output & FL_optionsForSelect(argumentCollection=arguments)>
	<cfset local.output = local.output & "</select>">
	<cfset local.output = local.output & FL_formAfterElement(argumentCollection=arguments)>

	<cfreturn local.output>
</cffunction>


<cffunction name="selectTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="options" type="any" required="true">
	<cfargument name="include_blank" type="any" required="false" default="false">
	<cfargument name="multiple" type="any" required="false" default="false">
	<cfargument name="value_field" type="any" required="false" default="id">
	<cfargument name="text_field" type="any" required="false" default="name">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value,options,include_blank,multiple,value_field,text_field,label,wrap_label,prepend,append,prepend_to_label,append_to_label,error_element">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#FL_formBeforeElement(argumentCollection=arguments)#
			<select name="#arguments.name#" id="#arguments.name#"<cfif arguments.multiple> multiple</cfif>#local.attributes#>
			<cfif NOT isBoolean(arguments.include_blank) OR arguments.include_blank>
				<cfif NOT isBoolean(arguments.include_blank)>
					<cfset local.text = arguments.include_blank>
				<cfelse>
					<cfset local.text = "">
				</cfif>
				<option value="">#local.text#</option>
			</cfif>
			#FL_optionsForSelect(argumentCollection=arguments)#
			</select>
			#FL_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="FL_optionsForSelect" returntype="any" access="private" output="false">
	<cfargument name="options" type="any" required="true">
	<cfargument name="value_field" type="any" required="false" default="id">
	<cfargument name="text_field" type="any" required="false" default="name">
	<cfset var local = structNew()>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfif isQuery(arguments.options)>
				<cfloop query="arguments.options">
					<option value="#arguments.options[arguments.value_field][currentrow]#"<cfif listFindNoCase(FL_formValue(argumentCollection=arguments), arguments.options[arguments.value_field][currentrow]) IS NOT 0> selected="selected"</cfif>>#arguments.options[arguments.text_field][currentrow]#</option>
				</cfloop>
			<cfelseif isStruct(arguments.options)>
				<cfloop collection="#arguments.options#" item="local.i">
					<option value="#local.i#"<cfif listFindNoCase(FL_formValue(argumentCollection=arguments), local.i) IS NOT 0> selected="selected"</cfif>>#arguments.options[local.i]#</option>
				</cfloop>
			<cfelseif isArray(arguments.options)>
				<cfloop from="1" to="#arrayLen(arguments.options)#" index="local.i">
					<option value="#local.i#"<cfif listFindNoCase(FL_formValue(argumentCollection=arguments), local.i) IS NOT 0> selected="selected"</cfif>>#arguments.options[local.i]#</option>
				</cfloop>
			<cfelse>
				<cfloop list="#arguments.options#" index="local.i">
					<option value="#local.i#"<cfif listFindNoCase(FL_formValue(argumentCollection=arguments), local.i) IS NOT 0> selected="selected"</cfif>>#local.i#</option>
				</cfloop>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
</cffunction>


<cffunction name="FL_formValue" returntype="any" access="private" output="false">
	<cfargument name="object_name" type="any" required="false" default="">
	<cfargument name="field" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfif len(arguments.object_name) IS NOT 0>
		<!--- this is a form field for a model object --->
		<cfset local.object = evaluate(arguments.object_name)>
		<cfif structKeyExists(local.object, arguments.field)>
			<cfset local.value = local.object[arguments.field]>
		<cfelse>
			<cfset local.value = "">
		</cfif>
	<cfelse>
		<cfset local.value = arguments.value>
	</cfif>

	<cfreturn local.value>
</cffunction>


<cffunction name="FL_formHasError" returntype="any" access="private" output="false">
	<cfargument name="object_name" type="any" required="false" default="">
	<cfargument name="field" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfif len(arguments.object_name) IS NOT 0>
		<!--- this is a form field for a model object --->
		<cfset local.object = evaluate(arguments.object_name)>
		<cfset local.error = NOT isBoolean(local.object.errorsOn(arguments.field))>
	<cfelse>
		<cfset local.error = false>
	</cfif>

	<cfreturn local.error>
</cffunction>


<cffunction name="FL_formBeforeElement" returntype="any" access="private" output="false">
	<cfargument name="object_name" type="any" required="false" default="">
	<cfargument name="field" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>

	<cfset local.output = "">
	<cfif FL_formHasError(argumentCollection=arguments)>
		<cfset local.output = local.output & "<#arguments.error_element# class=""field-with-errors"">">
	</cfif>

	<cfif len(arguments.label) IS NOT 0>
		<cfset local.output = local.output & arguments.prepend_to_label>
		<cfset local.output = local.output & "<label for=""#listLast(arguments.object_name,'.')#_#arguments.field#""">
		<cfloop collection="#arguments#" item="local.i">
			<cfif left(local.i, 6) IS "label_">
				<cfset local.output = local.output & " #replace(local.i, 'label_', '')#=""#arguments[local.i]#""">
			</cfif>
		</cfloop>
		<cfset local.output = local.output & ">" & arguments.label>
		<cfif NOT arguments.wrap_label>
			<cfset local.output = local.output & "</label>" & arguments.append_to_label>
		</cfif>
	</cfif>
	<cfset local.output = local.output & arguments.prepend>

	<cfreturn local.output>
</cffunction>


<cffunction name="FL_formAfterElement" returntype="any" access="private" output="false">
	<cfargument name="object_name" type="any" required="false" default="">
	<cfargument name="field" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrap_label" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prepend_to_label" type="any" required="false" default="">
	<cfargument name="append_to_label" type="any" required="false" default="">
	<cfargument name="error_element" type="any" required="false" default="div">
	<cfset var local = structNew()>

	<cfset local.output = "">
	<cfset local.output = local.output & arguments.append>
	<cfif len(arguments.label) IS NOT 0>
		<cfif arguments.wrap_label>
			<cfset local.output = local.output & "</label>">
			<cfset local.output = local.output & arguments.append_to_label>
		</cfif>
	</cfif>
	<cfif FL_formHasError(argumentCollection=arguments)>
		<cfset local.output = local.output & "</#arguments.error_element#>">
	</cfif>

	<cfreturn local.output>
</cffunction>
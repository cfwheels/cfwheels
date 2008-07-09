<cffunction name="startFormTag" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="false" default="">
	<cfargument name="method" type="any" required="false" default="post">
	<cfargument name="multipart" type="any" required="false" default="false">
	<cfargument name="spamProtection" type="any" required="false" default="false">
	<!--- Accepts URLFor arguments --->
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "link,method,multipart,spamProtection,controller,action,id,anchor,only_path,host,protocol,params">
	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<!--- Since a non-numeric id was passed in we assume it is meant as a HTML attribute and therefore remove it from the named arguments list so that it will be set in the attributes --->
		<cfset arguments._named_arguments = listDeleteAt(arguments._named_arguments, listFindNoCase(arguments._named_arguments, "id"))>
	</cfif>
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>
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

	<cfif arguments.spamProtection>
		<cfset local.onsubmit = "this.action='#left(local.url, int((len(local.url)/2)))#'+'#right(local.url, ceiling((len(local.url)/2)))#';">
		<cfset local.url = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<form action="#local.url#" method="#arguments.method#"<cfif arguments.multipart> enctype="multipart/form-data"</cfif><cfif structKeyExists(local, "onsubmit")> onsubmit="#local.onsubmit#"</cfif>#local.attributes#>
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="formRemoteTag" returntype="any" access="public" output="false">
	<cfargument name="link" type="any" required="false" default="">
	<cfargument name="method" type="any" required="false" default="post">
	<cfargument name="spamProtection" type="any" required="false" default="false">
	<cfargument name="update" type="any" required="false" default="">
	<cfargument name="insertion" type="any" required="false" default="">
	<cfargument name="serialize" type="any" required="false" default="false">
	<cfargument name="onLoading" type="any" required="false" default="">
	<cfargument name="onComplete" type="any" required="false" default="">
	<cfargument name="onSuccess" type="any" required="false" default="">
	<cfargument name="onFailure" type="any" required="false" default="">
	<!--- Accepts URLFor arguments --->
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "link,method,spamProtection,update,insertion,serialize,onLoading,onComplete,onSuccess,onFailure,controller,action,id,anchor,only_path,host,protocol,params">
	<cfif structKeyExists(arguments, "id") AND NOT isNumeric(arguments.id)>
		<!--- Since a non-numeric id was passed in we assume it is meant as a HTML attribute and therefore remove it from the named arguments list so that it will be set in the attributes --->
		<cfset arguments._named_arguments = listDeleteAt(arguments._named_arguments, listFindNoCase(arguments._named_arguments, "id"))>
	</cfif>
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>
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

	<cfif len(arguments.onLoading) IS NOT 0>
		<cfset local.ajax_call = local.ajax_call & ",onLoading:#arguments.onLoading#">
	</cfif>

	<cfif len(arguments.onComplete) IS NOT 0>
		<cfset local.ajax_call = local.ajax_call & ",onComplete:#arguments.onComplete#">
	</cfif>

	<cfif len(arguments.onSuccess) IS NOT 0>
		<cfset local.ajax_call = local.ajax_call & ",onSuccess:#arguments.onSuccess#">
	</cfif>

	<cfif len(arguments.onFailure) IS NOT 0>
		<cfset local.ajax_call = local.ajax_call & ",onFailure:#arguments.onFailure#">
	</cfif>

	<cfset local.ajax_call = local.ajax_call & "});">

	<cfif arguments.spamProtection>
		<cfset local.url = "">
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<form action="#local.url#" method="#arguments.method#" onsubmit="#local.ajax_call# return false;"#local.attributes#>
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="endFormTag" returntype="any" access="public" output="false">
	<cfif structKeyExists(request.wheels, "current_form_method")>
		<cfset structDelete(request.wheels, "current_form_method")>
	</cfif>
	<cfreturn "</form>">
</cffunction>

<cffunction name="submitTag" returntype="any" access="public" output="false">
	<cfargument name="value" type="any" required="false" default="Save changes">
	<cfargument name="image" type="string" required="false" default="">
	<cfargument name="disable" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "value,image,disable">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

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
			<input value="#arguments.value#"<cfif len(arguments.image) IS 0> type="submit"<cfelse> type="image" src="#local.source#"</cfif><cfif len(arguments.disable) IS NOT 0> onclick="#local.onclick#"</cfif>#local.attributes# />
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="textField" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="any" required="true">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<input type="text" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#_#arguments.property#" value="#HTMLEditFormat(_formValue(argumentCollection=arguments))#"#local.attributes# />
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="radioButton" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="any" required="true">
	<cfargument name="tagValue" type="any" required="true">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "objectName,property,tagValue,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<input type="radio" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#_#arguments.property#" value="#arguments.tagValue#"<cfif arguments.tagValue IS _formValue(argumentCollection=arguments)> checked="checked"</cfif>#local.attributes# />
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="checkBox" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="any" required="true">
	<cfargument name="checkedValue" type="any" required="false" default="1">
	<cfargument name="uncheckedValue" type="any" required="false" default="0">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "objectName,property,checkedValue,uncheckedValue,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset local.value = _formValue(argumentCollection=arguments)>
	<cfif (isBoolean(local.value) AND local.value) OR (isNumeric(local.value) AND local.value GTE 1)>
		<cfset local.checked = true>
	<cfelse>
		<cfset local.checked = false>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<input type="checkbox" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#_#arguments.property#" value="#arguments.checkedValue#"<cfif local.checked> checked="checked"</cfif>#local.attributes# />
	    <input name="#listLast(arguments.objectName,".")#[#arguments.property#]" type="hidden" value="#arguments.uncheckedValue#" />
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="passwordField" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="any" required="true">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<input type="password" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#_#arguments.property#" value="#HTMLEditFormat(_formValue(argumentCollection=arguments))#"#local.attributes# />
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="hiddenField" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="any" required="true">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "objectName,property">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset local.value = _formValue(argumentCollection=arguments)>
	<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
		<cfset local.value = obfuscateParam(local.value)>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<input type="hidden" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#_#arguments.property#" value="#HTMLEditFormat(local.value)#"#local.attributes# />
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="textArea" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="any" required="true">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset local.output = "">
	<cfset local.output = local.output & _formBeforeElement(argumentCollection=arguments)>
	<cfset local.output = local.output & "<textarea name=""#listLast(arguments.objectName, '.')#[#arguments.property#]"" id=""#listLast(arguments.objectName, '.')#_#arguments.property#""#local.attributes#>">
	<cfset local.output = local.output & _formValue(argumentCollection=arguments)>
	<cfset local.output = local.output & "</textarea>">
	<cfset local.output = local.output & _formAfterElement(argumentCollection=arguments)>

	<cfreturn local.output>
</cffunction>

<cffunction name="fileField" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="any" required="true">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "objectName,property,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<input type="file" name="#listLast(arguments.objectName,".")#[#arguments.property#]" id="#listLast(arguments.objectName,".")#_#arguments.property#" value=""#local.attributes# />
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="select" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="any" required="true">
	<cfargument name="options" type="any" required="true">
	<cfargument name="includeBlank" type="any" required="false" default="false">
	<cfargument name="multiple" type="any" required="false" default="false">
	<cfargument name="valueField" type="any" required="false" default="id">
	<cfargument name="textField" type="any" required="false" default="name">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "objectName,property,options,includeBlank,multiple,valueField,textField,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,errorElement">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset local.output = "">
	<cfset local.output = local.output & _formBeforeElement(argumentCollection=arguments)>
	<cfset local.output = local.output & "<select name=""#listLast(arguments.objectName,'.')#[#arguments.property#]"" id=""#listLast(arguments.objectName,'.')#_#arguments.property#"">">
	<cfif arguments.multiple>
		<cfset local.output = local.output & " multiple">
	</cfif>
	<cfset local.output = local.output & local.attributes>
	<cfif NOT isBoolean(arguments.includeBlank) OR arguments.includeBlank>
		<cfif NOT isBoolean(arguments.includeBlank)>
			<cfset local.text = arguments.includeBlank>
		<cfelse>
			<cfset local.text = "">
		</cfif>
		<cfset local.output = local.output & "<option value="""">#local.text#</option>">
	</cfif>
	<cfset local.output = local.output & _optionsForSelect(argumentCollection=arguments)>
	<cfset local.output = local.output & "</select>">
	<cfset local.output = local.output & _formAfterElement(argumentCollection=arguments)>

	<cfreturn local.output>
</cffunction>

<cffunction name="textFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<input name="#arguments.name#" id="#arguments.name#" type="text" value="#HTMLEditFormat(_formValue(argumentCollection=arguments))#"#local.attributes# />
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="radioButtonTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="checked" type="any" required="false" default="false">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "name,value,checked,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<input name="#arguments.name#" id="#arguments.name#" type="radio" value="#_formValue(argumentCollection=arguments)#"<cfif arguments.checked> checked="checked"</cfif>#local.attributes# />
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="checkBoxTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="1">
	<cfargument name="checked" type="any" required="false" default="false">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "name,value,checked,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<input name="#arguments.name#" id="#arguments.name#" type="checkbox" value="#arguments.value#"<cfif arguments.checked> checked="checked"</cfif>#local.attributes# />
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="passwordFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<input name="#arguments.name#" id="#arguments.name#" type="password" value="#HTMLEditFormat(_formValue(argumentCollection=arguments))#"#local.attributes# />
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="hiddenFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "name,value">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset local.value = _formValue(argumentCollection=arguments)>
	<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
		<cfset local.value = obfuscateParam(local.value)>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<input name="#arguments.name#" id="#arguments.name#" type="hidden" value="#HTMLEditFormat(local.value)#"#local.attributes# />
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="textAreaTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset local.output = "">
	<cfset local.output = local.output & _formBeforeElement(argumentCollection=arguments)>
	<cfset local.output = local.output & "<textarea name=""#arguments.name#"" id=""#arguments.name#""#local.attributes#>">
	<cfset local.output = local.output & _formValue(argumentCollection=arguments)>
	<cfset local.output = local.output & "</textarea>">
	<cfset local.output = local.output & _formAfterElement(argumentCollection=arguments)>

	<cfreturn local.output>
</cffunction>

<cffunction name="fileFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "name,value,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<input type="file" name="#arguments.name#" id="#arguments.name#" value="#HTMLEditFormat(_formValue(argumentCollection=arguments))#"#local.attributes# />
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="selectTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="options" type="any" required="true">
	<cfargument name="includeBlank" type="any" required="false" default="false">
	<cfargument name="multiple" type="any" required="false" default="false">
	<cfargument name="valueField" type="any" required="false" default="id">
	<cfargument name="textField" type="any" required="false" default="name">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "name,value,options,includeBlank,multiple,valueField,textField,label,wrapLabel,prepend,append,prependToLabel,appendToLabel">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfsavecontent variable="local.output">
		<cfoutput>
			#_formBeforeElement(argumentCollection=arguments)#
			<select name="#arguments.name#" id="#arguments.name#"<cfif arguments.multiple> multiple</cfif>#local.attributes#>
			<cfif NOT isBoolean(arguments.includeBlank) OR arguments.includeBlank>
				<cfif NOT isBoolean(arguments.includeBlank)>
					<cfset local.text = arguments.includeBlank>
				<cfelse>
					<cfset local.text = "">
				</cfif>
				<option value="">#local.text#</option>
			</cfif>
			#_optionsForSelect(argumentCollection=arguments)#
			</select>
			#_formAfterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(local.output)>
</cffunction>

<cffunction name="yearSelectTag" returntype="any" access="public" output="false">
	<cfargument name="startYear" type="any" required="false" default="#year(now())-5#">
	<cfargument name="endYear" type="any" required="false" default="#year(now())+5#">
	<cfset arguments._loop_from = arguments.startYear>
	<cfset arguments._loop_to = arguments.endYear>
	<cfset arguments._type = "year">
	<cfset arguments._step = 1>
	<cfset structDelete(arguments, "startYear")>
	<cfset structDelete(arguments, "endYear")>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="monthSelectTag" returntype="any" access="public" output="false">
	<cfargument name="monthDisplay" type="any" required="false" default="names">
	<cfset arguments._loop_from = 1>
	<cfset arguments._loop_to = 12>
	<cfset arguments._type = "month">
	<cfset arguments._step = 1>
	<cfif arguments.monthDisplay IS "abbreviations">
		<cfset arguments._option_names = "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec">
	<cfelseif arguments.monthDisplay IS "names">
		<cfset arguments._option_names = "January,February,March,April,May,June,July,August,September,October,November,December">
	</cfif>
	<cfset structDelete(arguments, "monthDisplay")>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="daySelectTag" returntype="any" access="public" output="false">
	<cfset arguments._loop_from = 1>
	<cfset arguments._loop_to = 31>
	<cfset arguments._type = "day">
	<cfset arguments._step = 1>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="hourSelectTag" returntype="any" access="public" output="false">
	<cfset arguments._loop_from = 0>
	<cfset arguments._loop_to = 23>
	<cfset arguments._type = "hour">
	<cfset arguments._step = 1>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="minuteSelectTag" returntype="any" access="public" output="false">
	<cfargument name="minuteStep" type="any" required="false" default="1">
	<cfset arguments._loop_from = 0>
	<cfset arguments._loop_to = 59>
	<cfset arguments._type = "minute">
	<cfset arguments._step = arguments.minuteStep>
	<cfset structDelete(arguments, "minuteStep")>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="secondSelectTag" returntype="any" access="public" output="false">
	<cfset arguments._loop_from = 0>
	<cfset arguments._loop_to = 59>
	<cfset arguments._type = "second">
	<cfset arguments._step = 1>
	<cfreturn $yearMonthHourMinuteSecondSelectTag(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateTimeSelect" returntype="any" access="public" output="false">
	<cfset arguments._function_name = "dateTimeSelect">
	<cfreturn $dateTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateTimeSelectTag" returntype="any" access="public" output="false">
	<cfset arguments._function_name = "dateTimeSelectTag">
	<cfreturn $dateTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateSelect" returntype="any" access="public" output="false">
	<cfargument name="order" type="any" required="false" default="month,day,year">
	<cfargument name="separator" type="any" required="false" default=" ">
	<cfset arguments._function_name = "dateSelect">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="dateSelectTag" returntype="any" access="public" output="false">
	<cfargument name="order" type="any" required="false" default="month,day,year">
	<cfargument name="separator" type="any" required="false" default=" ">
	<cfset arguments._function_name = "dateSelectTag">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeSelect" returntype="any" access="public" output="false">
	<cfargument name="order" type="any" required="false" default="hour,minute,second">
	<cfargument name="separator" type="any" required="false" default=":">
	<cfset arguments._function_name = "timeSelect">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="timeSelectTag" returntype="any" access="public" output="false">
	<cfargument name="order" type="any" required="false" default="hour,minute,second">
	<cfargument name="separator" type="any" required="false" default=":">
	<cfset arguments._function_name = "timeSelectTag">
	<cfreturn $dateOrTimeSelect(argumentCollection=arguments)>
</cffunction>

<cffunction name="$dateTimeSelect" returntype="any" access="public" output="false">
	<cfargument name="date_order" type="any" required="false" default="month,day,year">
	<cfargument name="time_order" type="any" required="false" default="hour,minute,second">
	<cfargument name="date_separator" type="any" required="false" default=" ">
	<cfargument name="time_separator" type="any" required="false" default=":">
	<cfargument name="separator" type="any" required="false" default=" - ">
	<cfargument name="_function_name" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.html = "">
	<cfset local.separator = arguments.separator>

	<cfset arguments.order = arguments.date_order>
	<cfset arguments.separator = arguments.date_separator>
	<cfif arguments._function_name IS "dateTimeSelect">
		<cfset local.html = local.html & dateSelect(argumentCollection=arguments)>
	<cfelseif  arguments._function_name IS "dateTimeSelectTag">
		<cfset local.html = local.html & dateSelectTag(argumentCollection=arguments)>
	</cfif>
	<cfset local.html = local.html & local.separator>
	<cfset arguments.order = arguments.time_order>
	<cfset arguments.separator = arguments.time_separator>
	<cfif arguments._function_name IS "dateTimeSelect">
		<cfset local.html = local.html & timeSelect(argumentCollection=arguments)>
	<cfelseif  arguments._function_name IS "dateTimeSelectTag">
		<cfset local.html = local.html & timeSelectTag(argumentCollection=arguments)>
	</cfif>

	<cfreturn local.html>
</cffunction>

<cffunction name="$dateOrTimeSelect" returntype="any" access="private" output="false">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="_function_name" type="any" required="true">
	<cfset var local = structNew()>

	<cfif len(arguments.objectName) IS NOT 0>
		<cfset local.name = "#listLast(arguments.objectName,".")#[#arguments.property#]">
		<cfset arguments._id = "#listLast(arguments.objectName,".")#_#arguments.property#">
		<cfset local.value = _formValue(argumentCollection=arguments)>
	<cfelse>
		<cfset local.name = arguments.name>
		<cfset arguments._id = arguments.name>
		<cfset local.value = arguments.value>
	</cfif>

	<cfset local.html = "">
	<cfset local.first_done = false>
	<cfloop list="#arguments.order#" index="local.i">
		<cfset arguments.name = local.name & "(_" & local.i & ")">
		<cfif local.value IS NOT "">
			<cfset arguments.value = evaluate("#local.i#(local.value)")>
		<cfelse>
			<cfset arguments.value = "">
		</cfif>
		<cfif local.first_done>
			<cfset local.html = local.html & arguments.separator>
		</cfif>
		<cfset local.html = local.html & evaluate("#local.i#SelectTag(argumentCollection=arguments)")>
		<cfset local.first_done = true>
	</cfloop>

	<cfreturn local.html>
</cffunction>

<cffunction name="$yearMonthHourMinuteSecondSelectTag" returntype="any" access="private" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="includeBlank" type="any" required="false" default="false">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="_type" type="any" required="true" default="">
	<cfargument name="_loop_from" type="any" required="true" default="">
	<cfargument name="_loop_to" type="any" required="true" default="">
	<cfargument name="_id" type="any" required="false" default="#arguments.name#">
	<cfargument name="_option_names" type="any" required="false" default="">
	<cfargument name="_step" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments._named_arguments = "name,value,includeBlank,label,wrapLabel,prepend,append,prependToLabel,appendToLabel,_type,_loop_from,_loop_to,_id,_option_names,_step">
	<cfset local.attributes = $getAttributes(argumentCollection=arguments)>

	<cfif arguments.value IS "" AND NOT arguments.includeBlank>
		<cfset arguments.value = evaluate("#arguments._type#(now())")>
	</cfif>

	<cfset local.html = "">
	<cfset local.html = local.html & _formBeforeElement(argumentCollection=arguments)>
	<cfset local.html = local.html & "<select name=""#arguments.name#"" id=""#arguments._id#""#local.attributes#>">
	<cfif NOT isBoolean(arguments.includeBlank) OR arguments.includeBlank>
		<cfif NOT isBoolean(arguments.includeBlank)>
			<cfset local.text = arguments.includeBlank>
		<cfelse>
			<cfset local.text = "">
		</cfif>
		<cfset local.html = local.html & "<option value="""">#local.text#</option>">
	</cfif>
	<cfloop from="#arguments._loop_from#" to="#arguments._loop_to#" index="local.i" step="#arguments._step#">
		<cfif arguments.value IS local.i>
			<cfset local.selected = " selected=""selected""">
		<cfelse>
			<cfset local.selected = "">
		</cfif>
		<cfif arguments._option_names IS NOT "">
			<cfset local.option_name = listGetAt(arguments._option_names, local.i)>
		<cfelse>
			<cfset local.option_name = local.i>
		</cfif>
		<cfif arguments._type IS "minute" OR arguments._type IS "second">
			<cfset local.option_name = numberFormat(local.option_name, "09")>
		</cfif>
		<cfset local.html = local.html & "<option value=""#local.i#""#local.selected#>#local.option_name#</option>">
	</cfloop>
	<cfset local.html = local.html & "</select>">
	<cfset local.html = local.html & _formAfterElement(argumentCollection=arguments)>

	<cfreturn local.html>
</cffunction>

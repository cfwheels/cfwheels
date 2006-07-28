<!--- Functions that return form elements --->

<cffunction name="startFormTag" output="false" returntype="string" hint="Outputs HTML for an opening form tag">
	<cfargument name="link" type="string" required="no" default="" hint="The full URL to link to (only use this when not using controller/action/id type links)">
	<cfargument name="name" type="string" required="no" default="form" hint="Name and id of the form">
	<cfargument name="method" type="string" required="false" default="post" hint="How to submit this form (get|post)">
	<cfargument name="class" type="string" required="no" default="" hint="Content for the class attribute">
	<cfargument name="multipart" type="boolean" required="false" default="false" hint="Whether or not to set the enctype for file uploads">
	<cfargument name="target" type="string" required="false" default="" hint="The target for form results to be uploaded to">
	<cfargument name="onsubmit" type="string" required="no" default="" hint="Content for the onsubmit attribute">
	<cfargument name="spamProtection" type="boolean" required="false" default="false" hint="Whether or not to hide the action of the form from spam bots">
	
	<!---
	[DOCS:ARGUMENTS]
	URLFor
	[DOCS:ARGUMENTS END]
	--->

	<cfset var url = "">

	<cfif arguments.link IS NOT "">
		<cfset url = arguments.link>
	<cfelse>
		<cfset url = URLFor(argumentCollection=createArgs(args=arguments, skipArgs="link,name,method,class,onsubmit,multipart,target,spamProtection"))>
	</cfif>

	<cfif arguments.spamProtection>
		<cfset arguments.onsubmit = "this.action='#left(url, int((len(url)/2)))#'+'#right(url, ceiling((len(url)/2)))#';" & arguments.onsubmit>
		<cfset url = "">
	</cfif>

	<cfsavecontent variable="output"><cfoutput>
		<form name="#arguments.name#" id="#arguments.name#" action="#url#" method="#arguments.method#"#iif(arguments.target IS NOT "", de(' target="#arguments.target#"'), de(''))##iif(arguments.multipart, de(' enctype="multipart/form-data"'), de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'), de(''))##iif(arguments.onsubmit IS NOT "", de(' onsubmit="#arguments.onsubmit#"'), de(''))#>
	</cfoutput></cfsavecontent>	

	<cfreturn trim(output)>
</cffunction>


<cffunction name="formRemoteTag" output="false" returntype="string" hint="Outputs HTML for an opening form tag with an Ajax call">
	<cfargument name="name" type="string" required="false" default="form" hint="Name and id of the form">
	<cfargument name="controller" type="string" required="no" default="#request.params.controller#" hint="The controller to link to">
	<cfargument name="action" type="string" required="no" default="#request.params.action#" hint="The action to link to">
	<cfargument name="id" type="numeric" required="no" default=0 hint="The ID to link to">
	<cfargument name="method" type="string" required="false" default="post" hint="How to submit this form (get|post)">
	<cfargument name="class" type="string" required="false" default="" hint="Class for this form tag">
	<cfargument name="multipart" type="boolean" required="false" default="false" hint="Whether or not to set the enctype for file uploads">
	<cfargument name="target" type="string" required="false" default="" hint="The target for form results to be uploaded to">
	<cfargument name="url" type="string" required="false" default = "" hint="A regular URL to link to">
	<cfargument name="spamProtection" type="boolean" required="false" default="false" hint="Whether or not to hide the action of the form from spam bots">
	<!--- Ajax call specific stuff --->
	<cfargument name="update" type="string" required="false" default="" hint="id attribute of an HTML element to replace with content">
	<cfargument name="insertion" type="string" required="false" default="" hint="Where to insert the returned content (Top|Bottom|Before|After)">
	<cfargument name="serialize" type="string" required="false" default="false" hint="Whether or not to serialize the parameters in the form">
	<cfargument name="onLoading" type="string" required="false" default="" hint="Any javascript to execute when the call starts">
	<cfargument name="onComplete" type="string" required="false" default="" hint="Any javascript to execute when the call completes">
	<cfargument name="onSuccess" type="string" required="false" default="" hint="Any javascript to execute when the call completes successfully">
	<cfargument name="onFailure" type="string" required="false" default="" hint="Any javascript to execute if the call fails">
	
	<cfset var ajaxCall = "new Ajax.">
	
	<cfif arguments.url IS NOT "">
		<cfset actionLink = arguments.url>
	<cfelse>
		<cfset actionLink = urlFor(arguments.controller, arguments.action, arguments.id)>
	</cfif>
	
	<!--- Figure out the parameters for the Ajax call --->
	<cfif arguments.update IS NOT "">
		<cfset ajaxCall = ajaxCall & "Updater('#arguments.update#',">
	<cfelse>
		<cfset ajaxCall = ajaxCall & "Request(">
	</cfif>
	
	<cfset ajaxCall = ajaxCall & "'#actionLink#', { asynchronous:true,">
	
	<cfif arguments.insertion IS NOT "">
		<cfset ajaxCall = ajaxCall & "insertion:Insertion.#arguments.insertion#,">
	</cfif>
	
	<cfif arguments.serialize>
		<cfset ajaxCall = ajaxCall & "parameters:Form.serialize(this),">
	</cfif>
	
	<cfif arguments.onLoading IS NOT "">
		<cfset ajaxCall = ajaxCall & "onLoading:#arguments.onLoading#,">
	</cfif>

	<cfif arguments.onComplete IS NOT "">
		<cfset ajaxCall = ajaxCall & "onComplete:#arguments.onComplete#,">
	</cfif>
	
	<cfif arguments.onSuccess IS NOT "">
		<cfset ajaxCall = ajaxCall & "onSuccess:#arguments.onSuccess#">
	</cfif>
	
	<cfif arguments.onFailure IS NOT "">
		<cfset ajaxCall = ajaxCall & "onFailure:#arguments.onFailure#,">
	</cfif>
	
	<cfset ajaxCall = ajaxCall & "});">
	
	<cfif arguments.spamProtection>
		<cfset actionLink = "">
	</cfif>

	<cfsavecontent variable="output"><cfoutput>
		<form name="#arguments.name#" id="#arguments.name#" action="#actionLink#" method="#arguments.method#" onsubmit="#ajaxCall# return false;"#iif(arguments.target IS NOT "", de(' target="#arguments.target#"'), de(''))##iif(arguments.multipart, de(' enctype="multipart/form-data"'), de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'), de(''))#>
	</cfoutput></cfsavecontent>	
	<cfreturn output>
</cffunction>


<cffunction name="endFormTag" output="false" returntype="string" hint="Outputs HTML for a closing form tag">

	<cfset var output = "">
	<cfsavecontent variable="output"></form></cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="textField" returntype="string" output="false" hint="Outputs HTML for a textfield form object">
	<!--- Arguments for all form elements --->
	<cfargument name="label" type="string" required="false" default="" hint="Label for this form element">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this form element">
	<cfargument name="labelClass" type="string" required="false" default="" hint="Class name for the label tag">
	<cfargument name="value" type="string" required="false" default="" hint="The default value of this form element">
	<cfargument name="wrapLabel" type="boolean" required="false" default="false" hint="if true will wrap the label tag around the form element instead of displaying it before">
	<!--- Arguments for all model form elements --->
	<cfargument name="model" type="string" required="true" hint="Name of the model to associate to this form element">
	<cfargument name="field" type="string" required="true" hint="Name of the field in the model that this form element represents">
	<cfargument name="errorDisplay" type="string" required="false" default="div" hint="Determines how errors are displayed. Possible values are: div, span, inline">
	<!--- Arguments for this function only --->
	<cfargument name="size" type="string" required="false" default="" hint="Size of the text field">

	<cfset var output = "">
	
	<cfset arguments.showError = setShowError(argumentCollection=arguments)>
	<cfset arguments.value = setValue(argumentCollection=arguments)>
	<cfset arguments.class = setClass(argumentCollection=arguments)>
	
	<cfsavecontent variable="output">
		<cfoutput>			
			#beforeElement(argumentCollection=arguments)#
			<input type="text" name="#arguments.model#[#arguments.field#]" id="#arguments.model#_#arguments.field#" value="#arguments.value#"#iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.size IS NOT "", de(' size="#arguments.size#"'),de(''))# />
			#afterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="textFieldTag" output="false" returntype="string" hint="Outputs HTML for a textfield form object">
	<!--- Arguments for all form elements --->
	<cfargument name="label" type="string" required="false" default="" hint="Label for this form element">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this form element">
	<cfargument name="labelClass" type="string" required="false" default="" hint="Class name for the label tag">
	<cfargument name="value" type="string" required="false" default="" hint="The default value of this form element">
	<cfargument name="wrapLabel" type="boolean" required="false" default="false" hint="if true will wrap the label tag around the form element instead of displaying it before">
	<!--- Arguments for non model form elements --->
	<cfargument name="name" type="string" required="true" hint="Name and ID attribute for this form element">
	<!--- Arguments for this function only --->
	<cfargument name="size" type="string" required="false" default="" hint="Size of the text field">

	<cfset var output = "">
	
	<cfsavecontent variable="output">
		<cfoutput>
			#beforeElement(argumentCollection=arguments)#
			<input type="text" name="#arguments.name#" id="#arguments.name#"#iif(arguments.value IS NOT "", de(' value="#value#"'),de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.size IS NOT "", de(' size="#arguments.size#"'),de(''))# />
			#afterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="fileFieldTag" returntype="string" output="false" hint="Outputs HTML for a file field form object">
	<!--- Arguments for all form elements (excluding 'value' which is not available for a file input) --->
	<cfargument name="label" type="string" required="false" default="" hint="Label for this form element">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this form element">
	<cfargument name="labelClass" type="string" required="false" default="" hint="Class name for the label tag">
	<cfargument name="wrapLabel" type="boolean" required="false" default="false" hint="if true will wrap the label tag around the form element instead of displaying it before">
	<!--- Arguments for non model form elements --->
	<cfargument name="name" type="string" required="true" hint="Name and ID attribute for this form element">
	<!--- Arguments for this function only --->
	<cfargument name="size" type="string" required="false" default="" hint="Size of the file field">

	<cfset var output = "">
	
	<cfsavecontent variable="output">
		<cfoutput>
			#beforeElement(argumentCollection=arguments)#
			<input type="file" name="#arguments.name#" id="#arguments.name#"#iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.size IS NOT "", de(' size="#arguments.size#"'),de(''))# />
			#afterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="hiddenField" output="false" returntype="string" hint="Outputs HTML for a hidden field form object">
	<!--- Arguments for all model form elements (excluding 'errorDisplay') --->
	<cfargument name="model" type="string" required="true" hint="Name of the model to associate to this form element">
	<cfargument name="field" type="string" required="true" hint="Name of the field in the model that this form element represents">
	<!--- Arguments for all form elements (excluding the ones related to the label) --->
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this form element">
	<cfargument name="value" type="string" required="false" default="" hint="The default value of this form element">

	<cfset var output = "">

	<cfset arguments.value = setValue(arguments)>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<input type="hidden" name="#arguments.model#[#arguments.field#]" id="#arguments.model#_#arguments.field#"#iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.value IS NOT "", de(' value="#arguments.value#"'),de(''))# />
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="hiddenFieldTag" output="false" returntype="string" hint="Outputs HTML for a hidden field form object">
	<!--- Arguments for all form elements (excluding the ones related to the label) --->
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this form element">
	<cfargument name="value" type="string" required="false" default="" hint="The default value of this form element">
	<!--- Arguments for non model form elements --->
	<cfargument name="name" type="string" required="true" hint="Name and ID attribute for this form element">

	<cfset var output = "">
	
	<cfsavecontent variable="output">
		<cfoutput>
			<input type="hidden" name="#arguments.name#" id="#arguments.name#"#iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.value IS NOT "", de(' value="#arguments.value#"'),de(''))# />
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="passwordField" output="false" returntype="string" hint="Outputs HTML for a password form object">
	<!--- Arguments for all form elements --->
	<cfargument name="label" type="string" required="false" default="" hint="Label for this form element">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this form element">
	<cfargument name="labelClass" type="string" required="false" default="" hint="Class name for the label tag">
	<cfargument name="value" type="string" required="false" default="" hint="The default value of this form element">
	<cfargument name="wrapLabel" type="boolean" required="false" default="false" hint="if true will wrap the label tag around the form element instead of displaying it before">
	<!--- Arguments for all model form elements --->
	<cfargument name="model" type="string" required="true" hint="Name of the model to associate to this form element">
	<cfargument name="field" type="string" required="true" hint="Name of the field in the model that this form element represents">
	<cfargument name="errorDisplay" type="string" required="false" default="div" hint="Determines how errors are displayed. Possible values are: div, span, inline">
	<!--- Arguments for this function only --->
	<cfargument name="size" type="string" required="false" default="" hint="Size of the password field">

	<cfset var output = "">
	
	<cfset arguments.showError = setShowError(argumentCollection=arguments)>
	<cfset arguments.value = setValue(argumentCollection=arguments)>
	<cfset arguments.class = setClass(argumentCollection=arguments)>
	
	<cfsavecontent variable="output">
		<cfoutput>			
			#beforeElement(argumentCollection=arguments)#
			<input type="password" name="#arguments.model#[#arguments.field#]" id="#arguments.model#_#arguments.field#" value="#arguments.value#"#iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.size IS NOT "", de(' size="#arguments.size#"'),de(''))# />
			#afterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="passwordFieldTag" output="false" returntype="string" hint="Outputs HTML for a password form object">
	<!--- Arguments for all form elements --->
	<cfargument name="label" type="string" required="false" default="" hint="Label for this form element">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this form element">
	<cfargument name="labelClass" type="string" required="false" default="" hint="Class name for the label tag">
	<cfargument name="value" type="string" required="false" default="" hint="The default value of this form element">
	<cfargument name="wrapLabel" type="boolean" required="false" default="false" hint="if true will wrap the label tag around the form element instead of displaying it before">
	<!--- Arguments for non model form elements --->
	<cfargument name="name" type="string" required="true" hint="Name and ID attribute for this form element">
	<!--- Arguments for this function only --->
	<cfargument name="size" type="string" required="false" default="" hint="Size of the text field">

	<cfset var output = "">
	
	<cfsavecontent variable="output">
		<cfoutput>
			#beforeElement(argumentCollection=arguments)#
			<input type="password" name="#arguments.name#" id="#arguments.name#"#iif(arguments.value IS NOT "", de(' value="#value#"'),de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.size IS NOT "", de(' size="#arguments.size#"'),de(''))# />
			#afterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="textArea" output="false" returntype="string" hint="Outputs HTML for a textfarea form object">
	<!--- Arguments for all form elements --->
	<cfargument name="label" type="string" required="false" default="" hint="Label for this form element">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this form element">
	<cfargument name="labelClass" type="string" required="false" default="" hint="Class name for the label tag">
	<cfargument name="value" type="string" required="false" default="" hint="The default value of this form element">
	<cfargument name="wrapLabel" type="boolean" required="false" default="false" hint="if true will wrap the label tag around the form element instead of displaying it before">
	<!--- Arguments for all model form elements --->
	<cfargument name="model" type="string" required="true" hint="Name of the model to associate to this form element">
	<cfargument name="field" type="string" required="true" hint="Name of the field in the model that this form element represents">
	<cfargument name="errorDisplay" type="string" required="false" default="div" hint="Determines how errors are displayed. Possible values are: div, span, inline">
	<!--- Arguments for this function only --->
	<cfargument name="cols" type="numeric" required="false" default=0 hint="Number of columns (characters) to display">
	<cfargument name="rows" type="numeric" required="false" default=0 hint="Number of rows (lines) to display">

	<cfset var output = "">
	
	<cfset arguments.showError = setShowError(argumentCollection=arguments)>
	<cfset arguments.value = setValue(argumentCollection=arguments)>
	<cfset arguments.class = setClass(argumentCollection=arguments)>
	
	<cfsavecontent variable="output">
		<cfoutput>			
			#beforeElement(argumentCollection=arguments)#
			<textarea name="#arguments.model#[#arguments.field#]" id="#arguments.model#_#arguments.field#"#iif(arguments.cols IS NOT 0, de(' cols="#arguments.cols#"'),de(''))##iif(arguments.rows IS NOT 0, de(' rows="#arguments.rows#"'),de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))#>#arguments.value#</textarea>
			#afterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="textAreaTag" output="false" returntype="string" hint="Outputs HTML for a textfarea form object">
	<!--- Arguments for all form elements --->
	<cfargument name="label" type="string" required="false" default="" hint="Label for this form element">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this form element">
	<cfargument name="labelClass" type="string" required="false" default="" hint="Class name for the label tag">
	<cfargument name="value" type="string" required="false" default="" hint="The default value of this form element">
	<cfargument name="wrapLabel" type="boolean" required="false" default="false" hint="if true will wrap the label tag around the form element instead of displaying it before">
	<!--- Arguments for non model form elements --->
	<cfargument name="name" type="string" required="true" hint="Name and ID attribute for this form element">
	<!--- Arguments for this function only --->
	<cfargument name="cols" type="numeric" required="false" default=0 hint="Number of columns (characters) to display">
	<cfargument name="rows" type="numeric" required="false" default=0 hint="Number of rows (lines) to display">

	<cfset var output = "">
	
	<cfsavecontent variable="output">
		<cfoutput>
			#beforeElement(argumentCollection=arguments)#
			<textarea name="#arguments.name#" id="#arguments.name#"#iif(arguments.cols IS NOT 0, de(' cols="#arguments.cols#"'),de(''))##iif(arguments.rows IS NOT 0, de(' rows="#arguments.rows#"'),de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))#>#arguments.value#</textarea>
			#afterElement(argumentCollection=arguments)#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="radioButton" output="false" returntype="string" hint="Outputs HTML for a radio form object">
	<cfargument name="model" type="string" required="true" hint="Name of the model to associate to this textfield">
	<cfargument name="field" type="string" required="true" hint="Name of the field in the model that this textfield represents">
	<cfargument name="value" type="string" required="true" hint="The value of this radio button">
	<cfargument name="checked" type="boolean" required="false" default="false" hint="Whether this radio button should already be turned on (true) or not (false)">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this field">
	<cfargument name="label" type="string" required="false" default="" hint="Label for this field">
	<cfargument name="onchange" type="string" required="false" default="" hint="">
	
	<cfset var output = "">
	<cfset var modelValue = "">
	
	<cfif isDefined(evaluate("arguments.model"))>
		<!--- Check to see if the "value" passed in, and the value of the field in the model are the same. If so, turn this box on --->
		<cfset modelValue = evaluate("#arguments.model#.#arguments.field#")>
		<cfif modelValue IS arguments.value>
			<cfset arguments.checked = true>
		</cfif>
	</cfif>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<cfif arguments.label IS NOT "">
				<label for="#arguments.field#">#arguments.label#</label>
			</cfif>
			<input type="radio" name="#arguments.model#[#arguments.field#]" id="#arguments.model#_#arguments.field#" value="#arguments.value#"#iif(arguments.checked IS true, de(' checked="checked"'),de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.onchange IS NOT "", de(' onchange="#arguments.onchange#"'),de(''))# />
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="radioButtonTag" output="false" returntype="string" hint="Outputs HTML for a radio form object">
	<cfargument name="name" type="string" required="true" hint="Name of the field in the model that this textfield represents">
	<cfargument name="value" type="string" required="true" hint="The value of this radio button">
	<cfargument name="id" type="string" required="false" default="" hint="Name of the field in the model that this textfield represents">
	<cfargument name="checked" type="boolean" required="false" default="false" hint="Whether this radio button should already be turned on (true) or not (false)">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this field">
	<cfargument name="label" type="string" required="false" default="" hint="Label for this field">
	<cfargument name="onchange" type="string" required="false" default="" hint="">
	
	<cfset var output = "">

	<cfif arguments.id IS "">
		<cfset arguments.id = arguments.name>
	</cfif>

	<cfsavecontent variable="output">
		<cfoutput>
			<cfif arguments.label IS NOT "">
				<label for="#arguments.name#">#arguments.label#</label>
			</cfif>
			<input type="radio" name="#arguments.name#" id="#arguments.id#" value="#arguments.value#"#iif(arguments.checked IS true, de(' checked="checked"'),de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.onchange IS NOT "", de(' onchange="#arguments.onchange#"'),de(''))# />
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="checkBox" output="false" returntype="string" hint="Outputs HTML for a checkbox form object">
	<cfargument name="model" type="string" required="true" hint="Name of the model to associate to this textfield">
	<cfargument name="field" type="string" required="true" hint="Name of the field in the model that this textfield represents">
	<cfargument name="value" type="string" required="true" hint="The value of this checkbox when checked on">
	<cfargument name="checked" type="boolean" required="false" default="false" hint="Whether this checkbox should already be turned on (true) or not (false)">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this field">
	<cfargument name="label" type="string" required="false" default="" hint="Label for this field">
	<cfargument name="onchange" type="string" required="false" default="" hint="Stuff to do on the onchange">
	
	<cfset var output = "">
	<cfset var modelValue = "">
	
	<cfif isDefined(evaluate("arguments.model"))>
		<!--- Check to see if the "value" passed in, and the value of the field in the model are the same. If so, turn this box on --->
		<cfset modelValue = evaluate("#arguments.model#.#arguments.field#")>
		<cfif modelValue IS arguments.value>
			<cfset arguments.checked = true>
		</cfif>
	</cfif>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<cfif arguments.label IS NOT "">
				<label for="#arguments.field#">#arguments.label#</label>
			</cfif>
			<input type="checkbox" name="#arguments.model#[#arguments.field#]" id="#arguments.model#_#arguments.field#" value="#arguments.value#"#iif(arguments.checked IS true, de(' checked="checked"'),de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.onchange IS NOT "", de(' onchange="#arguments.onchange#"'),de(''))# />
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="checkBoxTag" output="false" returntype="string" hint="Outputs HTML for a checkbox form object">
	<cfargument name="name" type="string" required="true" hint="Name of the field in the model that this textfield represents">
	<cfargument name="value" type="string" required="true" hint="The value of this checkbox when checked on">
	<cfargument name="checked" type="boolean" required="false" default="false" hint="Whether this checkbox should already be turned on (true) or not (false)">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this field">
	<cfargument name="label" type="string" required="false" default="" hint="Label for this field">
	<cfargument name="onchange" type="string" required="false" default="" hint="Stuff to do on the onchange">
	
	<cfset var output = "">
	
	<cfsavecontent variable="output">
		<cfoutput>
			<cfif arguments.label IS NOT "">
				<label for="#arguments.name#">#arguments.label#</label>
			</cfif>
			<input type="checkbox" name="#arguments.name#" id="#arguments.name#" value="#arguments.value#"#iif(arguments.checked IS true, de(' checked="checked"'),de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.onchange IS NOT "", de(' onchange="#arguments.onchange#"'),de(''))# />
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="select" output="false" returntype="string" hint="Outputs HTML for a select form object">
	<cfargument name="model" type="string" required="true" hint="Name of the model to associate to this textfield">
	<cfargument name="field" type="string" required="true" hint="Name of the field in the model that this textfield represents">
	<cfargument name="choices" type="any" required="true" hint="The choices to display in the dropdown (can be array, struct, query)">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this field">
	<cfargument name="label" type="string" required="false" default="" hint="Label for this field">
	<cfargument name="size" type="numeric" required="false" default=0 hint="Number of rows to display">
	<cfargument name="type" type="string" required="false" default="single" hint="Menu or multiple select (single|multiple)" />
	<cfargument name="key" type="string" required="false" default="name" hint="The field to use as the value in the <option>s" />
	<cfargument name="value" type="string" required="false" default="id" hint="The field to use as the text displayed in the choices" />
	<cfargument name="onchange" type="string" required="false" default="" hint="Javascript onChange event">
	
	<cfset var output = "">
	<cfset var keyArray = arrayNew(1)>
	<cfset var valueArray = arrayNew(1)>
	<cfset var thisSet = "">
	<cfset var i = 1>
	<cfset var currentValue = "">
	<cfset var options = figureSelectChoices(arguments.choices,arguments.key,arguments.value)>
	
	<cfset keyArray = options.keyArray>
	<cfset valueArray = options.valueArray>
	
	<cfif isDefined(evaluate("arguments.model"))>
		<cfset currentValue = evaluate("#arguments.model#.#arguments.field#")>
	</cfif>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<cfif arguments.label IS NOT "">
				<label for="#arguments.model#_#arguments.field#">#arguments.label#</label>
			</cfif>
			<select name="#arguments.model#[#arguments.field#]" id="#arguments.model#_#arguments.field#"#iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.type IS "multiple", de(' multiple="multiple"'),de(''))##iif(arguments.size IS NOT 0, de(' size="#arguments.size#"'),de(''))##iif(arguments.onchange IS NOT "", de(' onchange="#arguments.onchange#"'),de(''))#>
				<cfloop from="1" to="#arrayLen(keyArray)#" index="i">
					<cfif listFind(currentValue, valueArray[i])>
						<option value="#valueArray[i]#" selected="selected">#keyArray[i]#</option>
					<cfelse>
						<option value="#valueArray[i]#">#keyArray[i]#</option>
					</cfif>
				</cfloop>
			</select>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="selectTag" output="false" returntype="string" hint="Outputs HTML for a select form object">
	<cfargument name="name" type="string" required="false" default="select" hint="Name of the field in the model that this textfield represents">
	<cfargument name="choices" type="any" required="true" hint="The choices to display in the dropdown (can be array, struct, query)">
	<cfargument name="label" type="string" required="false" default="" hint="Label to give the select box">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this field">
	<cfargument name="selected" type="string" required="false" default="" hint="Default selected element">
	<cfargument name="onchange" type="string" required="false" default="" hint="Javascript onChange event">
	<cfargument name="type" type="string" required="false" default="single" hint="Menu or multiple select (single|multiple)" />
	<cfargument name="key" type="string" required="false" default="name" hint="The field to use as the value in the <option>s" />
	<cfargument name="value" type="string" required="false" default="id" hint="The field to use as the text displayed in the choices" />
	
	<cfset var output = "">
	<cfset var keyArray = arrayNew(1)>
	<cfset var valueArray = arrayNew(1)>
	<cfset var thisSet = "">
	<cfset var i = 1>
	<cfset var options = figureSelectChoices(arguments.choices,arguments.key,arguments.value)>
	
	<cfset keyArray = options.keyArray>
	<cfset valueArray = options.valueArray>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<cfif arguments.label IS NOT "">
				<label for="#arguments.name#">#arguments.label#</label>
			</cfif>
			<select name="#arguments.name#" id="#arguments.name#"#iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.type IS "multiple", de(' multiple="multiple"'),de(''))##iif(arguments.onchange IS NOT "", de(' onchange="#arguments.onchange#"'),de(''))#>
				<cfloop from="1" to="#arrayLen(keyArray)#" index="i">
					<cfif valueArray[i] IS arguments.selected>
						<option value="#valueArray[i]#" selected="selected">#keyArray[i]#</option>
					<cfelse>
						<option value="#valueArray[i]#">#keyArray[i]#</option>
					</cfif>
				</cfloop>
			</select>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="figureSelectChoices" access="private" returntype="struct" output="false" hint="">
	<cfargument name="choices" type="any" required="true" hint="">
	<cfargument name="key" type="string" required="false" default="name" hint="The field to use as the value in the <option>s" />
	<cfargument name="value" type="string" required="false" default="id" hint="The field to use as the text displayed in the choices" />
	
	<cfset var options = structNew()>
	<cfset var keyArray = arrayNew(1)>
	<cfset var valueArray = arrayNew(1)>
	<cfset var i = 1>
	<cfset var thisSet = arrayNew(1)>
	
	<cfif isArray(arguments.choices)>
		<!--- If the choices are in an array, check to see if it's an array of arrays --->

		<cfif isArray(arguments.choices[1])>
			<!--- If so, take the first value and make that the value, take the second value and make that the key --->
			<cfloop from="1" to="#arrayLen(arguments.choices)#" index="i">
				<cfset thisSet = arguments.choices[i]>
				<cfset keyArray[i] = thisSet[1]>
				<cfset valueArray[i] = thisSet[2]>
			</cfloop>
		<cfelseif isStruct(arguments.choices[1])>
			<cfloop from="1" to="#arrayLen(arguments.choices)#" index="i">
				<cfset keyArray[i] = arguments.choices[i][arguments.key]>
				<cfset valueArray[i] = arguments.choices[i][arguments.value]>
			</cfloop>
		<cfelse>
			<cfset keyArray = arguments.choices>
			<cfset valueArray = arguments.choices>
		</cfif>

	<cfelseif isStruct(arguments.choices)>
		<!--- If it's a struct, set the name of the key is the text to be displayed and the value as the value="" attribute of <option> --->
		<cfloop collection="#arguments.choices#" item="key">
			<cfset keyArray[i] = key>
			<cfset valueArray[i] = arguments.choices[key]>
			<cfset i = i + 1>
		</cfloop>
	<cfelseif isQuery(arguments.choices)>
		<!--- If it's a query, assume that it has an "id" column as the value and "name" column as the key --->
		<cfloop query="arguments.choices">
			<cfset keyArray[i] = evaluate("arguments.choices.#arguments.key#")>
			<cfset valueArray[i] = evaluate("arguments.choices.#arguments.value#")>
			<cfset i = i + 1>
		</cfloop>
	</cfif>
	
	<cfset options.keyArray = keyArray>
	<cfset options.valueArray = valueArray>
	
	<cfreturn options>
	
</cffunction>


<!---
<cffunction name="collectionSelect" output="false" returntype="string" hint="Outputs HTML for a textfield form object">
	<cfargument name="model" type="string" required="true" hint="Name of the model to associate to this textfield">
	<cfargument name="field" type="string" required="true" hint="Name of the field in the model that this textfield represents">
	<cfargument name="choices" type="query" required="true" hint="The choices to display in the dropdown (can be array, struct, query)">
	<cfargument name="value" type="string" required="true" hint="The column in the choices query to use as the value">
	<cfargument name="key" type="string" required="true" hint="The column in the choices query to use as the key">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this field">
	
	<cfset var output = "">
	<cfset var keyArray = arrayNew(1)>
	<cfset var valueArray = arrayNew(1)>
	<cfset var i = 1>
	
	<cfloop query="arguments.choices">
		<cfset keyArray[i] = evaluate("#arguments.key#")>
		<cfset valueArray[i] = evaluate("#arguments.value#")>
		<cfset i = i + 1>
	</cfloop>

	<cfsavecontent variable="output">
		<cfoutput>
			<select name="#arguments.model#[#arguments.field#]" id="#arguments.model#_#arguments.field#" #iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))#>
				<cfloop from="1" to="#arrayLen(keyArray)#" index="i">
					<cfif valueArray[i] IS arguments.field>
						<option value="#valueArray[i]#" selected="selected">#keyArray[i]#</option>
					<cfelse>
						<option value="#valueArray[i]#">#keyArray[i]#</option>
					</cfif>
				</cfloop>
			</select>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
	
</cffunction>
--->


<cffunction name="submitTag" output="false" returntype="string" hint="Outputs HTML for a submit form object">
	<cfargument name="name" type="string" required="false" default="commit" hint="The name for this button">
	<cfargument name="value" type="string" required="false" default="" hint="Text to display on the button">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this field">
	<cfargument name="onclick" type="string" required="false" default="" hint="Javascript to execute when this button is clicked">

	<cfset var output = "">
	<cfsavecontent variable="output">
		<cfoutput><input type="submit" name="#arguments.name#" id="#arguments.name#" value="#arguments.value#"#iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.onclick IS NOT "", de(' onclick="#arguments.onclick#"'),de(''))# /></cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="buttonTag" output="false" returntype="string" hint="Outputs HTML for a button form object">
	<cfargument name="name" type="string" required="false" default="" hint="The name for this button">
	<cfargument name="value" type="string" required="false" default="" hint="Text to display on the button">
	<cfargument name="class" type="string" required="false" default="" hint="Class name for this field">
	<cfargument name="onclick" type="string" required="false" default="" hint="Javascript to execute when this button is clicked">
	
	<cfset var output = "">
	<cfsavecontent variable="output">
		<cfoutput><input type="button" name="#arguments.name#"#iif(arguments.value IS NOT "", de(' value="#arguments.value#"'),de(''))##iif(arguments.class IS NOT "", de(' class="#arguments.class#"'),de(''))##iif(arguments.onclick IS NOT "", de(' onclick="#arguments.onclick#"'),de(''))# /></cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="dateSelect" output="false" returntype="string" hint="Outputs select tags for choosing the date">
	<cfargument name="model" type="any" required="false" default="" hint="The date to show by default">
	<cfargument name="field" type="string" requires="false" default="" hint="The order to display the select boxes in">
	<cfargument name="date" type="any" required="false" default="" hint="The date to show by default">
	<cfargument name="order" type="string" requires="false" default="year,month,day" hint="The order to display the select boxes in">
	<cfargument name="addMonthNumbers" type="boolean" required="false" default="false" hint="Whether or not to show the number of the month along with the name">
	<cfargument name="useMonthNumbers" type="boolean" required="false" default="false" hint="Whether or not to show only the number of the month">
	<cfargument name="startYear" type="numeric" required="false" default="0" hint="The starting year in the Year dropdown (defaults to arguments.date - 5)">
	<cfargument name="endYear" type="numeric" required="false" default="0" hint="The starting year in the Year dropdown (defaults to arguments.date + 5)">
	<cfargument name="label" type="string" required="false" default="" hint="Label to display">
	
	<cfif arguments.date IS "">
		<cfif isDefined(evaluate("arguments.model"))>
			<cfset arguments.date = evaluate("#arguments.model#.#arguments.field#")>
		</cfif>
	</cfif>
	
	<cfif arguments.date IS "">
		<cfset arguments.date = now()>
	</cfif>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<cfif arguments.label IS NOT "">
				<label>#arguments.label#</label>
			</cfif>
			<cfloop list="#arguments.order#" index="part">
				<cfswitch expression="#trim(part)#">
					<cfcase value="day">
						#daySelect(arguments.model,arguments.field,arguments.date)#
					</cfcase>
					<cfcase value="month">
						#monthSelect(arguments.model,arguments.field,arguments.date,arguments.addMonthNumbers,arguments.useMonthNumbers)#
					</cfcase>
					<cfcase value="year">
						#yearSelect(arguments.model,arguments.field,arguments.date,arguments.startYear,arguments.endYear)#
					</cfcase>
				</cfswitch>
			</cfloop>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="daySelect" output="false" returntype="string" hint="Outputs HTML for a textfield form object">
	<cfargument name="model" type="any" required="false" default="" hint="The date to show by default">
	<cfargument name="field" type="string" requires="false" default="" hint="The order to display the select boxes in">
	<cfargument name="date" type="any" required="false" default="#now()#" hint="The date to show by default">

	<cfset var output = "">
	<cfset var i = 0>
	<cfset var theDay = day(arguments.date)>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<select name="#arguments.model#[#arguments.field#(3i)]">
				<cfloop from="1" to="31" index="i">
					<cfif i IS theDay>
						<option value="#i#" selected="selected">#i#</option>
					<cfelse>
						<option value="#i#">#i#</option>
					</cfif>
				</cfloop>
			</select>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="monthSelect" output="false" returntype="string" hint="Outputs HTML for a textfield form object">
	<cfargument name="model" type="any" required="false" default="" hint="The date to show by default">
	<cfargument name="field" type="string" requires="false" default="" hint="The order to display the select boxes in">
	<cfargument name="date" type="any" required="false" default="#now()#" hint="The date to show by default">
	<cfargument name="addMonthNumbers" type="boolean" required="false" default="false" hint="Whether or not to show the number of the month along with the name">
	<cfargument name="useMonthNumbers" type="boolean" required="false" default="false" hint="Whether or not to show only the number of the month">

	<cfset var output = "">
	<cfset var i = 0>
	<cfset var theMonth = month(arguments.date)>
	<cfset var monthNames = "January,February,March,April,May,June,July,August,September,October,November,December">
	<cfset monthNames = listToArray(monthNames)>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<select name="#arguments.model#[#arguments.field#(2i)]">
				<cfloop from="1" to="12" index="i">
					<cfif i IS theMonth>
						<option value="#i#" selected="selected">#iif(arguments.addMonthNumbers OR arguments.useMonthNumbers, i, de(""))##iif(arguments.addMonthNumbers, de(" - "), de(""))##iif(arguments.useMonthNumbers, de(""), de("#monthNames[i]#"))#</option>
					<cfelse>
						<option value="#i#">#iif(arguments.addMonthNumbers OR arguments.useMonthNumbers, i, de(""))##iif(arguments.addMonthNumbers, de(" - "), de(""))##iif(arguments.useMonthNumbers, de(""), de("#monthNames[i]#"))#</option>
					</cfif>
				</cfloop>
			</select>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="yearSelect" output="false" returntype="string" hint="Outputs HTML for a textfield form object">
	<cfargument name="model" type="any" required="false" default="" hint="The date to show by default">
	<cfargument name="field" type="string" requires="false" default="" hint="The order to display the select boxes in">
	<cfargument name="date" type="any" required="true" default="" hint="The date to show by default">
	<cfargument name="startYear" type="numeric" required="false" default="0" hint="The starting year in the Year dropdown (defaults to arguments.date - 5)">
	<cfargument name="endYear" type="numeric" required="false" default="0" hint="The starting year in the Year dropdown (defaults to arguments.date + 5)">

	<cfset var output = "">
	<cfset var theYear = year(arguments.date)>
	
	<cfif arguments.startYear IS 0>
		<cfset arguments.startYear = theYear - 5>
	</cfif>
	<cfif arguments.endYear IS 0>
		<cfset arguments.endYear = theYear + 5>
	</cfif>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<select name="#arguments.model#[#arguments.field#(1i)]">
				<cfloop from="#arguments.startYear#" to="#arguments.endYear#" index="i">
					<cfif i IS theYear>
						<option value="#i#" selected="selected">#i#</option>
					<cfelse>
						<option value="#i#">#i#</option>
					</cfif>
				</cfloop>
			</select>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="dateTimeSelect" output="false" returntype="string" hint="Outputs HTML for a textfield form object">
	<cfargument name="model" type="any" required="false" default="" hint="The date to show by default">
	<cfargument name="field" type="string" requires="false" default="" hint="The order to display the select boxes in">
	<cfargument name="datetime" type="any" required="false" default="" hint="The date and time to show by default">
	<cfargument name="order" type="string" requires="false" default="year,month,day,hour,minute" hint="The order to display the select boxes in">
	<cfargument name="addMonthNumbers" type="boolean" required="false" default="false" hint="Whether or not to show the number of the month along with the name">
	<cfargument name="useMonthNumbers" type="boolean" required="false" default="false" hint="Whether or not to show only the number of the month">
	<cfargument name="startYear" type="numeric" required="false" default="0" hint="The starting year in the Year dropdown (defaults to arguments.date - 5)">
	<cfargument name="endYear" type="numeric" required="false" default="0" hint="The starting year in the Year dropdown (defaults to arguments.date + 5)">
	<cfargument name="label" type="string" required="false" default="" hint="The label to apply to these selects">
	
	<cfset var output = "">


	<cfif arguments.datetime IS "">
		<cfif isDefined(evaluate("arguments.model"))>
			<cfset arguments.datetime = evaluate("#arguments.model#.#arguments.field#")>
		</cfif>
	</cfif>
	
	<cfif arguments.datetime IS "">
		<cfset arguments.datetime = now()>
	</cfif>

	<cfsavecontent variable="output">
		<cfoutput>
			<cfif arguments.label IS NOT "">
				<label>#arguments.label#</label>
			</cfif>
			#dateSelect(	model = arguments.model,
							field = arguments.field,
							date = arguments.datetime, 
							order = arguments.order,
							addMonthNumbers = arguments.addMonthNumbers, 
							useMonthNumbers = arguments.useMonthNumbers,
							startYear = arguments.startYear,
							endYear = arguments.endYear )# &mdash;
			#timeSelect(	model = arguments.model,
							field = arguments.field,
							time = arguments.datetime,
							order = arguments.order )#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="hourSelect" output="false" returntype="string" hint="Outputs HTML for a textfield form object">
	<cfargument name="model" type="any" required="false" default="" hint="The date to show by default">
	<cfargument name="field" type="string" requires="false" default="" hint="The order to display the select boxes in">
	<cfargument name="time" type="any" required="false" default="#now()#" hint="The time to show by default">
	
	<cfset var output = "">
	<cfset var i = 0>
	<cfset var theHour = hour(arguments.time)>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<select name="#arguments.model#[#arguments.field#(4i)]">
				<cfloop from="1" to="24" index="i">
					<cfif i IS theHour>
						<option value="#i#" selected="selected">#i#</option>
					<cfelse>
						<option value="#i#">#i#</option>
					</cfif>
				</cfloop>
			</select>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="minuteSelect" output="false" returntype="string" hint="Outputs HTML for a textfield form object">
	<cfargument name="model" type="any" required="false" default="" hint="The date to show by default">
	<cfargument name="field" type="string" requires="false" default="" hint="The order to display the select boxes in">
	<cfargument name="time" type="any" required="false" default="#now()#" hint="The time to show by default">
	
	<cfset var output = "">
	<cfset var i = 0>
	<cfset var theMinute = minute(arguments.time)>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<select name="#arguments.model#[#arguments.field#(5i)]">
				<cfloop from="1" to="60" index="i">
					<cfif i IS theMinute>
						<cfif i LT 10>
							<option value="0#i#" selected="selected">0#i#</option>
						<cfelse>
							<option value="#i#" selected="selected">#i#</option>
						</cfif>
					<cfelseif i LT 10>
						<option value="0#i#">0#i#</option>
					<cfelse>
						<option value="#i#">#i#</option>
					</cfif>
				</cfloop>
			</select>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="secondSelect" output="false" returntype="string" hint="Outputs HTML for a textfield form object">
	<cfargument name="model" type="any" required="false" default="" hint="The date to show by default">
	<cfargument name="field" type="string" requires="false" default="" hint="The order to display the select boxes in">
	<cfargument name="time" type="any" required="false" default="#now()#" hint="The time to show by default">
	
	<cfset var output = "">
	<cfset var i = 0>
	<cfset var theSecond = second(arguments.time)>
	
	<cfsavecontent variable="output">
		<cfoutput>
			<select name="#arguments.model#[#arguments.field#(6i)]">
				<cfloop from="1" to="60" index="i">
					<cfif i IS theSecond>
						<cfif i LT 10>
							<option value="0#i#" selected="selected">0#i#</option>
						<cfelse>
							<option value="#i#" selected="selected">#i#</option>
						</cfif>
					<cfelseif i LT 10>
						<option value="0#i#">0#i#</option>
					<cfelse>
						<option value="#i#">#i#</option>
					</cfif>
				</cfloop>
			</select>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="timeSelect" output="false" returntype="string" hint="Outputs HTML for a textfield form object">
	<cfargument name="model" type="any" required="false" default="" hint="The date to show by default">
	<cfargument name="field" type="string" requires="false" default="" hint="The order to display the select boxes in">
	<cfargument name="time" type="any" required="false" default="" hint="The time to show by default">
	<cfargument name="order" type="string" requires="false" default="hour,minute" hint="The order to display the select boxes in">
	
	<cfset var output = "">
	
	<cfif arguments.time IS "">
		<cfif isDefined(evaluate("arguments.model"))>
			<cfset arguments.time = evaluate("#arguments.model#.#arguments.field#")>
		</cfif>
	</cfif>
	
	<cfif arguments.time IS "">
		<cfset arguments.time = now()>
	</cfif>

	<cfsavecontent variable="output">
		<cfoutput>
			<cfloop list="#arguments.order#" index="part">
				<cfswitch expression="#trim(part)#">
					<cfcase value="hour">
						#hourSelect(arguments.model,arguments.field,arguments.time)#
					</cfcase>
					<cfcase value="minute">
						:#minuteSelect(arguments.model,arguments.field,arguments.time)#
					</cfcase>
					<cfcase value="second">
						:#secondSelect(arguments.model,arguments.field,arguments.time)#
					</cfcase>
				</cfswitch>
			</cfloop>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="errorMessageOn" output="false" returntype="string" hint="[DOCS] Returns a string containing the error message for the field name on the model, if one exists">
	<cfargument name="model" type="any" required="yes" hint="The model to display errors for">
	<cfargument name="fieldName" type="any" required="yes" hint="The field name to display errors for">
	<cfargument name="prependText" type="string" required="no" default="" hint="Text to prepend to the error message">
	<cfargument name="appendText" type="string" required="no" default="" hint="Text to append to the error message">
	<cfargument name="class" type="string" required="no" default="formError" hint="Content for the class attribute">
	<cfargument name="errorDisplay" type="string" required="false" default="div" hint="Determines how errors are displayed. Possible values are: div and span">

	<cfset var output = "">
	<cfset var error = "">

	<cfset error = arguments.model.errorsOn(arguments.fieldName)>
	<cfif NOT isBoolean(error)>
		<cfsavecontent variable="output">
			<cfoutput>
				<#arguments.errorDisplay# class="#arguments.class#">#arguments.prependText##error[1]##arguments.appendText#</#arguments.errorDisplay#>
			</cfoutput>
		</cfsavecontent>
	</cfif>
	
	<cfreturn output>
</cffunction>


<cffunction name="errorMessagesFor" output="false" returntype="string" hint="[DOCS] Returns a string containing all the error messages for the model">
	<cfargument name="model" type="any" required="true" hint="The model to display errors for">
	<cfargument name="headerTag" type="string" required="false" default="h2" hint="The HTML tag to use as the header">
	<cfargument name="id" type="string" required="false" default="errorExplanation" hint="Content for the id attribute">
	<cfargument name="class" type="string" required="false" default="errorExplanation" hint="Content for the class attribute">
	<cfargument name="listOnly" type="boolean" required="false" default="false" hint="if true will only return the list of errors and not the header and paragraph">

	<cfset var output = "">
	<cfset var errors = arrayNew(1)>

	<cfif NOT arguments.model.errorsIsEmpty()>
		<cfset errors = arguments.model.errorsFullMessages()>
		<cfsavecontent variable="output">
			<cfoutput>
				<div id="#arguments.id#" class="#arguments.class#">
					<cfif NOT arguments.listOnly>
						<#arguments.headerTag#>#arrayLen(errors)# error<cfif arrayLen(errors) GT 1>s</cfif> prevented this #arguments.model._name# from being saved</#arguments.headerTag#>
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


<!--- Internal functions called from the other form functions --->


<cffunction name="setShowError" access="private" output="false" returntype="boolean" hint="">

	<cfset var thisModel = "">

	<cfset thisModel = evaluate("#arguments.model#")>
	<cfif NOT isBoolean(thisModel.errorsOn(arguments.field))>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>

</cffunction>


<cffunction name="setValue" access="private" output="false" returntype="string" hint="">
	
	<cfset var output = "">
	<cfset var thisModel = "">

	<cfif arguments.value IS "">
		<cfset thisModel = evaluate("#arguments.model#")>
		<cfset output = thisModel[arguments.field]>
	<cfelse>
		<cfset output = arguments.value>
	</cfif>

	<cfreturn output>	
</cffunction>


<cffunction name="setClass" access="private" output="false" returntype="string" hint="">

	<cfset var output = "">

	<cfif arguments.showError AND arguments.errorDisplay IS "inline">
		<cfif arguments.class IS NOT "">
			<cfset output = arguments.class & " fieldWithErrors">
		<cfelse>
			<cfset output = "fieldWithErrors">
		</cfif>
	<cfelse>
		<cfset output = arguments.class>
	</cfif>

	<cfreturn output>	
</cffunction>


<cffunction name="beforeElement" access="private" output="false" returntype="string">

	<cfset var output = "">
	<cfset var labelFor = "">

	<cfsavecontent variable="output">
		<cfoutput>
			<cfif arguments.label IS NOT "">
				<cfif isDefined("arguments.model")>
					<cfset labelFor = arguments.model & "_" & arguments.field>
				<cfelse>
					<cfset labelFor = arguments.name>
				</cfif>
				<label for="#labelFor#"#iif(arguments.labelClass IS NOT "", de(' class="#arguments.labelClass#"'),de(''))#>#arguments.label#
				<cfif arguments.wrapLabel IS false>
					</label>
				</cfif>
			</cfif>
			<cfif isDefined("arguments.model") AND arguments.showError AND arguments.errorDisplay IS NOT "inline">
				<#arguments.errorDisplay# class="fieldWithErrors">
			</cfif>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>


<cffunction name="afterElement" access="private" output="false" returntype="string">

	<cfset var output = "">

	<cfsavecontent variable="output">
		<cfoutput>
			<cfif isDefined("arguments.model") AND arguments.showError AND arguments.errorDisplay IS NOT "inline">
				</#arguments.errorDisplay#>
			</cfif>
			<cfif arguments.label IS NOT "" AND arguments.wrapLabel IS true>
				</label>
			</cfif>	
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn output>
</cffunction>

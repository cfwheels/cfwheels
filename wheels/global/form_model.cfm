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


<cffunction name="hiddenField" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "object_name,field">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfset local.value = FL_formValue(argumentCollection=arguments)>
	<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
		<cfset local.value = encryptParam(local.value)>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<input type="hidden" name="#listLast(arguments.object_name,".")#[#arguments.field#]" id="#listLast(arguments.object_name,".")#_#arguments.field#" value="#local.value#"#local.attributes# />
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



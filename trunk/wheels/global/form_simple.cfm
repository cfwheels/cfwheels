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


<cffunction name="hiddenFieldTag" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var local = structNew()>
	<cfset arguments.FL_named_arguments = "name,value">
	<cfset local.attributes = FL_getAttributes(argumentCollection=arguments)>

	<cfset local.value = FL_formValue(argumentCollection=arguments)>
	<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
		<cfset local.value = encryptParam(local.value)>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<input name="#arguments.name#" id="#arguments.name#" type="hidden" value="#local.value#"#local.attributes# />
		</cfoutput>
	</cfsavecontent>

	<cfreturn FL_trimHTML(local.output)>
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


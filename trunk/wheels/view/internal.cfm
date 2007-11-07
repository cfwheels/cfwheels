<cffunction name="CFW_optionsForSelect" returntype="any" access="private" output="false">
	<cfargument name="options" type="any" required="true">
	<cfargument name="value_field" type="any" required="false" default="id">
	<cfargument name="text_field" type="any" required="false" default="name">
	<cfset var local = structNew()>

	<cfset local.value = CFW_formValue(argumentCollection=arguments)>
	<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
		<cfset local.value = encryptParam(local.value)>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfif isQuery(arguments.options)>
				<cfloop query="arguments.options">
					<cfset local.option_value = arguments.options[arguments.value_field][currentrow]>
					<cfset local.option_text = arguments.options[arguments.text_field][currentrow]>
					<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
						<cfset local.option_value = encryptParam(local.option_value)>
					</cfif>
					<option value="#local.option_value#"<cfif listFindNoCase(local.value, local.option_value) IS NOT 0> selected="selected"</cfif>>#local.option_text#</option>
				</cfloop>
			<cfelseif isStruct(arguments.options)>
				<cfloop collection="#arguments.options#" item="local.i">
					<cfset local.option_value = local.i>
					<cfset local.option_text = arguments.options[local.i]>
					<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
						<cfset local.option_value = encryptParam(local.option_value)>
					</cfif>
					<option value="#local.option_value#"<cfif listFindNoCase(local.value, local.option_value) IS NOT 0> selected="selected"</cfif>>#local.option_text#</option>
				</cfloop>
			<cfelseif isArray(arguments.options)>
				<cfloop from="1" to="#arrayLen(arguments.options)#" index="local.i">
					<cfset local.option_value = local.i>
					<cfset local.option_text = arguments.options[local.i]>
					<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
						<cfset local.option_value = encryptParam(local.option_value)>
					</cfif>
					<option value="#local.option_value#"<cfif listFindNoCase(local.value, local.option_value) IS NOT 0> selected="selected"</cfif>>#local.option_text#</option>
				</cfloop>
			<cfelse>
				<cfloop list="#arguments.options#" index="local.i">
					<cfset local.option_value = local.i>
					<cfset local.option_text = local.i>
					<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
						<cfset local.option_value = encryptParam(local.option_value)>
					</cfif>
					<option value="#local.option_value#"<cfif listFindNoCase(local.value, local.option_value) IS NOT 0> selected="selected"</cfif>>#local.option_text#</option>
				</cfloop>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn CFW_trimHTML(local.output)>
</cffunction>


<cffunction name="CFW_formValue" returntype="any" access="private" output="false">
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


<cffunction name="CFW_formHasError" returntype="any" access="private" output="false">
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


<cffunction name="CFW_formBeforeElement" returntype="any" access="private" output="false">
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
	<cfif CFW_formHasError(argumentCollection=arguments)>
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


<cffunction name="CFW_formAfterElement" returntype="any" access="private" output="false">
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
	<cfif CFW_formHasError(argumentCollection=arguments)>
		<cfset local.output = local.output & "</#arguments.error_element#>">
	</cfif>

	<cfreturn local.output>
</cffunction>

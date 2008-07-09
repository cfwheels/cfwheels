<cffunction name="_HTMLAttributes" returntype="any" access="private" output="false">
	<cfargument name="attributes" type="any" required="true">
	<cfset var locals = structNew()>
	<cfset locals.result = arguments.attributes>
	<cfif len(locals.result) IS NOT 0>
		<cfif locals.result Does Not Contain """" AND locals.result Does Not Contain "'">
			<cfset locals.result = REReplace(locals.result, "=", "=""", "all")>
			<cfset locals.result = REReplace(locals.result, "( [^=]*=)", """\1", "all")>
			<cfset locals.result = locals.result & """">
		</cfif>
		<cfset locals.result = " " & locals.result>
	</cfif>
	<cfreturn locals.result>
</cffunction>

<cffunction name="_optionsForSelect" returntype="any" access="private" output="false">
	<cfargument name="options" type="any" required="true">
	<cfargument name="valueField" type="any" required="false" default="id">
	<cfargument name="textField" type="any" required="false" default="name">
	<cfset var local = structNew()>

	<cfset local.value = _formValue(argumentCollection=arguments)>
	<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
		<cfset local.value = obfuscateParam(local.value)>
	</cfif>

	<cfsavecontent variable="local.output">
		<cfoutput>
			<cfif isQuery(arguments.options)>
				<cfloop query="arguments.options">
					<cfset local.option_value = arguments.options[arguments.valueField][currentrow]>
					<cfset local.option_text = arguments.options[arguments.textField][currentrow]>
					<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
						<cfset local.option_value = obfuscateParam(local.option_value)>
					</cfif>
					<option value="#local.option_value#"<cfif listFindNoCase(local.value, local.option_value) IS NOT 0> selected="selected"</cfif>>#local.option_text#</option>
				</cfloop>
			<cfelseif isStruct(arguments.options)>
				<cfloop collection="#arguments.options#" item="local.i">
					<cfset local.option_value = local.i>
					<cfset local.option_text = arguments.options[local.i]>
					<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
						<cfset local.option_value = obfuscateParam(local.option_value)>
					</cfif>
					<option value="#local.option_value#"<cfif listFindNoCase(local.value, local.option_value) IS NOT 0> selected="selected"</cfif>>#local.option_text#</option>
				</cfloop>
			<cfelseif isArray(arguments.options)>
				<cfloop from="1" to="#arrayLen(arguments.options)#" index="local.i">
					<cfset local.option_value = local.i>
					<cfset local.option_text = arguments.options[local.i]>
					<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
						<cfset local.option_value = obfuscateParam(local.option_value)>
					</cfif>
					<option value="#local.option_value#"<cfif listFindNoCase(local.value, local.option_value) IS NOT 0> selected="selected"</cfif>>#local.option_text#</option>
				</cfloop>
			<cfelse>
				<cfloop list="#arguments.options#" index="local.i">
					<cfset local.option_value = local.i>
					<cfset local.option_text = local.i>
					<cfif structKeyExists(request.wheels, "current_form_method") AND request.wheels.current_form_method IS "get">
						<cfset local.option_value = obfuscateParam(local.option_value)>
					</cfif>
					<option value="#local.option_value#"<cfif listFindNoCase(local.value, local.option_value) IS NOT 0> selected="selected"</cfif>>#local.option_text#</option>
				</cfloop>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn _trimHTML(local.output)>
</cffunction>

<cffunction name="_formValue" returntype="any" access="private" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfif len(arguments.objectName) IS NOT 0>
		<!--- this is a form field for a model object --->
		<cfset local.object = evaluate(arguments.objectName)>
		<cfif structKeyExists(local.object, arguments.property)>
			<cfset local.value = local.object[arguments.property]>
		<cfelse>
			<cfset local.value = "">
		</cfif>
	<cfelse>
		<cfset local.value = arguments.value>
	</cfif>

	<cfreturn local.value>
</cffunction>

<cffunction name="_formHasError" returntype="any" access="private" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfif len(arguments.objectName) IS NOT 0>
		<!--- this is a form field for a model object --->
		<cfset local.object = evaluate(arguments.objectName)>
		<cfset local.error = ArrayLen(local.object.errorsOn(arguments.property))>
	<cfelse>
		<cfset local.error = false>
	</cfif>

	<cfreturn local.error>
</cffunction>

<cffunction name="_formBeforeElement" returntype="any" access="private" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var local = structNew()>

	<cfset local.output = "">
	<cfif _formHasError(argumentCollection=arguments)>
		<cfset local.output = local.output & "<#arguments.errorElement# class=""field-with-errors"">">
	</cfif>

	<cfif len(arguments.label) IS NOT 0>
		<cfset local.output = local.output & arguments.prependToLabel>
		<cfif len(arguments.objectName) IS NOT 0>
			<cfset local.output = local.output & "<label for=""#listLast(arguments.objectName,'.')#_#arguments.property#""">
		<cfelse>
			<cfset local.output = local.output & "<label for=""#arguments.name#""">
		</cfif>
		<cfloop collection="#arguments#" item="local.i">
			<cfif left(local.i, 6) IS "label_">
				<cfset local.output = local.output & " #replace(local.i, 'label_', '')#=""#arguments[local.i]#""">
			</cfif>
		</cfloop>
		<cfset local.output = local.output & ">" & arguments.label>
		<cfif NOT arguments.wrapLabel>
			<cfset local.output = local.output & "</label>" & arguments.appendToLabel>
		</cfif>
	</cfif>
	<cfset local.output = local.output & arguments.prepend>

	<cfreturn local.output>
</cffunction>

<cffunction name="_formAfterElement" returntype="any" access="private" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfargument name="label" type="any" required="false" default="">
	<cfargument name="wrapLabel" type="any" required="false" default="true">
	<cfargument name="prepend" type="any" required="false" default="">
	<cfargument name="append" type="any" required="false" default="">
	<cfargument name="prependToLabel" type="any" required="false" default="">
	<cfargument name="appendToLabel" type="any" required="false" default="">
	<cfargument name="errorElement" type="any" required="false" default="div">
	<cfset var local = structNew()>

	<cfset local.output = "">
	<cfset local.output = local.output & arguments.append>
	<cfif len(arguments.label) IS NOT 0>
		<cfif arguments.wrapLabel>
			<cfset local.output = local.output & "</label>">
			<cfset local.output = local.output & arguments.appendToLabel>
		</cfif>
	</cfif>
	<cfif _formHasError(argumentCollection=arguments)>
		<cfset local.output = local.output & "</#arguments.errorElement#>">
	</cfif>

	<cfreturn local.output>
</cffunction>

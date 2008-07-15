<cffunction name="$trimHTML" returntype="string" access="private" output="false">
	<cfargument name="str" type="string" required="true">
	<cfreturn replaceList(trim(arguments.str), "#chr(9)#,#chr(10)#,#chr(13)#", ",,")>
</cffunction>

<cffunction name="$getAttributes" returntype="string" access="private" output="false">
	<cfset var loc = {}>

	<cfset loc.attributes = "">
	<cfloop collection="#arguments#" item="loc.i">
		<cfif loc.i Does Not Contain "$" AND listFindNoCase(arguments.$namedArguments, loc.i) IS 0>
			<cfset loc.attributes = "#loc.attributes# #lCase(loc.i)#=""#arguments[loc.i]#""">
		</cfif>
	</cfloop>

	<cfreturn loc.attributes>
</cffunction>

<cffunction name="$optionsForSelect" returntype="any" access="private" output="false">
	<cfargument name="options" type="any" required="true">
	<cfargument name="valueField" type="any" required="false" default="id">
	<cfargument name="textField" type="any" required="false" default="name">
	<cfset var loc = {}>

	<cfset loc.value = $formValue(argumentCollection=arguments)>
	<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
		<cfset loc.value = obfuscateParam(loc.value)>
	</cfif>

	<cfsavecontent variable="loc.output">
		<cfoutput>
			<cfif isQuery(arguments.options)>
				<cfloop query="arguments.options">
					<cfset loc.optionValue = arguments.options[arguments.valueField][currentrow]>
					<cfset loc.optionText = arguments.options[arguments.textField][currentrow]>
					<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			<cfelseif isStruct(arguments.options)>
				<cfloop collection="#arguments.options#" item="loc.i">
					<cfset loc.optionValue = loc.i>
					<cfset loc.optionText = arguments.options[loc.i]>
					<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			<cfelseif isArray(arguments.options)>
				<cfloop from="1" to="#arrayLen(arguments.options)#" index="loc.i">
					<cfset loc.optionValue = loc.i>
					<cfset loc.optionText = arguments.options[loc.i]>
					<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			<cfelse>
				<cfloop list="#arguments.options#" index="loc.i">
					<cfset loc.optionValue = loc.i>
					<cfset loc.optionText = loc.i>
					<cfif application.settings.obfuscateURLs AND StructKeyExists(request.wheels, "currentFormMethod") AND request.wheels.currentFormMethod IS "get">
						<cfset loc.optionValue = obfuscateParam(loc.optionValue)>
					</cfif>
					<option value="#loc.optionValue#"<cfif listFindNoCase(loc.value, loc.optionValue) IS NOT 0> selected="selected"</cfif>>#loc.optionText#</option>
				</cfloop>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfreturn $trimHTML(loc.output)>
</cffunction>

<cffunction name="$formValue" returntype="any" access="private" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var loc = {}>

	<cfif Len(arguments.objectName) IS NOT 0>
		<!--- this is a form field for a model object --->
		<cfset loc.object = evaluate(arguments.objectName)>
		<cfif StructKeyExists(loc.object, arguments.property)>
			<cfset loc.value = loc.object[arguments.property]>
		<cfelse>
			<cfset loc.value = "">
		</cfif>
	<cfelse>
		<cfset loc.value = arguments.value>
	</cfif>

	<cfreturn loc.value>
</cffunction>

<cffunction name="$formHasError" returntype="any" access="private" output="false">
	<cfargument name="objectName" type="any" required="false" default="">
	<cfargument name="property" type="any" required="false" default="">
	<cfargument name="name" type="any" required="false" default="">
	<cfargument name="value" type="any" required="false" default="">
	<cfset var loc = {}>

	<cfif Len(arguments.objectName) IS NOT 0>
		<!--- this is a form field for a model object --->
		<cfset loc.object = evaluate(arguments.objectName)>
		<cfset loc.error = ArrayLen(loc.object.errorsOn(arguments.property))>
	<cfelse>
		<cfset loc.error = false>
	</cfif>

	<cfreturn loc.error>
</cffunction>

<cffunction name="$formBeforeElement" returntype="any" access="private" output="false">
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
	<cfset var loc = {}>

	<cfset loc.output = "">
	<cfif $formHasError(argumentCollection=arguments)>
		<cfset loc.output = loc.output & "<#arguments.errorElement# class=""field-with-errors"">">
	</cfif>

	<cfif Len(arguments.label) IS NOT 0>
		<cfset loc.output = loc.output & arguments.prependToLabel>
		<cfif Len(arguments.objectName) IS NOT 0>
			<cfset loc.output = loc.output & "<label for=""#listLast(arguments.objectName,'.')#-#arguments.property#""">
		<cfelse>
			<cfset loc.output = loc.output & "<label for=""#arguments.name#""">
		</cfif>
		<cfloop collection="#arguments#" item="loc.i">
			<cfif Left(loc.i, 5) IS "label" AND Len(loc.i) GT 5>
				<cfset loc.output = loc.output & " #replace(loc.i, 'label', '')#=""#arguments[loc.i]#""">
			</cfif>
		</cfloop>
		<cfset loc.output = loc.output & ">" & arguments.label>
		<cfif NOT arguments.wrapLabel>
			<cfset loc.output = loc.output & "</label>" & arguments.appendToLabel>
		</cfif>
	</cfif>
	<cfset loc.output = loc.output & arguments.prepend>

	<cfreturn loc.output>
</cffunction>

<cffunction name="$formAfterElement" returntype="any" access="private" output="false">
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
	<cfset var loc = {}>

	<cfset loc.output = "">
	<cfset loc.output = loc.output & arguments.append>
	<cfif Len(arguments.label) IS NOT 0>
		<cfif arguments.wrapLabel>
			<cfset loc.output = loc.output & "</label>">
			<cfset loc.output = loc.output & arguments.appendToLabel>
		</cfif>
	</cfif>
	<cfif $formHasError(argumentCollection=arguments)>
		<cfset loc.output = loc.output & "</#arguments.errorElement#>">
	</cfif>

	<cfreturn loc.output>
</cffunction>

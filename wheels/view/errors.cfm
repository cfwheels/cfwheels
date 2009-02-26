<cffunction name="errorMessagesFor" returntype="string" access="public" output="false" hint="Builds and returns a list (`ul` tag with a class of `error-messages`) containing all the error messages for all the properties of the object.">
	<cfargument name="objectName" type="string" required="true" hint="The variable name of the object to display error messages for">
	<cfset var loc = {}>
	<cfif NOT StructKeyExists(arguments, "class")>
		<cfset arguments.class = "error-messages">
	</cfif>
	<cfset arguments.$namedArguments = "objectName">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset loc.object = evaluate(arguments.objectName)>
	<cfset loc.errors = loc.object.allErrors()>
	<cfset loc.output = "">

	<cfif NOT ArrayIsEmpty(loc.errors)>
		<cfsavecontent variable="loc.output">
			<cfoutput>
				<ul#loc.attributes#>
					<cfloop from="1" to="#arrayLen(loc.errors)#" index="loc.i">
						<li>#loc.errors[loc.i].message#</li>
					</cfloop>
				</ul>
			</cfoutput>
		</cfsavecontent>
	</cfif>

	<cfreturn $trimHTML(loc.output)>
</cffunction>

<cffunction name="errorMessageOn" returntype="string" access="public" output="false" hint="Returns the error message, if one exists, on the object's property.">
	<cfargument name="objectName" type="string" required="true" hint="The variable name of the object to display the error message for">
	<cfargument name="property" type="string" required="true" hint="The name of the property (database column) to display the error message for">
	<cfargument name="prependText" type="string" required="false" default="" hint="String to prepend to the error message">
	<cfargument name="appendText" type="string" required="false" default="" hint="String to append to the error message">
	<cfargument name="wrapperElement" type="string" required="false" default="div" hint="HTML element to wrap the error message in">
	<cfset var loc = {}>
	<cfif NOT StructKeyExists(arguments, "class")>
		<cfset arguments.class = "error-message">
	</cfif>
	<cfset arguments.$namedArguments = "objectName,property,prependText,appendText,wrapperElement">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset loc.object = evaluate(arguments.objectName)>
	<cfset loc.error = loc.object.errorsOn(arguments.property)>
	<cfset loc.output = "">

	<cfif NOT IsBoolean(loc.error)>
		<cfsavecontent variable="loc.output">
			<cfoutput>
				<#arguments.wrapperElement##loc.attributes#>#arguments.prependText##loc.error[1]##arguments.appendText#</#arguments.wrapperElement#>
			</cfoutput>
		</cfsavecontent>
	</cfif>

	<cfreturn $trimHTML(loc.output)>
</cffunction>
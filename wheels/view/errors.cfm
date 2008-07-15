<cffunction name="errorMessagesFor" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfset var loc = {}>
	<cfif NOT StructKeyExists(arguments, "class")>
		<cfset arguments.class = "error-messages">
	</cfif>
	<cfset arguments.$namedArguments = "objectName">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset loc.object = evaluate(arguments.objectName)>
	<cfset loc.errors = loc.object.allErrors()>
	<cfset loc.output = "">

	<cfif isArray(loc.errors)>
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

<cffunction name="errorMessageOn" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="any" required="true">
	<cfargument name="prependText" type="any" required="false" default="">
	<cfargument name="appendText" type="any" required="false" default="">
	<cfargument name="wrapperElement" type="any" required="false" default="div">
	<cfset var loc = {}>
	<cfif NOT StructKeyExists(arguments, "class")>
		<cfset arguments.class = "error-message">
	</cfif>
	<cfset arguments.$namedArguments = "objectName,property,prependText,appendText,wrapperElement">
	<cfset loc.attributes = $getAttributes(argumentCollection=arguments)>

	<cfset loc.object = evaluate(arguments.objectName)>
	<cfset loc.error = loc.object.errorsOn(arguments.property)>
	<cfset loc.output = "">

	<cfif NOT isBoolean(loc.error)>
		<cfsavecontent variable="loc.output">
			<cfoutput>
				<#arguments.wrapperElement##loc.attributes#>#arguments.prependText##loc.error[1]##arguments.appendText#</#arguments.wrapperElement#>
			</cfoutput>
		</cfsavecontent>
	</cfif>

	<cfreturn $trimHTML(loc.output)>
</cffunction>
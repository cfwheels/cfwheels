<cffunction name="errorMessagesFor" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfset var local = structNew()>
	<cfif NOT structKeyExists(arguments, "class")>
		<cfset arguments.class = "error-messages">
	</cfif>
	<cfset arguments._named_arguments = "objectName">
	<cfset local.attributes = _getAttributes(argumentCollection=arguments)>

	<cfset local.object = evaluate(arguments.objectName)>
	<cfset local.errors = local.object.allErrors()>
	<cfset local.output = "">

	<cfif isArray(local.errors)>
		<cfsavecontent variable="local.output">
			<cfoutput>
				<ul#local.attributes#>
					<cfloop from="1" to="#arrayLen(local.errors)#" index="local.i">
						<li>#local.errors[local.i].message#</li>
					</cfloop>
				</ul>
			</cfoutput>
		</cfsavecontent>
	</cfif>

	<cfreturn _trimHTML(local.output)>
</cffunction>

<cffunction name="errorMessageOn" returntype="any" access="public" output="false">
	<cfargument name="objectName" type="any" required="true">
	<cfargument name="property" type="any" required="true">
	<cfargument name="prependText" type="any" required="false" default="">
	<cfargument name="appendText" type="any" required="false" default="">
	<cfargument name="wrapperElement" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfif NOT structKeyExists(arguments, "class")>
		<cfset arguments.class = "error-message">
	</cfif>
	<cfset arguments._named_arguments = "objectName,property,prependText,appendText,wrapperElement">
	<cfset local.attributes = _getAttributes(argumentCollection=arguments)>

	<cfset local.object = evaluate(arguments.objectName)>
	<cfset local.error = local.object.errorsOn(arguments.property)>
	<cfset local.output = "">

	<cfif NOT isBoolean(local.error)>
		<cfsavecontent variable="local.output">
			<cfoutput>
				<#arguments.wrapperElement##local.attributes#>#arguments.prependText##local.error[1]##arguments.appendText#</#arguments.wrapperElement#>
			</cfoutput>
		</cfsavecontent>
	</cfif>

	<cfreturn _trimHTML(local.output)>
</cffunction>
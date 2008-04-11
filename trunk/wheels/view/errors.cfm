<cffunction name="errorMessagesFor" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfset var local = structNew()>
	<cfif NOT structKeyExists(arguments, "class")>
		<cfset arguments.class = "error-messages">
	</cfif>
	<cfset arguments._named_arguments = "object_name">
	<cfset local.attributes = _getAttributes(argumentCollection=arguments)>

	<cfset local.object = evaluate(arguments.object_name)>
	<cfset local.errors = local.object.allErrors()>
	<cfset local.output = "">

	<cfif isArray(local.errors)>
		<cfsavecontent variable="local.output">
			<cfoutput>
				<ul#local.attributes#>
					<cfloop from="1" to="#arrayLen(local.errors)#" index="local.i">
						<li>#local.errors[local.i]#</li>
					</cfloop>
				</ul>
			</cfoutput>
		</cfsavecontent>
	</cfif>

	<cfreturn _trimHTML(local.output)>
</cffunction>


<cffunction name="errorMessageOn" returntype="any" access="public" output="false">
	<cfargument name="object_name" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfargument name="prepend_text" type="any" required="false" default="">
	<cfargument name="append_text" type="any" required="false" default="">
	<cfargument name="wrapper_element" type="any" required="false" default="div">
	<cfset var local = structNew()>
	<cfif NOT structKeyExists(arguments, "class")>
		<cfset arguments.class = "error-message">
	</cfif>
	<cfset arguments._named_arguments = "object_name,field,prepend_text,append_text,wrapper_element">
	<cfset local.attributes = _getAttributes(argumentCollection=arguments)>

	<cfset local.object = evaluate(arguments.object_name)>
	<cfset local.error = local.object.errorsOn(arguments.field)>
	<cfset local.output = "">

	<cfif NOT isBoolean(local.error)>
		<cfsavecontent variable="local.output">
			<cfoutput>
				<#arguments.wrapper_element##local.attributes#>#arguments.prepend_text##local.error[1]##arguments.append_text#</#arguments.wrapper_element#>
			</cfoutput>
		</cfsavecontent>
	</cfif>

	<cfreturn _trimHTML(local.output)>
</cffunction>
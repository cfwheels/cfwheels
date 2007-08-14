<cffunction name="saveFormToken" returntype="any" access="public" output="false">
	<cfif NOT structKeyExists(request.wheels, "form_token_created") OR NOT request.wheels.form_token_created>
		<!--- make sure only one can be created for each request --->
		<cfset session.wheels.form_token = createUUID()>
		<cfset request.wheels.form_token_created = true>
	</cfif>
</cffunction>

<cffunction name="clearFormToken" returntype="any" access="public" output="false">
	<cfset request.wheels.form_token_created = false>
	<cfset session.wheels.form_token = "">
</cffunction>

<cffunction name="getFormToken" returntype="any" access="public" output="false">
	<cfif structKeyExists(session.wheels, "form_token")>
		<cfreturn session.wheels.form_token>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name="isFormTokenValid" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="false" default="token">
	<cfif structKeyExists(params, arguments.name) AND session.wheels.form_token IS params[arguments.name]>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>
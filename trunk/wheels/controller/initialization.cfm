<cffunction name="FL_initController" returntype="any" access="public" output="false">
	<cfargument name="params" type="any" required="true">

	<cfset variables.params = arguments.params>
	<cfset variables.verifications = arrayNew(1)>
	<cfset variables.before_filters = arrayNew(1)>
	<cfset variables.after_filters = arrayNew(1)>
	<cfset variables.cachable_requests = arrayNew(1)>
	<cfset variables.cachable_actions = arrayNew(1)>

	<cfif structKeyExists(variables, "init")>
		<cfset init()>
	</cfif>

	<cfif application.settings.environment IS "design">
		<cfif NOT fileExists(expandPath("views/helpers/application_helpers.cfm"))>
			<cffile action="write" file="#expandPath('views/helpers/application_helpers.cfm')#" output="" addnewline="false">
		</cfif>
		<cfif NOT fileExists(expandPath("views/helpers/#params.controller#_helpers.cfm"))>
			<cffile action="write" file="#expandPath('views/helpers/#params.controller#_helpers.cfm')#" output="" addnewline="false">
		</cfif>
	</cfif>

	<cfinclude template="../../views/helpers/application_helpers.cfm">
	<cfinclude template="../../views/helpers/#params.controller#_helpers.cfm">

	<cfreturn this>
</cffunction>
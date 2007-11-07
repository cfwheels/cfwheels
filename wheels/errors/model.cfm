<!--- no datasource set by the developer --->
<cfif NOT structKeyExists(application.wheels, "database")>
	<cfset local.CFW_error = "Datasource not loaded">
	<cfset local.CFW_suggestion = "Add a datasource with the name <tt>#application.settings.dsn#</tt> in the ColdFusion Administrator unless you've already done so. If you have already set a datasource with this name it will be picked up by Wheels if you issue a <tt>?reload=true</tt> request (or when you restart the ColdFusion service).">
	<cfthrow type="wheels" extendedinfo="Model" message="#local.CFW_error#" detail="#local.CFW_suggestion#">
</cfif>
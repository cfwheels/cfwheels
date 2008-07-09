<!--- no datasource set by the developer --->
<cfif NOT structKeyExists(application.wheels, "adapter")>
	<cfset locals._error = "Datasource not loaded">
	<cfset locals._suggestion = "Add a datasource with the name <tt>#application.settings.database.datasource#</tt> in the ColdFusion Administrator unless you've already done so. If you have already set a datasource with this name it will be picked up by Wheels if you issue a <tt>?reload=true</tt> request (or when you restart the ColdFusion service).">
	<cfthrow type="wheels" extendedinfo="Model" message="#locals._error#" detail="#locals._suggestion#">
</cfif>
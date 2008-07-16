<!--- no datasource set by the developer --->
<cfif NOT StructKeyExists(application.wheels, "adapter")>
	<cfset loc.$error = "Datasource not loaded">
	<cfset loc.$suggestion = "Add a datasource with the name <tt>#application.settings.database.datasource#</tt> in the ColdFusion/Railo Administrator unless you've already done so. If you have already set a datasource with this name it will be picked up by Wheels if you issue a <tt>?reload=true</tt> request (or when you restart the ColdFusion/Railo service).">
	<cfthrow type="Wheels" message="#loc.$error#" extendedInfo="#loc.$suggestion#">
</cfif>
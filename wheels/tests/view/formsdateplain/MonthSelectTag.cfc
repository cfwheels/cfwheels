<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_selected_value">
		<cfset loc.args.name = "birthday">
		<cfset loc.args.selected = 2>
		<cfset loc.args.$now = "01/31/2011">
		<cfset loc.r = loc.controller.monthSelectTag(argumentcollection=loc.args)>
		<cfset loc.e = '<option selected="selected" value="2">'>
		<cfset assert('loc.r CONTAINS loc.e')>
	</cffunction>

</cfcomponent>
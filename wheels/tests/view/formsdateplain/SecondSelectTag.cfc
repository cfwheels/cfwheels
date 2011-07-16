<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_step_argument">
		<cfset loc.args.name = "countdown">
		<cfset loc.args.selected = 15>
		<cfset loc.args.secondStep = 15>
		<cfset loc.r = loc.controller.secondSelectTag(argumentcollection=loc.args)>
		<cfset loc.e = '<option selected="selected" value="15">'>
		<cfset assert('loc.r CONTAINS loc.e')>
		<cfset loc.matches = ReMatchNoCase("\<option", loc.r)>
		<cfset assert('arraylen(loc.matches) eq 4')>
	</cffunction>

</cfcomponent>
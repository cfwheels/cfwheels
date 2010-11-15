<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>

	<cffunction name="test_set_group_once">
		<cfset loc.group = "id, firstName">
		<cfset loc.authorModel.group(loc.group)>
		<cfset assert('loc.authorModel.toQuery().group eq $listClean(loc.group)')>
	</cffunction>

	<cffunction name="test_set_group_multiple_times">
		<cfset loc.group1 = "id, firstName">
		<Cfset loc.group2 = "lastName">
		<cfset loc.authorModel.group(loc.group1).group(loc.group2)>
		<cfset assert('loc.authorModel.toQuery().group eq $listClean(ListAppend(loc.group1, loc.group2))')>
	</cffunction>

</cfcomponent>
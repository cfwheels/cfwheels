<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.profileModel = model("profile")>
	</cffunction>

	<cffunction name="test_set_select_once">
		<cfset loc.select = "id, authorid, dateofbirth, bio">
		<cfset loc.profileModel.select(loc.select)>
		<cfset assert('loc.profileModel.toQuery().select eq $listClean(loc.select)')>
	</cffunction>

	<cffunction name="test_set_select_multiple_times">
		<cfset loc.select1 = "profiles.id, authorid">
		<Cfset loc.select2 = "dateofbirth, bio">
		<cfset loc.profileModel.select(loc.select1).select(loc.select2)>
		<cfset assert('loc.profileModel.toQuery().select eq $listClean(ListAppend(loc.select1, loc.select2))')>
	</cffunction>

</cfcomponent>
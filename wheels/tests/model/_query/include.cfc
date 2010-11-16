<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>

	<cffunction name="test_set_include_once">
		<cfset loc.include = "posts">
		<cfset loc.authorModel.include(loc.include)>
		<cfset assert('loc.authorModel.toQuery().include eq $listClean(loc.include)')>
	</cffunction>

	<cffunction name="test_set_include_multiple_times">
		<cfset loc.include1 = "posts">
		<Cfset loc.include2 = "profile">
		<cfset loc.authorModel.include(loc.include1).include(loc.include2)>
		<cfset assert('loc.authorModel.toQuery().include eq $listClean(ListAppend(loc.include1, loc.include2))')>
	</cffunction>

</cfcomponent>
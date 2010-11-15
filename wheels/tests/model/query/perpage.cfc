<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.profileModel = model("profile")>
	</cffunction>

	<cffunction name="test_set_perpage">
		<cfset loc.profileModel.perPage(10)>
		<cfset assert('loc.profileModel.toQuery().perpage eq 10')>
	</cffunction>

</cfcomponent>
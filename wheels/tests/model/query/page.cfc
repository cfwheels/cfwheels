<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.profileModel = model("profile")>
	</cffunction>

	<cffunction name="test_set_page">
		<cfset loc.profileModel.page(1)>
		<cfset assert('loc.profileModel.toQuery().page eq 1')>
	</cffunction>

</cfcomponent>
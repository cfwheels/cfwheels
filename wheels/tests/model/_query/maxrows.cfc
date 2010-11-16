<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.profileModel = model("profile")>
	</cffunction>

	<cffunction name="test_set_max_rows">
		<cfset loc.profileModel.maxRows(10)>
		<cfset assert('loc.profileModel.toQuery().maxRows eq 10')>
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.profileModel = model("profile")>
	</cffunction>

	<cffunction name="test_set_distinct">
		<cfset loc.profileModel.distinct()>
		<cfset assert('loc.profileModel.toQuery().distinct eq true')>
	</cffunction>

</cfcomponent>
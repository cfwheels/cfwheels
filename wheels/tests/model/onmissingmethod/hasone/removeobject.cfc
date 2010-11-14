<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_removeObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cfset loc.profile = loc.author.profile()>
		<cftransaction action="begin">
			<cfset loc.updated = loc.author.removeProfile() />
			<cfset loc.profile.reload() />
			<cfset assert('loc.updated eq true')>
			<cfset assert('loc.profile.authorid eq ""')>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>
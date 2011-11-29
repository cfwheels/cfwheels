<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_setObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cfset loc.profile = model("profile").findOne()>
		<cftransaction action="begin">
			<cfset loc.updated = loc.author.setProfile(loc.profile) />
			<cfset assert('loc.updated eq true')>
			<cfset assert('loc.profile.authorid eq loc.author.id')>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>
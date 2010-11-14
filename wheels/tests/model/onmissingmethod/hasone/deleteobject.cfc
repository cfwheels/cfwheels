<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_deleteObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cftransaction action="begin">
			<cfset loc.updated = loc.author.deleteProfile() />
			<cfset loc.profile = loc.author.profile()>
			<cfset assert('loc.updated eq true')>
			<cfset assert('loc.profile eq false')>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>
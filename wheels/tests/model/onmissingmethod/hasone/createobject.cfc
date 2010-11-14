<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_createObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cftransaction action="begin">
			<cfset loc.profile = loc.author.createProfile(dateOfBirth="1/1/1970", bio="Some profile.") />
			<cfset assert('IsObject(loc.profile) eq true')>
			<cfset assert('loc.profile.authorid eq loc.author.id')>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>
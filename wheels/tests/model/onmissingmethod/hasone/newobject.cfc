<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>
 
 	<cffunction name="test_newObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cfset loc.profile = loc.author.newProfile() />
		<cfset assert('IsObject(loc.profile) eq true')>
		<cfset assert('loc.profile.authorid eq loc.author.id')>
	</cffunction>

</cfcomponent>
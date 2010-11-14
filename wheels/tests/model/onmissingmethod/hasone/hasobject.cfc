<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
		<cfset loc.userModel = model("user")>
	</cffunction>
 
 	<cffunction name="test_hasObject_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cfset loc.hasProfile = loc.author.hasProfile() />
		<cfset assert('loc.hasProfile eq true')>
	</cffunction>
 
 	<cffunction name="test_hasObject_valid_with_combi_key">
		<cfset loc.user = loc.userModel.findByKey(key=1)>
		<cfset loc.hasCombiKey = loc.user.hasCombiKey() />
		<cfset assert('loc.hasCombiKey eq true')>
	</cffunction>

 	<cffunction name="test_hasObject_returns_false">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cfset loc.hasProfile = loc.author.hasProfile() />
		<cfset assert('loc.hasProfile eq false')>
	</cffunction>

</cfcomponent>
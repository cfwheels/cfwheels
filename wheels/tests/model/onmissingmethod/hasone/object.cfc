<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
		<cfset loc.userModel = model("user")>
	</cffunction>
 
 	<cffunction name="test_object_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cfset loc.profile = loc.author.profile() />
		<cfset assert('IsObject(loc.profile) eq true')>
	</cffunction>
 
 	<cffunction name="test_object_valid_with_combi_key">
		<cfset loc.user = loc.userModel.findByKey(key=1)>
		<cfset loc.combiKey = loc.user.combiKey() />
		<cfset assert('IsObject(loc.combiKey) eq true')>
	</cffunction>

 	<cffunction name="test_object_returns_false">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cfset loc.profile = loc.author.profile() />
		<cfset assert('IsObject(loc.profile) eq false')>
	</cffunction>

</cfcomponent>
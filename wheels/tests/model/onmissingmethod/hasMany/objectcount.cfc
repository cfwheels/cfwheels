<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
		<cfset loc.userModel = model("user")>
	</cffunction>
 
 	<cffunction name="test_objectCount_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cfset loc.postCount = loc.author.postCount() />
		<cfset assert('loc.postCount eq 3')>
	</cffunction>
 
 	<cffunction name="test_objectCount_valid_with_combi_key">
		<cfset loc.user = loc.userModel.findByKey(key=1)>
		<cfset loc.combiKeyCount = loc.user.combiKeyCount() />
		<cfset assert('loc.combiKeyCount eq 5')>
	</cffunction>

 	<cffunction name="test_objectCount_returns_zero">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cfset loc.postCount = loc.author.postCount() />
		<cfset assert('loc.postCount eq 0')>
	</cffunction>

</cfcomponent>
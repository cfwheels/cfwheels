<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
		<cfset loc.userModel = model("user")>
	</cffunction>
 
 	<cffunction name="test_hasObjects_valid">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'Per'")>
		<cfset loc.hasPosts = loc.author.hasPosts() />
		<cfset assert('loc.hasPosts eq true')>
	</cffunction>
 
 	<cffunction name="test_hasObjects_valid_with_combi_key">
		<cfset loc.user = loc.userModel.findByKey(key=1)>
		<cfset loc.hasCombiKeys = loc.user.hasCombiKeys() />
		<cfset assert('loc.hasCombiKeys eq true')>
	</cffunction>

 	<cffunction name="test_hasObjects_returns_false">
		<cfset loc.author = loc.authorModel.findOne(where="firstName = 'James'")>
		<cfset loc.hasPosts = loc.author.hasPosts() />
		<cfset assert('loc.hasPosts eq false')>
	</cffunction>

</cfcomponent>
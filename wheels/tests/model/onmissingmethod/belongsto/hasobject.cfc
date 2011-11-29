<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.profileModel = model("profile")>
		<cfset loc.combiKeyModel = model("combiKey")>
	</cffunction>

	<cffunction name="test_hasObject_valid">
		<cfset loc.profile = loc.profileModel.findByKey(key=1)>
		<cfset loc.hasAuthor = loc.profile.hasAuthor() />
		<cfset assert('loc.hasAuthor eq true')>
	</cffunction>
 
 	<cffunction name="test_hasObject_valid_with_combi_key">
		<cfset loc.combikey = loc.combiKeyModel.findByKey(key="1,1")>
		<cfset loc.hasUser = loc.combikey.hasUser() />
		<cfset assert('loc.hasUser eq true')>
	</cffunction>

	<cffunction name="test_hasObject_returns_false">
		<cfset loc.profile = loc.profileModel.findByKey(key=2)>
		<cfset loc.hasAuthor = loc.profile.hasAuthor() />
		<cfset assert('loc.hasAuthor eq false')>
	</cffunction>

</cfcomponent>
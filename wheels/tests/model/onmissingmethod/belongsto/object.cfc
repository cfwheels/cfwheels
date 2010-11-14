<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.profileModel = model("profile")>
		<cfset loc.combiKeyModel = model("combiKey")>
	</cffunction>

	<cffunction name="test_object_valid">
		<cfset loc.profile = loc.profileModel.findByKey(key=1)>
		<cfset loc.author = loc.profile.author()>
		<cfset assert("IsObject(loc.author) eq true") />
	</cffunction>
 
 	<cffunction name="test_object_valid_with_combi_key">
		<cfset loc.combikey = loc.combiKeyModel.findByKey(key="1,1")>
		<cfset loc.user = loc.combikey.user() />
		<cfset assert('IsObject(loc.user) eq true')>
	</cffunction>
 
	<cffunction name="test_object_returns_false">
		<cfset loc.profile = loc.profileModel.findByKey(key=2)>
		<cfset loc.author = loc.profile.author()>
		<cfset assert("IsObject(loc.author) eq false") />
	</cffunction>

</cfcomponent>
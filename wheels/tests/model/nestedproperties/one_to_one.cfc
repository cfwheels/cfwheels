<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.author = model("author")>
		<cfset loc.profile = model("profile")>
		<cfset loc.testAuthor = $setTestObjects()>
	</cffunction>

	<cffunction name="test_add_child_via_object">
		<cftransaction>
			<cfset assert("loc.testAuthor.save()")>
			<cfset loc.p = loc.profile.findByKey(loc.testAuthor.profile.id)>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset assert("IsObject(loc.p)")>
	</cffunction>

	<cffunction name="test_delete_child_object_through_update">
		<cfset assert("IsObject(loc.testAuthor.profile)")>
		<cftransaction>
			<!--- Save test author with child profile and grab new profile's ID --->
			<cfset loc.testAuthor.save()>
			<cfset loc.profileID = loc.testAuthor.profile.id>
			<!--- Delete profile through nested property --->
			<cfset loc.updateStruct.profile._delete = true>
			<cfset assert("loc.testAuthor.update(properties=loc.updateStruct)")>
			<!--- Should return `false` because the record is now deleted --->
			<cfset loc.missingProfile = loc.profile.findByKey(key=loc.profileId, reload=true)>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset assert("IsBoolean(loc.missingProfile) and not loc.missingProfile")>
	</cffunction>

	<cffunction name="$setTestObjects" access="private" hint="Sets up test author and profile objects.">
		<cfset loc.a = loc.author.findOneByLastName(value="Peters", include="profile")>
		<cfset loc.bioText = "Loves learning how to write tests.">
		<cfset loc.a.profile = model("profile").new(dateOfBirth="10/02/1980 18:00:00", bio=loc.bioText)>
		<cfreturn loc.a>
	</cffunction>

</cfcomponent>
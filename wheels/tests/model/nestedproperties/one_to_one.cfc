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
			<cftransaction action="rollback">
		</cftransaction>
		<cfset assert("IsObject(loc.p)")>
	</cffunction>
	
	<cffunction name="test_delete_child_object">
		<cfset assert("IsObject(loc.testAuthor.profile)")>
		<cftransaction>
			<cfset loc.testAuthor.save()>
			<cfset loc.testAuthor.profile._delete = true>
			<cfset loc.profileID = loc.testAuthor.profile.id>
			<cfset assert("loc.testAuthor.save()")>
			<cfset loc.p = loc.profile.findByKey(loc.profileID)>
			<cftransaction action="rollback">
		</cftransaction>
		<cfset assert("not loc.p")>
	</cffunction>
	
	<cffunction name="$setTestObjects" access="private" hint="Sets up test author and profile objects.">
		<cfset loc.a = loc.author.findOneByLastName(value="Peters", include="profile")>
		<cfset loc.bioText = "Loves learning how to write tests.">
		<cfset loc.a.profile = model("profile").new(dateOfBirth="10/02/1980 18:00:00", bio=loc.bioText)>
		<cfreturn loc.a>
	</cffunction>
	
</cfcomponent>
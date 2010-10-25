<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.author = model("author")>
		<cfset loc.profile = model("profile")>
		<cfset $setTestObjects()>
		<cfset loc.testParamsStruct = $setTestParamsStruct()>
	</cffunction>
	
	<cffunction name="test_add_entire_data_set_via_create_and_struct" hint="Simulates adding an `author` and its child `profile` through a single structure passed into `author.create()`, much like what's normally done with the `params` struct.">
		<cftransaction>
			<!--- Should return `true` on successful create --->
			<cfset loc.author = loc.author.create(loc.testParamsStruct.author) />
			<cfset assert('IsObject(loc.author)')>
			<cftransaction action="rollback" />
		</cftransaction>
		<!--- Test whether profile was transformed into an object --->
		<cfset assert("IsObject(loc.author.profile)")>
		<!--- Test generated primary keys --->
		<cfset assert("IsNumeric(loc.author.id) and IsNumeric(loc.author.profile.id)")>
	</cffunction>
	
	<cffunction name="test_add_entire_data_set_via_new_and_struct" hint="Simulates adding an `author` and its child `profile` through a single structure passed into `author.new()` and saved with `author.save()`, much like what's normally done with the `params` struct.">
		<cfset loc.author = loc.author.new(loc.testParamsStruct.author)>
		<cftransaction>
			<!--- Should return `true` on successful create --->
			<cfset assert("loc.author.save()")>
			<cftransaction action="rollback" />
		</cftransaction>
		<!--- Test whether profile was transformed into an object --->
		<cfset assert("IsObject(loc.author.profile)")>
		<!--- Test generated primary keys --->
		<cfset assert("IsNumeric(loc.author.id) and IsNumeric(loc.author.profile.id)")>
	</cffunction>

	<cffunction name="test_add_child_via_object" hint="Loads an existing `author` and sets its child `profile` as an object before saving.">
		<cftransaction>
			<cfset assert("loc.testAuthor.save()")>
			<cfset loc.p = loc.profile.findByKey(loc.testAuthor.profile.id)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("IsObject(loc.p)")>
	</cffunction>
	
	<cffunction name="test_add_child_via_struct" hint="Loads an existing `author` and sets its child `profile` as a struct before saving.">
		<cftransaction>
			<cfset assert("loc.testAuthor.save()")>
			<cfset loc.testAuthor.profile = {dateOfBirth="10/02/1980 18:00:00", bio=loc.bioText}>
			<cfset assert("loc.testAuthor.save()")>
			<cfset assert("IsObject(loc.testAuthor.profile)")>
			<cfset loc.p = loc.profile.findByKey(loc.testAuthor.profile.id)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("IsObject(loc.p)")>
	</cffunction>
	
	<cffunction name="test_delete_child_through_object_property" hint="Loads an existing `author` and deletes its child `profile` by setting the `_delete` property to `true`.">
		<cftransaction>
			<cfset loc.testAuthor.save()>
			<!--- Delete profile through nested property --->
			<cfset loc.testAuthor.profile._delete = true>
			<cfset loc.profileID = loc.testAuthor.profile.id>
			<cfset assert("loc.testAuthor.save()")>
			<!--- Should return `false` because the record is now deleted --->
			<cfset loc.missingProfile = loc.profile.findByKey(key=loc.profileId, reload=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("IsBoolean(loc.missingProfile) and not loc.missingProfile")>
	</cffunction>

	<cffunction name="test_delete_child_through_struct" hint="Loads an existing `author` and deletes its child `property` by passing in a struct through `update()`.">
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

	<cffunction name="$setTestObjects" access="private" hint="Sets up test `author` and `profile` objects.">
		<cfset loc.testAuthor = loc.author.findOneByLastName(value="Peters", include="profile")>
		<cfset loc.bioText = "Loves learning how to write tests." />
		<cfset loc.testAuthor.profile = model("profile").new(dateOfBirth="10/02/1980 18:00:00", bio=loc.bioText)>
	</cffunction>
	
	<cffunction name="$setTestParamsStruct" access="private" hint="Sets up test `author` struct reminiscent of what would be passed through a form. The `author` represented here also includes a nested child `profile` struct.">
		<cfset
			loc.testParams = {
				author = {
					firstName="Brian",
					lastName="Meloche",
					profile = {
						dateOfBirth="10/02/1970 18:01:00",
						bio="Host of CFConversations, the best ColdFusion podcast out there."
					}
				}
			}
		>
		<cfreturn loc.testParams>
	</cffunction>

</cfcomponent>
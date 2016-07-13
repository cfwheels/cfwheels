<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.gallery = model("gallery")>
		<cfset loc.photo = model("photo")>
		<cfset loc.user = model("user")>
		<cfset loc.testGallery = $setTestObjects()>
	</cffunction>

	<cffunction name="test_add_children_via_object_array">
		<cftransaction>
			<cfset assert("loc.testGallery.save()")>
			<cfset loc.testGallery = loc.gallery.findOneByTitle(value="Nested Properties Gallery", include="photos")>
			<cfset assert("IsArray(loc.testGallery.photos)")>
			<cfset assert("ArrayLen(loc.testGallery.photos) eq 3")>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>

	<cffunction name="test_delete_children_via_object_array">
		<cftransaction>
			<cfset assert("loc.testGallery.save()")>
			<cfset loc.testGallery = loc.gallery.findOneByTitle(value="Nested Properties Gallery", include="photos")>
			<cfloop array="#loc.testGallery.photos#" index="loc.i">
				<cfset loc.i._delete = true>
			</cfloop>
			<cfset loc.testGallery.save()>
			<cfset assert("IsArray(loc.testGallery.photos)")>
			<cfset assert("ArrayLen(loc.testGallery.photos) eq 0")>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>

	<cffunction name="test_valid_beforeValidation_callbacks_on_children">
		<cfset assert("loc.testGallery.valid()")>
		<cfloop from="1" to="#ArrayLen(loc.testGallery.photos)#" index="loc.i">
			<cfset assert("loc.testGallery.photos[loc.i].beforeValidationCallbackRegistered")>
			<cfset assert("loc.testGallery.photos[loc.i].beforeValidationCallbackCount eq 1")>
		</cfloop>
	</cffunction>

	<cffunction name="test_valid_beforeValidation_callbacks_on_children_with_validation_error_on_parent">
		<cfset loc.testGallery.title = "">
		<cfset assert("not loc.testGallery.valid()")>
		<cfloop from="1" to="#ArrayLen(loc.testGallery.photos)#" index="loc.i">
			<cfset assert("loc.testGallery.photos[loc.i].beforeValidationCallbackRegistered")>
			<cfset assert("loc.testGallery.photos[loc.i].beforeValidationCallbackCount eq 1")>
		</cfloop>
	</cffunction>

	<cffunction name="test_save_beforeValidation_callbacks_on_children">
		<cftransaction>
			<cfset assert("loc.testGallery.save()")>
			<cfloop from="1" to="#ArrayLen(loc.testGallery.photos)#" index="loc.i">
				<cfset assert("loc.testGallery.photos[loc.i].beforeValidationCallbackRegistered")>
				<cfset assert("loc.testGallery.photos[loc.i].beforeValidationCallbackCount eq 1")>
			</cfloop>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>

	<cffunction name="test_save_beforeValidation_callbacks_on_children_with_validation_error_on_parent">
		<cfset loc.testGallery.title = "">
		<cftransaction>
			<cfset assert("not loc.testGallery.save()")>
			<cfloop from="1" to="#ArrayLen(loc.testGallery.photos)#" index="loc.i">
				<cfset assert("loc.testGallery.photos[loc.i].beforeValidationCallbackRegistered")>
				<cfset assert("loc.testGallery.photos[loc.i].beforeValidationCallbackCount eq 1")>
			</cfloop>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>

	<cffunction name="test_beforeCreate_callback_on_children">
		<cftransaction>
			<cfset loc.testGallery.save()>
			<cfloop from="1" to="#ArrayLen(loc.testGallery.photos)#" index="loc.i">
				<cfset assert("loc.testGallery.photos[loc.i].beforeCreateCallbackCount eq 1")>
			</cfloop>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>

	<cffunction name="test_beforeSave_callback_on_children">
		<cftransaction>
			<cfset loc.testGallery.save()>
			<cfloop from="1" to="#ArrayLen(loc.testGallery.photos)#" index="loc.i">
				<cfset assert("loc.testGallery.photos[loc.i].beforeSaveCallbackCount eq 1")>
			</cfloop>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>

	<cffunction name="test_afterCreate_callback_on_children">
		<cftransaction>
			<cfset loc.testGallery.save()>
			<cfloop from="1" to="#ArrayLen(loc.testGallery.photos)#" index="loc.i">
				<cfset assert("loc.testGallery.photos[loc.i].afterCreateCallbackCount eq 1")>
			</cfloop>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>

	<cffunction name="test_afterSave_callback_on_children">
		<cftransaction>
			<cfset loc.testGallery.save()>
			<cfloop from="1" to="#ArrayLen(loc.testGallery.photos)#" index="loc.i">
				<cfset assert("loc.testGallery.photos[loc.i].afterSaveCallbackCount eq 1")>
			</cfloop>
			<cftransaction action="rollback"/>
		</cftransaction>
	</cffunction>

	<cffunction name="test_parent_primary_key_rolled_back_on_parent_validation_error">
		<cfset loc.testGallery.title = "">
		<cftransaction>
			<cfset assert("not loc.testGallery.save()")>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset assert("not Len(loc.testGallery.key())")>
	</cffunction>

	<cffunction name="test_children_primary_keys_rolled_back_on_parent_validation_error">
		<cfset loc.testGallery.title = "">
		<cftransaction>
			<cfset assert("not loc.testGallery.save()")>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfloop from="1" to="#ArrayLen(loc.testGallery.photos)#" index="loc.i">
			<cfset assert("not Len(loc.testGallery.photos[loc.i].key())")>
		</cfloop>
	</cffunction>

	<cffunction name="test_parent_primary_key_rolled_back_on_child_validation_error">
		<cfset loc.testGallery.photos[2].filename = "">
		<cftransaction>
			<cfset assert("not loc.testGallery.save()")>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset assert("not Len(loc.testGallery.key())")>
	</cffunction>

	<cffunction name="test_children_primary_keys_rolled_back_on_child_validation_error">
		<cfset loc.testGallery.photos[2].filename = "">
		<cftransaction>
			<cfset assert("not loc.testGallery.save()")>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfloop from="1" to="#ArrayLen(loc.testGallery.photos)#" index="loc.i">
			<cfset assert("not Len(loc.testGallery.photos[loc.i].key())")>
		</cfloop>
	</cffunction>

	<cffunction name="$setTestObjects" access="private" hint="Sets up test gallery/gallery photo objects.">
		<!--- User --->
		<cfset loc.u = loc.user.findOneByLastName("Petruzzi")>
		<!--- Gallery --->
		<cfset loc.params = { userId=loc.u.id, title="Nested Properties Gallery", description="A gallery testing nested properties." }>
		<cfset loc.g = loc.gallery.new(loc.params)>
		<cfset loc.g.photos = [
			loc.photo.new(userId=loc.u.id, filename="Nested Properties Photo Test 1", DESCRIPTION1="test photo 1 for nested properties gallery"),
			loc.photo.new(userId=loc.u.id, filename="Nested Properties Photo Test 2", DESCRIPTION1="test photo 2 for nested properties gallery"),
			loc.photo.new(userId=loc.u.id, filename="Nested Properties Photo Test 3", DESCRIPTION1="test photo 3 for nested properties gallery")
		]>
		<cfreturn loc.g>
	</cffunction>

</cfcomponent>
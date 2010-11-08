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

	<cffunction name="$setTestObjects" access="private" hint="Sets up test gallery/gallery photo objects.">
		<!--- User --->
		<cfset loc.u = loc.user.findOneByLastName("Petruzzi")>
		<!--- Gallery --->
		<cfset loc.params = {userId=loc.u.id, title="Nested Properties Gallery", description="A gallery testing nested properties."}>
		<cfset loc.g = loc.gallery.new(loc.params)>
		<cfset
			loc.g.photos = [
				loc.photo.new(userId=loc.u.id, filename="Nested Properties Photo Test 1", DESCRIPTION1="test photo 1 for nested properties gallery"),
				loc.photo.new(userId=loc.u.id, filename="Nested Properties Photo Test 2", DESCRIPTION1="test photo 2 for nested properties gallery"),
				loc.photo.new(userId=loc.u.id, filename="Nested Properties Photo Test 3", DESCRIPTION1="test photo 3 for nested properties gallery")
			]
		>
		<cfreturn loc.g>
	</cffunction>

</cfcomponent>
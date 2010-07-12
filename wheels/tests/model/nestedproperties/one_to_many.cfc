<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.gallery = model("photoGallery")>
		<cfset loc.photo = model("photoGalleryPhoto")>
		<cfset loc.user = model("user")>
	</cffunction>
	
	<cffunction name="test_add_children_via_object_array">
		<cfset loc.g = loc.gallery.findOneByTitle("Tony Test Galllery 4")>
		<cfset loc.u = loc.user.findOneByLastName("Petruzzi")>
		<cfset
			loc.g.photoGalleryPhotos = [
				loc.photo.new(userId=loc.u.id, filename="Gallery #loc.g.photoGalleryId# Photo Test 1", DESCRIPTION1="test photo 1 for gallery #loc.g.photoGalleryId#"),
				loc.photo.new(userId=loc.u.id, filename="Gallery #loc.g.photoGalleryId# Photo Test 2", DESCRIPTION1="test photo 2 for gallery #loc.g.photoGalleryId#")
			]
		>
		<cftransaction action="begin">
			<cfset assert("loc.g.save()")>
			<cfset loc.g = loc.gallery.findOneByTitle(value="Tony Test Galllery 4", include="photoGalleryPhotos")>
			<cfset assert("IsArray(loc.g.photoGalleryPhotos)")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>
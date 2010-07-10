<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.gallery = model("photoGallery")>
		<cfset loc.photo = model("photoGalleryPhoto")>
		<cfset loc.user = model("user")>
	</cffunction>
	
	<cffunction name="test_add_children_via_structs">
		<cfset loc.g = loc.gallery.findOneByTitle("Tony Test Galllery 4")>
		<cfset loc.u = loc.user.findOneByLastName("Petruzzi")>
		<cfset
			loc.g.photoGalleryPhotos = [
				loc.photo.new(userId=loc.u.id, filename="Gallery #loc.g.photoGalleryId# Photo Test 1", description="test photo 1 for gallery #loc.g.photoGalleryId#"),
				loc.photo.new(userId=loc.u.id, filename="Gallery #loc.g.photoGalleryId# Photo Test 2", description="test photo 2 for gallery #loc.g.photoGalleryId#")
			]
		>
		<cfset assert("loc.g.save()")>
		<cfset loc.g = loc.gallery.findOneByTitle(value="Tony Test Galllery 4", include="photoGalleryPhotos")>
		<cfset assert("IsArray(loc.g.photoGalleryPhotos) and ArrayLen(loc.g.photoGalleryPhotos) eq 2")>
	</cffunction>

</cfcomponent>
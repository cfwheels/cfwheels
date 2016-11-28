component extends="wheels.tests.Test" {

	function test_gallery_has_many_photos() {
		gallery = model("GalleryNoAssociations").findOne();
		photos = gallery.photos();
		assert("IsQuery(photos)");
	}

	function test_photo_belongs_to_gallery() {
		photo = model("PhotoNoAssociations").findOne();
		gallery = photo.gallery();
		assert("IsObject(gallery)");
	}

}
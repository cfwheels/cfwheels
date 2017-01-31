component extends="Model" {

	function init() {
		belongsTo(name="user", modelName="user", foreignKey="userid");
		hasMany(name="photos", modelName="photo", foreignKey="galleryid");
		nestedProperties(associations="photos", allowDelete="true");
		validatesPresenceOf("title");
	}

}

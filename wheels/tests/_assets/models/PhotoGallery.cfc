component extends="Model" {

	function init() {
		belongsTo(name="user", modelName="user", foreignKey="userid");
		hasMany(name="photogalleryphotos", modelName="photogalleryphoto", foreignKey="photogalleryid");
		nestedProperties(associations="photogalleryphotos", allowDelete="true");
	}

}

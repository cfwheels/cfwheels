component extends="wheels.model" {

	function init() {
		property(name="DESCRIPTION1", column="description");
		belongsTo(name="photogallery", modelName="photogallery", foreignKey="photogalleryid");
	}

}

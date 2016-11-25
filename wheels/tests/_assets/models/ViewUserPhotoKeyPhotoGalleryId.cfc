component extends="Model" {

	function init() {
		table("userphotos");
		setPrimaryKey("galleryid");
		hasMany(
			name="photos"
			,modelName="photo"
			,foreignKey="galleryid"
		);
	}

}
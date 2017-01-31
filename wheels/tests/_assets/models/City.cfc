component extends="Model" {

	function init() {
		hasMany(name="shops", foreignKey="citycode");
		property(name="id", column="countyid");
	}

}

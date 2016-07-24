component extends="Model" {

	public void function init() {
		property(name="id", sql="shopid");
		setPrimaryKey("shopid");
		belongsTo(name="city", foreignKey="citycode");
	}

}

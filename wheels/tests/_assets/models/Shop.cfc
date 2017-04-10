component extends="Model" {

	public void function config() {
		property(name="id", sql="shopid");
		setPrimaryKey("shopid");
		belongsTo(name="city", foreignKey="citycode");
	}

}

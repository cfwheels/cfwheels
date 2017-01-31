component extends="Model" {

	function init() {
		hasMany(name="galleries");
		hasOne(name="combikey");
		/* crazy join to test the joinKey argument */
		hasOne(name="author", foreignKey="firstName", joinKey="firstName");
		hasMany(name="authors", foreignKey="firstName", joinKey="firstName");
		hasMany(name="combikeys");
		hasMany(name="outerjoinphotogalleries", modelName="gallery", jointype="outer");
		validatesPresenceOf("username,password,firstname,lastname");
		validatesUniquenessOf("username");
		validatesLengthOf(property="username", minimum="4", maximum="20", when="onCreate", message="Please shorten your [property] please. [maximum] characters is the maximum length allowed.");
		validatesLengthOf(property="password", minimum="4", when="onUpdate");
		validate("validateCalled");
		validateOnCreate("validateOnCreateCalled");
		validateOnUpdate("validateOnUpdateCalled");
	}

	function validateCalled() {
		this._validateCalled = true;
	}

	function validateOnCreateCalled() {
		this._validateOnCreateCalled = true;
	}

	function validateOnUpdateCalled() {
		this._validateOnUpdateCalled = true;
	}

}
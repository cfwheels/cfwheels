component extends="Model" {

	function init() {
		table("tags");
		afterSave("callbackThatReturnsFalse");
		afterDelete("callbackThatReturnsFalse");
	}

	function callbackThatReturnsFalse() {
		return false;
	}

}
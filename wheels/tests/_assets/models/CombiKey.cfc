component extends="Model" {

	function init() {
		belongsTo("User");
    validatesPresenceOf("id1,id2");
    validatesUniquenessOf(property="id1", scope="id2");
	}

}

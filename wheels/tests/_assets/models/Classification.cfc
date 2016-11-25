component extends="Model" {

	function init() {
		belongsTo("post");
		belongsTo("tag");
	}

}

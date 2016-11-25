component extends="Model" {

	function init() {
		table("photos");
		property(name="DESCRIPTION1", column="description");
		property(name="photoid", column="id");
	}

}

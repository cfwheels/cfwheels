component extends="Model" {

	function config() {
		settablenameprefix("tbl");
		table("users");
		property(name = "firstLetter", sql = "SUBSTRING(tblusers.username, 1, 1)");
		property(name = "groupCount", sql = "COUNT(tblusers.id)");
	}

}

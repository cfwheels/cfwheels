component extends="Model" {

	function config() {
		settablenameprefix("tbl");
		table("users");
		local.db_info = $dbinfo(datasource=application.wheels.dataSourceName, type="version");
		local.db = LCase(Replace(local.db_info.database_productname, " ", "", "all"));
		if (local.db IS "oracle") {
			property(name="firstLetter", sql="SUBSTR(tblusers.username, 1, 1)");
		} else {
			property(name="firstLetter", sql="SUBSTRING(tblusers.username, 1, 1)");
		}
		property(name="groupCount", sql="COUNT(tblusers.id)");
	}

}

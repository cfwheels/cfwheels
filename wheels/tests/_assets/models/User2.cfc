component extends="Model" {

	function init() {
		settablenameprefix("tbl");
		table("users");
		include "dbinfo.cfm";
		db = LCase(Replace(db_info.database_productname, " ", "", "all"));
		if (db IS "oracle") {
			property(name="firstLetter", sql="SUBSTR(tblusers.username, 1, 1)");
		} else {
			property(name="firstLetter", sql="SUBSTRING(tblusers.username, 1, 1)");
		}
		property(name="groupCount", sql="COUNT(tblusers.id)");
	}

}

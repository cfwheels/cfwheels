/*
  |----------------------------------------------------------------------------------------------|
	| Parameter  | Required | Type    | Default | Description                                      |
  |----------------------------------------------------------------------------------------------|
	| oldName    | Yes      | string  |         | existing table name                              |
	| newName    | Yes      | string  |         | new table name                              		 |
  |----------------------------------------------------------------------------------------------|

    EXAMPLE:
      renameTable(oldName='employees', newName='users');
*/
component extends="[extends]" hint="[description]" {

	function up() {
	  hasError = false;
		transaction {
			try {
				renameTable(oldName='', newName='');
			} catch (any ex) {
				hasError = true;
				catchObject = ex;
			}

			if (!hasError) {
				transaction action="commit";
			} else {
				transaction action="rollback";
				throw(errorCode="1", detail=catchObject.detail, message=catchObject.message, type="any");
			}
		}
	}

	function down() {
	  hasError = false;
		transaction {
			try {
				renameTable(oldName='', newName='');
			} catch (any ex) {
				hasError = true;
				catchObject = ex;
			}

			if (!hasError) {
				transaction action="commit";
			} else {
				transaction action="rollback";
				throw(errorCode="1", detail=catchObject.detail, message=catchObject.message, type="any");
			}
		}
	}

}

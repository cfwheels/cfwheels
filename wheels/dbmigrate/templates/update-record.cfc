/*
  |-----------------------------------------------------------------------------------------------------|
	| Parameter               | Required | Type    | Default | Description                                |
  |-----------------------------------------------------------------------------------------------------|
	| table                   | Yes      | string  |         | Name of table to update records            |
	| where                   | No       | string  |         | Where condition                            |
	| one or more columnNames | No       | string  |         | Use column name as argument name and value |
  |-----------------------------------------------------------------------------------------------------|

    EXAMPLE:
      updateRecord(table='members',where='id=1',status='Active');
*/
component extends="[extends]" hint="[description]" {

	function up() {
	  hasError = false;
		transaction {
			try {
				updateRecord(table='tableName', where='');
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
				updateRecord(table='tableName', where='');
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

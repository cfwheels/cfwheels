/*
  |----------------------------------------------------------------------|
	| Parameter     | Required | Type    | Default | Description           |
  |----------------------------------------------------------------------|
	| table         | Yes      | string  |         | existing table name   |
	| columnName    | Yes      | string  |         | existing column name  |
	| newColumnName | No       | string  |         | new name for column   |
  |----------------------------------------------------------------------|

    EXAMPLE:
      renameColumn(table='users', columnName='password', newColumnName='');
*/
component extends="[extends]" hint="[description]" {

	function up() {
	  local.hasError = false;
		transaction {
			try {
				renameColumn(table='tableName', columnName='columnName', newColumnName='newColumnName');
			} catch (any e) {
				local.hasError = true;
				catchObject = e;
			}

			if (!local.hasError) {
				transaction action="commit";
			} else {
				transaction action="rollback";
				throw(errorCode="1", detail=catchObject.detail, message=catchObject.message, type="any");
			}
		}
	}

	function down() {
	  local.hasError = false;
		transaction {
			try {
				renameColumn(table='tableName', columnName='columnName', newColumnName='newColumnName');
			} catch (any e) {
				local.hasError = true;
				catchObject = e;
			}

			if (!local.hasError) {
				transaction action="commit";
			} else {
				transaction action="rollback";
				throw(errorCode="1", detail=catchObject.detail, message=catchObject.message, type="any");
			}
		}
	}

}

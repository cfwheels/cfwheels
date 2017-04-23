/*
  |----------------------------------------------------------------------------------------------|
	| Parameter  | Required | Type    | Default | Description                                      |
  |----------------------------------------------------------------------------------------------|
	| name       | Yes      | string  |         | existing table name                              |
	|----------------------------------------------------------------------------------------------|

    EXAMPLE:
      t = changeTable(name='employees');
      t.string(columnNames="fullName", default="", null=true, limit="255");
      t.change();
*/
component extends="[extends]" hint="[description]" {

	function up() {
	  local.hasError = false;
		transaction {
			try {
				t = changeTable('tableName');
	   		t.change();
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
				removeColumn(table='tableName', columnName='columnName');
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

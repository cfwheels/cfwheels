/*
  |----------------------------------------------------------------------------|
	| Parameter     | Required | Type    | Default | Description                 |
  |----------------------------------------------------------------------------|
	| table         | Yes      | string  |         | table name                  |
	| indexName     | Yes      | string  |         | name of the index to remove |
  |----------------------------------------------------------------------------|

    EXAMPLE:
      removeIndex(table='members',indexName='members_username');
*/
component extends="[extends]" hint="[description]" {

	function up() {
	  local.hasError = false;
		transaction {
			try {
				removeIndex(table='tableName', indexName='');
			}
			catch (any e) {
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
				addIndex(table='tableName', columnNames='columnName', unique=true);
			}
			catch (any e) {
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

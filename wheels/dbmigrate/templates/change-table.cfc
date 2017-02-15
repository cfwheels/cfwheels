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
	  	hasError = false;
		transaction {
		  	try{
				t = changeTable('tableName');
	   			t.change();
			}
			catch (any ex){
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
		  	try{
				removeColumn(table='tableName',columnName='columnName');
			}
			catch (any ex){
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

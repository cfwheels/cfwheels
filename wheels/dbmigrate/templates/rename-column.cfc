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

	function up(){
	  	hasError = false;
		transaction {
		  	try{
				renameColumn(table='tableName', columnName='columnName', newColumnName='newColumnName');
			}
			catch (any ex){
				hasError = true;
				catchObject = ex;
			}

			if (!hasError) {
				transaction action="commit";
			else {
				transaction action="rollback";
				throw(errorCode="1" detail=catchObject.detail message=catchObject.message type="any");
			}
		}
	}

	function down(){
	  	hasError = false;
		transaction {
		  	try{
				renameColumn(table='tableName', columnName='columnName', newColumnName='newColumnName');
			}
			catch (any ex){
				hasError = true;
				catchObject = ex;
			}

			if (!hasError) {
				transaction action="commit";
			else {
				transaction action="rollback";
				throw(errorCode="1" detail=catchObject.detail message=catchObject.message type="any");
			}
		}
	}

}

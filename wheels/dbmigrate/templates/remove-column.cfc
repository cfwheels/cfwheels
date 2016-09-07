/*
    |-------------------------------------------------------------------------------------------------|
	| Parameter     | Required | Type    | Default | Description                                      |
    |-------------------------------------------------------------------------------------------------|
	| table         | Yes      | string  |         | existing table name                              |
	| columnName    | No       | string  |         | existing column name                             |
	| referenceName | No       | string  |         | name of reference that was used to create column |
    |-------------------------------------------------------------------------------------------------|

    EXAMPLE:
      removeColumn(table='members',columnName='status');
*/
component extends="[extends]" hint="[description"] {

	function up(){
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
				addColumn(table='tableName', columnType='', columnName='columnName', default='', null=true);
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

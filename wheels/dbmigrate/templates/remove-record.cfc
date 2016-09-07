/*
    |-------------------------------------------------------------------------------------------|
	| Parameter     | Required | Type    | Default | Description                                |
    |-------------------------------------------------------------------------------------------|
	| table         | Yes      | string  |         | Name of table to remove records from       |
	| where         | No       | string  |         | Where condition                            |
    |-------------------------------------------------------------------------------------------|

    EXAMPLE:
      removeRecord(table='members',where='id=1');
*/
component extends="[extends]" hint="[description"] {

	function up(){
	  	hasError = false;
		transaction {
		  	try{
				removeRecord(table='tableName',where='');
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
				addRecord(table='tableName',field='');
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

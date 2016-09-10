/*
    |----------------------------------------------------------------------------------------------|
	| Parameter  | Required | Type    | Default | Description                                      |
    |----------------------------------------------------------------------------------------------|
	| name       | Yes      | string  |         | table name to drop                               |
    |----------------------------------------------------------------------------------------------|

    EXAMPLE:
      dropTable(name='employees');
*/
component extends="[extends]" hint="[description]" {

	function up(){
	  	hasError = false;
		transaction {
		  	try{
				dropTable(name='tableName');
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
				t = createTable(name='tableName');
			    t.timestamps();
			    t.create();
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

/*
    |----------------------------------------------------------------------------------------------------------------------------|
	| Parameter     | Required | Type    | Default | Description                                                                 |
    |----------------------------------------------------------------------------------------------------------------------------|
	| table         | Yes      | string  |         | table name                                                                  |
	| columnNames   | Yes      | string  |         | one or more column names to index, comma separated                          |
	| unique        | No       | boolean |  false  | if true will create a unique index constraint                               |
	| indexName     | No       | string  |         | use for index name. Defaults to table name + underscore + first column name |
    |----------------------------------------------------------------------------------------------------------------------------|

    EXAMPLE:
      addIndex(table='members',columnNames='username',unique=true);
*/
component extends="[extends]" hint="[description]" {

	function up() {
	  	hasError = false;
		transaction {
		  	try{
				addIndex(table='tableName',columnNames='columnName',unique=true);
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
				removeIndex(table='tableName', indexName='');
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

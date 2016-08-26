<cfscript>
  private void function $createTable() {
    t = migration.createTable('dbmigrationtabletests');
		t.string(columnNames='stringcolumn', limit=255);
		t.text(columnNames='textcolumn');
		t.boolean(columnNames='booleancolumn', default=false, null=false);
		t.integer(columnNames='integercolumn', default=0);
		// t.bigInteger(columnNames="bigintegercolumn", default=0); // TODO: implement this datatype
		t.binary(columnNames="binarycolumn");
		t.date(columnNames="datecolumn");
		t.dateTime(columnNames="datetimecolumn");
		t.time(columnNames="timecolumn");
		t.decimal(columnNames="decimalcolumn");
		t.float(columnNames="floatcolumn");
		t.char(columnNames="charcolumn");
		t.uniqueIdentifier(columnNames="uniqueidentifiercolumn");
		t.timeStamps();
		t.create();
  }

  private void function $dropTable() {
    migration.dropTable('dbmigrationtabletests');
  }
</cfscript>

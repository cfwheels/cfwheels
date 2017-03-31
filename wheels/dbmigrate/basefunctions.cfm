<cfscript>
if(!StructKeyExists(variables, "$wddx")){
	include "../global/functions.cfm";
}

public function announce(required string message) {
	param name="request.$wheelsMigrationOutput" default="";
	request.$wheelsMigrationOutput = request.$wheelsMigrationOutput & arguments.message & chr(13);
}

private string function $getForeignKeys(required string table) {
	local.foreignKeyList = "";
	local.tables = $dbinfo(type="tables", datasource=application.wheels.dataSourceName,username=application.wheels.dataSourceUserName,password=application.wheels.dataSourcePassword);
	if (ListFindNoCase(ValueList(local.tables.table_name), arguments.table)) {
		local.foreignKeys = $dbinfo(type="foreignkeys",table=arguments.table,datasource=application.wheels.dataSourceName,username=application.wheels.dataSourceUserName,password=application.wheels.dataSourcePassword);
		local.foreignKeyList = ValueList(local.foreignKeys.FKCOLUMN_NAME);
	}
	return local.foreignKeyList;
}

private void function $execute(required string sql) {
	// trim and remove trailing semicolon (appears to cause problems for Oracle thin client JDBC driver)
	arguments.sql = REReplace(trim(arguments.sql),";$","","ONE");
	if (StructKeyExists(request, "$wheelsMigrationSQLFile") && application.wheels.dbmigrateWriteSQLFiles) {
		$file(action="append", file=request.$wheelsMigrationSQLFile, output="#arguments.sql#;", addNewLine="yes", fixNewLine="yes");
	}
	$query(datasource=application.wheels.dataSourceName, sql=arguments.sql);
}

public string function $getColumns(required string tableName) {
	if ($get("adapterName") eq "Oracle") {
		// oracle thin client jdbc throws error when usgin cfdbinfo to access column data
		// because of this error wheels can't load models anyway so maybe we don't need to support this driver
		local.columns = $query(
			datasource=application.wheels.dataSourceName,
			username=application.wheels.dataSourceUserName,
			password=application.wheels.dataSourcePassword,
			sql="SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '#ucase(this.name)#'"
		);
	} else {
		local.columns = $dbinfo(
			datasource=application.wheels.dataSourceName,
			username=application.wheels.dataSourceUserName,
			password=application.wheels.dataSourcePassword,
			type="columns",
			table=arguments.tableName
		);
	}
	return ValueList(local.columns.COLUMN_NAME);
}

private string function $getColumnDefinition(required string tableName, required string columnName) {
	local.columns = $dbinfo(
		datasource=application.wheels.dataSourceName,
		username=application.wheels.dataSourceUserName,
		password=application.wheels.dataSourcePassword,
		type="columns",
		table=arguments.tableName
	);
	local.columnDefinition = "";
	local.iEnd = local.columns.RecordCount;
	for (local.i = 1; local.i <= local.iEnd; local.i++) {
		if(local.columns["COLUMN_NAME"][local.i] == arguments.columnName) {
			local.columnType = local.columns["TYPE_NAME"][local.i];
			local.columnDefinition = local.columnType;
			if(ListFindNoCase("char,varchar,int,bigint,smallint,tinyint,binary,varbinary",local.columnType)) {
				local.columnDefinition = local.columnDefinition & "(#local.columns["COLUMN_SIZE"][local.i]#)";
			} else if(ListFindNoCase("decimal,float,double",local.columnType)) {
				local.columnDefinition = local.columnDefinition & "(#local.columns["COLUMN_SIZE"][local.i]#,#local.columns["DECIMAL_DIGITS"][local.i]#)";
			}
			if(local.columns["IS_NULLABLE"][local.i]) {
				local.columnDefinition = local.columnDefinition & " NULL";
			} else {
				local.columnDefinition = local.columnDefinition & " NOT NULL";
			}
			if(Len(local.columns["COLUMN_DEFAULT_VALUE"][local.i]) == 0) {
				local.columnDefinition = local.columnDefinition & " DEFAULT NULL";
			} else if(ListFindNoCase("char,varchar,binary,varbinary",local.columnType)) {
				local.columnDefinition = local.columnDefinition & " DEFAULT '#local.columns["COLUMN_DEFAULT_VALUE"][local.i]#'";
			} else if(ListFindNoCase("int,bigint,smallint,tinyint,decimal,float,double",local.columnType)) {
				local.columnDefinition = local.columnDefinition & " DEFAULT #local.columns["COLUMN_DEFAULT_VALUE"][local.i]#";
			}
			break;
		}
	}
	return local.columnDefinition;
}

/**
* Applies case to database objects according to settings
* Note: some db engines use only lower case, TODO: perhaps add certain adapters to these conditions?
*/
private string function objectCase(required string name) {
	if (application.wheels.dbmigrateObjectCase eq "lower") {
		return LCase(arguments.name);
	} else if (application.wheels.dbmigrateObjectCase eq "upper") {
		return UCase(arguments.name);
	} else {
		// use the object name unmolested
		return arguments.name;
	}
}
</cfscript>

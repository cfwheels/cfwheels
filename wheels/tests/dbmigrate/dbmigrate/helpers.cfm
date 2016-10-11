<cfscript>
  public any function $cleanSqlDirectory() {
    local.path = dbmigrate.paths.sql;
    if (DirectoryExists(local.path)) {
      DirectoryDelete(local.path, true);
    }
  }

  // Quick helper to help split out Oracle tests
  public any function $isOracle() {
    local.db=$dbinfo(datasource=application.wheels.dataSourceName, type="version");
    if(local.db.database_productname == "Oracle"){
    	return true;
    } else {
    	return false;
    }
  }
</cfscript>

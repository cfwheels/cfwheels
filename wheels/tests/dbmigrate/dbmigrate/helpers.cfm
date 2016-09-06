<cfscript>
  public any function $cleanSqlDirectory() {
    local.path = dbmigrate.paths.sql;
    if (DirectoryExists(local.path)) {
      directoryDelete(local.path, true);
    }
    directoryCreate(local.path);
  }
</cfscript>

<cfscript>
  public any function $cleanSqlDirectory() {
    local.path = dbmigrate.paths.sql;
    if (DirectoryExists(local.path)) {
      DirectoryDelete(local.path, true);
    }
  }
</cfscript>

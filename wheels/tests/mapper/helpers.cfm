<cfscript>
/**
* HELPERS
*/

  public void function teardown() {
    application[$appKey()].routes = _originalRoutes;
  }

  public Mapper function $mapper() {
    local.args = duplicate(config);
    structAppend(local.args, arguments, true);
    return $createObjectFromRoot(argumentCollection=local.args);
  }

  public struct function $inspect() {
    return variables;
  }

  public void function $clearRoutes() {
    application[$appKey()].routes = [];
  }

  public void function $dump() {
    teardown();
    super.$dump(argumentCollection=arguments);
  }

</cfscript>

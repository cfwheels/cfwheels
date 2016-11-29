<cfscript>

  // PUBLIC UTILITIES

  public string function normalizePattern(required string pattern) {

    local.pattern = REReplace(arguments.pattern, "(^/+|/+$)", "", "ALL");
    local.pattern = REReplace(local.pattern, "/+\.", ".", "ALL");
    return "/" & Replace(local.pattern, "//", "/", "ALL");
  }

  public string function patternToRegex(
    required string pattern, struct constraints={})
    hint="Transform route pattern into regular expression" {

    // escape any dots in pattern, and further mask pattern variables
    // NOTE: this keeps constraint patterns from being replaced twice
    local.regex = REReplace(arguments.pattern, "([.])", "\\1", "ALL");
    local.regex = REReplace(local.regex, "\[(\*?\w+)\]", ":::\1:::", "ALL");

    // replace known variable keys using constraints
    local.constraints = StructCopy(arguments.constraints);
    StructAppend(local.constraints, variables.constraints, false);
    for (local.key in local.constraints)
      local.regex = REReplaceNoCase(
          local.regex
        , ":::#local.key#:::"
        , "(#local.constraints[local.key]#)"
        , "ALL"
      );

    // replace remaining variables with default regex
    local.regex = REReplace(local.regex, ":::\w+:::", "([^./]+)", "ALL");
    return REReplace(local.regex, "^/*(.*)/*$", "^\1/?$");
  }

  public string function stripRouteVariables(required string pattern)
    hint="Pull list of variables out of route pattern" {
    return REReplace(ArrayToList(REMatch("\[\*?(\w+)\]", arguments.pattern)), "[\*\[\]]", "", "ALL");
  }

  // PRIVATE UTILITIES

  private void function $addRoute()
    hint="Add route to cfwheels, removing useless params" {

    // remove controller and action if they are route variables
    if (Find("[controller]", arguments.pattern) AND StructKeyExists(arguments, "controller"))
      StructDelete(arguments, "controller");
    if (Find("[action]", arguments.pattern) AND StructKeyExists(arguments, "action"))
      StructDelete(arguments, "action");

    // normalize pattern, convert to regex, and strip out variable names
    arguments.pattern = normalizePattern(arguments.pattern);
    arguments.regex = patternToRegex(arguments.pattern, arguments.constraints);
    arguments.variables = stripRouteVariables(arguments.pattern);

    // add route to cfwheels
    ArrayAppend(application[$appKey()].routes, arguments);
  }

  private string function $member()
    hint="Get member name if defined" {
    return structKeyExists(scopeStack[1], "member") ? scopeStack[1].member : "";
  }

  private string function $collection()
    hint="Get collection name if defined" {
    return structKeyExists(scopeStack[1], "collection") ? scopeStack[1].collection : "";
  }

  private string function $scopeName()
    hint="Get scoped route name if defined" {
    return structKeyExists(scopeStack[1], "name") ? scopeStack[1].name : "";
  }

  private boolean function $shallow()
    hint="See if resource is shallow" {
    return structKeyExists(scopeStack[1], "shallow") && scopeStack[1].shallow == true;
  }

  private string function $shallowName()
    hint="Get scoped shallow route name if defined" {
    return structKeyExists(scopeStack[1], "shallowName") ? scopeStack[1].shallowName : "";
  }

  private string function $shallowPath()
    hint="Get scoped shallow path if defined" {
    return structKeyExists(scopeStack[1], "shallowPath") ? scopeStack[1].shallowPath : "";
  }

  private string function $shallowNameForCall() {
    if (ListFindNoCase("collection,new", scopeStack[1].$call)
        && StructKeyExists(scopeStack[1], "parentResource"))
      return ListAppend($shallowName(), scopeStack[1].parentResource.member);
    return $shallowName();
  }

  private string function $shallowPathForCall() {

    local.path = "";
    switch (scopeStack[1].$call) {
      case "member":
        local.path = scopeStack[1].memberPath;
        break;
      case "collection":
      case "new":
        if (StructKeyExists(scopeStack[1], "parentResource"))
          local.path = scopeStack[1].parentResource.nestedPath;
        local.path &= "/" & scopeStack[1].collectionPath;
        break;
    }
    return $shallowPath() & "/" & local.path;
  }

  private void function $resetScopeStack() {
    variables.scopeStack = [];
    ArrayPrepend(scopeStack, {});
    variables.scopeStack[1].$call = "draw";
  }
</cfscript>
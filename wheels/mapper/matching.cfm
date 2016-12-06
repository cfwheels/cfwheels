<cfscript>
  /**
   * Match a url
   * @param  {string} name          Name for route. Used for path helpers.
   * @param  {string} pattern       Pattern to match for route
   * @param  {string} to            Set controller##action for route
   * @param  {string} methods       HTTP verbs that match route
   * @param  {string} module        Namespace to append to controller
   * @param  {string} on            Created resource route under 'member' or 'collection'
   * @param  {struct} constraints
   * @return {Mapper}
   */
  public struct function match(
      string name, string pattern, string to
    , string methods, string module, string on, struct constraints={}) {

    // evaluate match on member or collection
    if (arguments.on EQ "member")
      return member().match(argumentCollection=arguments, on="").end();
    if (arguments.on EQ "collection")
      return collection().match(argumentCollection=arguments, on="").end();

    // use scoped controller if found
    if (StructKeyExists(scopeStack[1], "controller")
        AND NOT StructKeyExists(arguments, "controller"))
      arguments.controller = scopeStack[1].controller;

    // use scoped module if found
    if (StructKeyExists(scopeStack[1], "module")) {
      if (StructKeyExists(arguments, "module"))
        arguments.module &= "." & scopeStack[1].module;
      else
        arguments.module = scopeStack[1].module;
    }

    // interpret 'to' as 'controller##action'
    if (StructKeyExists(arguments, "to")) {
      arguments.controller = ListFirst(arguments.to, "##");
      arguments.action = ListLast(arguments.to, "##");
      StructDelete(arguments, "to");
    }

    // pull route name from arguments if it exists
    local.name = "";
    if (StructKeyExists(arguments, "name")) {
      local.name = arguments.name;

      // guess pattern and/or action
      if (NOT StructKeyExists(arguments, "pattern"))
        arguments.pattern = hyphenize(arguments.name);
      if (NOT StructKeyExists(arguments, "action")
          AND Find("[action]", arguments.pattern) EQ 0)
        arguments.action = arguments.name;
    }

    // die if pattern is not defined
    if (NOT StructKeyExists(arguments, "pattern"))
      throw(
          type="Wheels.MapperArgumentMissing"
        , message="Either 'pattern' or 'name' must be defined."
      );

    // accept either 'method' or 'methods'
    if (StructKeyExists(arguments, "method")) {
      arguments.methods = arguments.method;
      StructDelete(arguments, "method");
    }

    // remove 'methods' argument if settings disable it
    if (!variables.methods && StructKeyExists(arguments, "methods"))
      StructDelete(arguments, "methods");

    // see if we have any globing in the pattern and if so
    // add a constraint for each glob
    if (REFindNoCase("\*([^\/]+)", arguments.pattern)) {
      local.globs = REMatch("\*([^\/]+)", arguments.pattern);
      for (local.glob in local.globs) {
        local.var = replaceList(local.glob, "*,[,]", "");
        arguments.pattern = replace(arguments.pattern, local.glob, "[#local.var#]");
        arguments.constraints[local.var] = ".*";
      }
    }

    // use constraints from stack
    if (StructKeyExists(scopeStack[1], "constraints"))
      StructAppend(arguments.constraints, scopeStack[1].constraints, false);

    // add shallow path to pattern
    if ($shallow())
      arguments.pattern = $shallowPathForCall() & "/" & arguments.pattern;

    // or, add scoped path to pattern
    else if (StructKeyExists(scopeStack[1], "path"))
      arguments.pattern = scopeStack[1].path & "/" & arguments.pattern;

    // if both module and controller are set, combine them
    if (StructKeyExists(arguments, "module")
        && StructKeyExists(arguments, "controller")) {
      arguments.controller = arguments.module & "." & arguments.controller;
      StructDelete(arguments, "module");
    }

    // build named routes in correct order according to rails conventions
    switch (scopeStack[1].$call) {
      case "resource":
      case "resources":
      case "collection":
        local.nameStruct = [
            local.name
          , $shallow() ? $shallowNameForCall() : $scopeName()
          , $collection()
        ];
        break;
      case "member":
      case "new":
        local.nameStruct = [
            local.name
          , $shallow() ? $shallowNameForCall() : $scopeName()
          , $member()
        ];
        break;
      default:
        local.nameStruct = [
            $scopeName()
          , $collection()
          , local.name
        ];
    }

    // transform array into named route
    local.name = ArrayToList(local.nameStruct);
    local.name = REReplace(local.name, "^,+|,+$", "", "ALL");
    local.name = REReplace(local.name, ",+(\w)", "\U\1", "ALL");
    local.name = REReplace(local.name, ",", "", "ALL");

    // if we have a name, add it to arguments
    if (local.name NEQ "")
      arguments.name = local.name;

    // handle optional pattern segments
    if (arguments.pattern CONTAINS "(") {

      // confirm nesting of optional segments
      if (REFind("\).*\(", arguments.pattern))
        $throw(
            type="Wheels.InvalidRoute"
          , message="Optional pattern segments must be nested."
        );

      // strip closing parens from pattern
      local.pattern = Replace(arguments.pattern, ")", "", "ALL");

      // loop over all possible patterns
      while (local.pattern NEQ "") {

        // add current route to wheels
        $addRoute(
            argumentCollection=arguments
          , pattern=Replace(local.pattern, "(", "", "ALL")
        );

        // remove last optional segment
        local.pattern = REReplace(local.pattern, "(^|\()[^(]+$", "");
      }

    } else {

      // add route to wheels as is
      $addRoute(argumentCollection=arguments);
    }

    return this;
  }

  public struct function $get(string name) hint="Match a GET url" {
    return match(method="get", argumentCollection=arguments);
  }

  public struct function post(string name) hint="Match a POST url" {
    return match(method="post", argumentCollection=arguments);
  }

  public struct function put(string name) hint="Match a PUT url" {
    return match(method="put", argumentCollection=arguments);
  }

  public struct function delete(string name) hint="Match a DELETE url" {
    return match(method="delete", argumentCollection=arguments);
  }

  public struct function root(string to) hint="Match a root directory" {
    return match(name="root", pattern="/(.[format])", argumentCollection=arguments);
  }

  public struct function wildcard(string action="index")
    hint="Special wildcard matching" {

    if (StructKeyExists(scopeStack[1], "controller")) {
      match(name="wildcard", pattern="[action]/[key](.[format])", action=arguments.action);
      match(name="wildcard", pattern="[action](.[format])", action=arguments.action);
    } else {
      match(name="wildcard", pattern="[controller]/[action]/[key](.[format])", action=arguments.action);
      match(name="wildcard", pattern="[controller](/[action](.[format]))", action=arguments.action);
    }
    return this;
  }
</cfscript>

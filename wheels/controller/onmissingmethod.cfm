<cfscript>
    public any function onMissingMethod(
      required string missingMethodName, required struct missingMethodArguments) {

    if (REFindNoCase("Path$", arguments.route) == "Path")
    {
      local.rv = $namedRoute(
          route = REReplaceNoCase(arguments.route, "^(.+)Path$", "\1")
        , onlyPath = true
        , argumentCollection = arguments
      );
    }
    else if (REFindNoCase("Url$", arguments.route) == "Url")
    {
      local.rv = $namedRoute(
          route = REReplaceNoCase(arguments.route, "^(.+)Url$", "\1")
        , onlyPath = false
        , argumentCollection = arguments
      );
    }
    if (!StructKeyExists(local, "rv"))
    {
      $throw(
          type="Wheels.MethodNotFound"
        , message="The method `#arguments.missingMethodName#` was not found in the `#variables.$class.name#` controller."
        , extendedInfo="Check your spelling or add the method to the controller's CFC file."
      );
    }
    return local.rv;
  }

  public string function $namedRoute(
    required string route, required boolean onlyPath) {

    // FIX: numbered arguments with StructDelete() are breaking in CF 9.0.1, this hack fixes it
    arguments = Duplicate(arguments);

    // get the matching route and any required variables
    if (StructKeyExists(application.wheels.namedRoutePositions, arguments.route)) {

      local.routePos = application.wheels.namedRoutePositions[arguments.route];

      // for backwards compatibility, allow local.routePos to be a list
      if (IsArray(local.routePos))
        local.pos = local.routePos[1];
      else
        local.pos = ListFirst(local.routePos);

      // grab first route found
      // todo: don't just accept the first route found
      local.route = application.wheels.routes[local.pos];
      local.vars = ListToArray(local.route.variables);

      // loop over variables needed for route
      local.iEnd = ArrayLen(local.vars);
      for (local.i = 1; local.i LTE local.iEnd; local.i++) {
        local.key = local.vars[local.i];

        // try to find the correct argument
        if (StructKeyExists(arguments, local.key)) {
          local.value = arguments[local.key];
          StructDelete(arguments, local.key);
        } else if (StructKeyExists(arguments, local.i)) {
          local.value = arguments[local.i];
          StructDelete(arguments, local.i);
        }

        // if value was passed in
        if (StructKeyExists(loc, "value")) {

          // just assign simple values
          if (NOT IsObject(local.value)) {
            arguments[local.key] = local.value;

          // if object, do special processing
          } else {

            // if the passed in object is new, link to the plural REST route instead
            if (local.value.isNew()) {
              if (StructKeyExists(application.wheels.namedRoutePositions, pluralize(arguments.route))) {
                arguments.route = pluralize(arguments.route);
                break;
              }

            // otherwise, use the Model#toParam method
            } else {
              arguments[local.key] = local.value.toParam();
            }
          }

          // remove value for next loop
          StructDelete(local, "value");
        }
      }
    }

    // return correct url with arguments set
    return urlFor(argumentCollection=arguments);
  }
</cfscript>

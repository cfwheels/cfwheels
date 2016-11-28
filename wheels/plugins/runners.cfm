<cfscript>
  public any function $$pluginRunner() {

    // get the method name called so that we know which stack to run
    local.methodName = GetFunctionCalledName();

    // get our stack from $stack via the name this function was called as
    local.stack = variables.$stacks[local.methodName];

    local.stackLen = arrayLen(local.stack);

    // setup our counter in the request scope so it can be shared as necessary
    if (!structKeyExists(request.wheels.stacks, local.methodName))
      request.wheels.stacks[local.methodName] = 0;

    // ++ the counter for our next method on the stack
    request.wheels.stacks[local.methodName]++;

    // if the developer has called core.method() without there actually being a
    // core method with that name, throw a nice wheels error
    if (request.wheels.stacks[local.methodName] > local.stackLen) {

      // make sure we reset our stack counter in case our expection is caught
      request.wheels.stacks[local.methodName] = 0;

      // throw a method not found error if core.method() doesn't have another
      // method in the stack
      $throw(
          type="Wheels.MethodNotFound"
        , message="The method `#local.methodName#` is part of a plugin but
          was not found in the base object."
      );
    }

    // get the method in the local scope without needing to be scoped
    var method = local.stack[request.wheels.stacks[local.methodName]];

    // if the method called throws an error we'll catch it, reset our counter
    // and rethrow the error
    try {
      local.result = method(argumentCollection=arguments);
    } catch (any e) {
      request.wheels.stacks[local.methodName] = 0;
      rethrow;
    }


    // now that we have a result, remove from our counter
    request.wheels.stacks[local.methodName]--;

    // can't return a null result from a variable
    if (!isNull(local.result))
      return local.result;

    // return null
    return;
  }
</cfscript>

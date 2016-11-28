<cfscript>
  /*
    Replaces any framework method that is overridden by a plugin method
   */
  public any function $$pluginRunner() {

    local.methodName = GetFunctionCalledName();

    // setup our initial run result
    local.result = {
      $$methodArgs = duplicate(arguments)
    };

    // get our stack from $stack via the name this function was
    // called as
    local.stack = variables.$stacks[local.methodName];

    // loop through the stack
    for (local.i = 1; local.i lte arrayLen(local.stack); local.i++) {


      if (!isStruct(local.result) || !structKeyExists(local.result, "$$methodArgs"))
        return local.result;

      // get a variable that we can call as the method
      local.method = local.stack[local.i];

      // make the call and get our return value
      local.result = local.method(argumentCollection=local.result.$$methodArgs);
    }

    if (!isNull(local.result))
      return local.result;

    return;
  }

  /*
    Replaces core.method() from the plugin system to let $$overrideRunner know
    to move to the next method in the stack
   */
  public struct function $$pluginContinue() {

    return { $$methodArgs = arguments };
  }
</cfscript>

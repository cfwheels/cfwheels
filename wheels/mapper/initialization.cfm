<cfscript>
  public struct function init(
    boolean restful=true, boolean methods=arguments.restful) {

    // set up control variables
    variables.scopeStack = [];
    variables.restful = arguments.restful;
    variables.methods = arguments.restful OR arguments.methods;

    // set up default variable constraints
    variables.constraints = {};
    variables.constraints["format"] = "\w+";
    variables.constraints["controller"] = "[^\/]+";

    // set up constraint for globbed routes
    variables.constraints["\*\w+"] = ".+";

    // fix naming collision with cfwheels get() and controller() methods
    this.$$get = variables.$$get = duplicate(this.get);
    this.get = variables.get = duplicate(variables.$get);
    this.controller = variables.controller = duplicate(variables.$controller);

    return this;
  }
</cfscript>

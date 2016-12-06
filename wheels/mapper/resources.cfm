<cfscript>
  /**
   * Set up singular REST resource
   * @param  {string}  name          Name of resource
   * @param  {Boolean} nested        Whether or not additional calls will be nested
   * @param  {string}  path          Path for resource
   * @param  {string}  controller    Override controller used by resource
   * @param  {string}  singular      Override singularize() result in plural resources
   * @param  {string}  plural        Override pluralize() result in singular resource
   * @param  {string}  only          List of REST routes to generate
   * @param  {string}  except        List of REST routes not to generate, takes priority over only
   * @param  {boolean} shallow       Turn on shallow resources
   * @param  {string}  shallowPath   Shallow path prefix
   * @param  {string}  shallowName   Shallow name prefix
   * @param  {struct}  constraints   Variable patterns to use for matching
   * @param  {string}  $call
   * @param  {boolean} $plural
   * @return {Mapper}
   */
  public struct function resource(
      required string name, boolean nested=false
    , string path=hyphenize(arguments.name), string controller
    , string singular, string plural, string only, string except
    , boolean shallow, string shallowPath, string shallowName
    , struct constraints, string $call="resource", boolean $plural=false) {

    local.args = {};

    // if name is a list, add each of the resources in the list
    if (arguments.name CONTAINS ",") {

      // error if the user asked for a nested resource
      if (arguments.nested)
        $throw(
            type="Wheels.InvalidResource"
          , message="Multiple resources in same declaration cannot be nested."
        );

      // remove path so new resources do not break
      StructDelete(arguments, "path");

      // build each new resource
      local.names = ListToArray(arguments.name);
      local.iEnd = ArrayLen(local.names);
      for (local.i = 1; local.i LTE local.iEnd; local.i++)
        resource(name=local.names[local.i], argumentCollection=arguments);
      return this;
    }

    // if plural resource
    if (arguments.$plural) {

      // setup singular and plural words
      if (NOT StructKeyExists(arguments, "singular"))
        arguments.singular = singularize(arguments.name);
      arguments.plural = arguments.name;

      // set collection and scoped paths
      local.args.collection = arguments.plural;
      local.args.nestedPath = "#arguments.path#/[#arguments.singular#Key]";
      local.args.memberPath = "#arguments.path#/[key]";

      // for uncountable plurals, append "Index"
      if (arguments.singular EQ arguments.plural)
        local.args.collection &= "Index";

      // setup local.args.actions
      local.args.actions = "index,new,create,show,edit,update,delete";

    // if singular resource
    } else {

      // setup singular and plural words
      arguments.singular = arguments.name;
      if (NOT StructKeyExists(arguments, "plural"))
        arguments.plural = pluralize(arguments.name);

      // set collection and scoped paths
      local.args.collection = arguments.singular;
      local.args.memberPath = arguments.path;
      local.args.nestedPath = arguments.path;

      // setup local.args.actions
      local.args.actions = "new,create,show,edit,update,delete";
    }

    // set member name
    local.args.member = arguments.singular;

    // set collection path
    local.args.collectionPath = arguments.path;

    // consider only / except REST routes for resources
    // allow arguments.only to override local.args.only
    if (ListLen(arguments.only) GT 0)
      local.args.actions = LCase(arguments.only);

    // remove unwanted routes from local.args.only
    if (ListLen(arguments.except) GT 0) {
      local.except = ListToArray(arguments.except);
      local.iEnd = ArrayLen(local.except);
      for (local.i=1; local.i LTE local.iEnd; local.i++)
        local.args.actions = REReplace(local.args.actions, "\b#local.except[local.i]#\b(,?|$)", "");
    }

    // if controller name was passed, use it
    if (StructKeyExists(arguments, "controller")) {
      local.args.controller = arguments.controller;

    } else {

      // set controller name based on naming preference
      switch ($$get("resourceControllerNaming")) {
        case "name": local.args.controller = arguments.name; break;
        case "singular": local.args.controller = arguments.singular; break;
        default: local.args.controller = arguments.plural;
      }
    }

    // if parent resource is found
    if (StructKeyExists(scopeStack[1], "member")) {

      // use member and nested path
      local.args.name = scopeStack[1].member;
      local.args.path = scopeStack[1].nestedPath;

      // store parent resource (and avoid too deep nesting)
      local.args.parentResource = Duplicate(scopeStack[1]);
      if (StructKeyExists(local.args.parentResource, "parentResource"))
        StructDelete(local.args.parentResource, "parentResource");
    }

    // pass along shallow route options
    if (StructKeyExists(arguments, "shallow"))
      local.args.shallow = arguments.shallow;
    if (StructKeyExists(arguments, "shallowPath"))
      local.args.shallowPath = arguments.shallowPath;
    if (StructKeyExists(arguments, "shallowName"))
      local.args.shallowName = arguments.shallowName;

    // pass along constraints
    if (StructKeyExists(arguments, "constraints"))
      local.args.constraints = arguments.constraints;

    // scope the resource
    scope($call=arguments.$call, argumentCollection=local.args);

    // call end() automatically unless this is a nested call
    // NOTE: see 'end()' source for the resource routes logic
    if (NOT arguments.nested)
      end();

    return this;
  }

  public struct function resources(required string name, boolean nested=false) {
    return resource($plural=true, $call="resources", argumentCollection=arguments);
  }

  public struct function member() {
    return scope(path=scopeStack[1].memberPath, $call="member");
  }

  public struct function collection() {
    return scope(path=scopeStack[1].collectionPath, $call="collection");
  }
</cfscript>

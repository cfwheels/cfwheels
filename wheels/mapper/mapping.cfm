<cfscript>
  public struct function draw(
    boolean restful=true, boolean methods=arguments.restful) {

    variables.restful = arguments.restful;
    variables.methods = arguments.restful OR arguments.methods;

    // start with clean scope stack that is locked for race conditions
    $simpleLock(
        name="mapper.reset"
      , timeout=5
      , type="exclusive"
      , execute="$resetScopeStack"
    );

    return this;
  }

  public struct function end() {
    // if last action was a resource, set up REST routes
    // create plural resource routes
    if (scopeStack[1].$call EQ "resources") {
      collection();
        if (ListFind(scopeStack[1].actions, "index"))
          $get(pattern="(.[format])", action="index");
        if (ListFindNoCase(scopeStack[1].actions, "create"))
          post(pattern="(.[format])", action="create");
      end();
      if (ListFindNoCase(scopeStack[1].actions, "new")) {
        scope(path=scopeStack[1].collectionPath, $call="new");
          $get(pattern="new(.[format])", action="new", name="new");
        end();
      }
      member();
        if (ListFind(scopeStack[1].actions, "edit"))
          $get(pattern="edit(.[format])", action="edit", name="edit");
        if (ListFind(scopeStack[1].actions, "show"))
          $get(pattern="(.[format])", action="show");
        if (ListFind(scopeStack[1].actions, "update"))
          put(pattern="(.[format])", action="update");
        if (ListFind(scopeStack[1].actions, "delete"))
          delete(pattern="(.[format])", action="delete");
      end();

    // create singular resource routes
    } else if (scopeStack[1].$call EQ "resource") {
      if (ListFind(scopeStack[1].actions, "create")) {
        collection();
          post(pattern="(.[format])", action="create");
        end();
      }
      if (ListFind(scopeStack[1].actions, "new")) {
        scope(path=scopeStack[1].memberPath, $call="new");
          $get(pattern="new(.[format])", action="new", name="new");
        end();
      }
      member();
        if (ListFind(scopeStack[1].actions, "edit"))
          $get(pattern="edit(.[format])", action="edit", name="edit");
        if (ListFind(scopeStack[1].actions, "show"))
          $get(pattern="(.[format])", action="show");
        if (ListFind(scopeStack[1].actions, "update"))
          put(pattern="(.[format])", action="update");
        if (ListFind(scopeStack[1].actions, "delete"))
          delete(pattern="(.[format])", action="delete");
      end();
    }

    // remove top of stack to end nesting
    ArrayDeleteAt(scopeStack, 1);
    return this;
  }
</cfscript>

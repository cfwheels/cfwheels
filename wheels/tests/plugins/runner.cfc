/*
  There are 4 ways to use plugin in wheels:

    1. add processing on top of a method,
       then call the framework method (aka onMissingMethod())
    2. completely override a method in wheels
    3. get the return value from a core method and add on to the return value
    4. add new functionality not currently in wheels

  We need to use recursion due to option three where we need need to be able
  to return a proper value from core.method()
 */
component extends="wheels.tests.Test" {

  include "helpers.cfm";

  function setup() {
    config = {
      path="wheels"
      ,fileName="Plugins"
      ,method="init"
      ,pluginPath="/wheelsMapping/tests/_assets/plugins/runner"
      ,deletePluginDirectories=false
      ,overwritePlugins=false
      ,loadIncompatiblePlugins=true
    };
    _params = {controller="test", action="index"};
    PluginObj = $pluginObj(config);
    application.wheels.mixins = PluginObj.getMixins();
    c = controller("test", _params);
    m = model("authors").new();
    d = $createObjectFromRoot(path="wheels", fileName="Dispatch", method="$init");
  }

  function teardown() {
    application.wheels.mixins = {};
  }

  function test_chaining_return_values_from_multiple_plugin_overrides() {
    result = c.URLFor(controller="wheels", action="wheels");
    valid = findNoCase("&urlfor02&urlfor01", result);
    assert('valid neq 0');
  }

  function test_chaining_return_values_from_multiple_plugin_overrides_in_dispatch() {
    result = d.URLFor(controller="wheels", action="wheels");
    valid = findNoCase("&urlfor02&urlfor01", result);
    assert('valid neq 0');
  }

  function test_completely_overriding_a_framework_method() {
    result = c.singularize(word="hahahah");
    assert('result eq "$$completelyOverridden"');
  }

  // our $$pluginRunner will error out due to core.onMissingMethod() being called
  // too many times
  function test_raise_error_running_multiple_override_methods_without_core_method() {
    args = {missingMethodName="asdf", missingMethodArguments={ value="asdf"}};
    r = raised("c.onMissingMethod(args)");
    assert('r eq "Wheels.MethodNotFound"');
  }

  // we use the model onMissingMethod method to tell us that the asdf method
  // doesn't exist
  function test_raise_error_running_multiple_override_methods_with_core_method() {
    args = {missingMethodName="asdf", missingMethodArguments={ value="asdf"}};
    r = raised("m.onMissingMethod(argumentCollection=args)");
    assert('r eq "Wheels.MethodNotFound"');
  }

  function test_running_plugin_only_method() {
    result = c.$$pluginOnlyMethod();
    assert('result eq "$$returnValue"');
  }

  function test_zzz_all_request_stack_counters_are_returned_to_zero() {
    stackCounters = request.wheels.stacks;
    result = true;
    for (item in stackCounters) {
      if (stackCounters[item] != 0) {
        result = false;
        break;
      }
    }
    assert('result eq true');
  }


}

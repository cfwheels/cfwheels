<cfscript>
  variables[params.name] = application.wheels.plugins[params.name];
  include "../../plugins/#LCase(params.name)#/index.cfm";
</cfscript>

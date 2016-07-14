<cfscript>
  param name="params.format" default="html";

  if (ListFindNoCase("junit,json", params.format)) {
    request.wheels.showDebugInformation = false;
    writeOutput(includeContent());
  } else {
    include "../styles/header.cfm";
    writeOutput(includeContent());
    include "../styles/footer.cfm";
  }
</cfscript>

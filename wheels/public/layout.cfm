<cfscript>
  if (StructKeyExists(params, "format") && ListFindNoCase("junit,json", params.format)) {
    request.wheels.showDebugInformation = false;
    writeOutput(includeContent());
  } else {
    include "../styles/header.cfm";
    writeOutput(includeContent());
    include "../styles/footer.cfm";
  }
</cfscript>

<cfscript>
  if (StructKeyExists(params, "format") && ListFindNoCase("junit,json", params.format)) {
    request.wheels.showDebugInformation = false;
    writeOutput(includeContent());
  } else {
  	if(structKeyExists(params, "view") && params.view == "docs"){
    	request.wheels.showDebugInformation = false;
    	setting showdebugoutput="no";
	    include "../styles/docs.cfm";
	    writeOutput(includeContent());
	    include "../styles/docs_footer.cfm";
	} else {
	    include "../styles/header.cfm";
	    writeOutput(includeContent());
	    include "../styles/footer.cfm";
	}
  }
</cfscript>

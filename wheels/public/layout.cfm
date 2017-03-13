<cfscript>
if (StructKeyExists(params, "format") && ListFindNoCase("junit,json", params.format)) {
	request.wheels.showDebugInformation = false;
	writeOutput(includeContent());
} else {
	if (StructKeyExists(params, "view") && params.view == "docs") {
		request.wheels.showDebugInformation = false;
		setting showDebugOutput=false;
		include "../styles/docs.cfm";
		WriteOutput(includeContent());
		include "../styles/docs_footer.cfm";
	} else {
		include "../styles/header.cfm";
		WriteOutput(includeContent());
		include "../styles/footer.cfm";
	}
}
</cfscript>

<!---cfscript>
  content(type="text/json");
  writeOutput(serializeJSON(testResults));
</cfscript--->
<!--- Moved back to tags - see https://github.com/cfwheels/cfwheels/issues/659 --->
<cfcontent type="text/json">
<cfoutput>#serializeJSON(testResults)#</cfoutput>
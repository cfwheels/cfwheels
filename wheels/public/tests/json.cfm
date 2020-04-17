<cfsilent>
<!---cfscript>
  content(type="text/json");
  writeOutput(serializeJSON(testResults));
</cfscript--->
<!--- Moved back to tags - see https://github.com/cfwheels/cfwheels/issues/659 --->
<cfsetting showdebugoutput="false">
<cfcontent type="text/json">
</cfsilent><cfoutput>#serializeJSON(testResults)#</cfoutput>

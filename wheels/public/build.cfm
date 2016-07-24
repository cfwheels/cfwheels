<cfscript>
	setting requesttimeout="10000" showdebugoutput="false";
  zipPath = $buildReleaseZip();
	$header(name="Content-disposition", value="inline; filename=#GetFileFromPath(zipPath)#");
	$content(file=zipPath, type="application/zip", deletefile=true);
</cfscript>

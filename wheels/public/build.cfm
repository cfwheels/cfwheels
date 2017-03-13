<cfscript>
setting requestTimeout=10000 showDebugOutput=false;
zipPath = $buildReleaseZip();
$header(name="Content-disposition", value="inline; filename=#GetFileFromPath(zipPath)#");
$content(file=zipPath, type="application/zip", deletefile=true);
</cfscript>

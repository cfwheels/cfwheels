<cffunction name="saveFile" access="private" returntype="boolean" output="false" hint="Creates a file on the filesystem">
	<cfargument name="fileDir" type="string" required="true" hint="The directory to put this file in">
	<cfargument name="fileName" type="string" required="true" hint="The name of the file">
	<cfargument name="contents" type="string" required="true" hint="The content of the file to be written">
	
	<cfif NOT directoryExists(arguments.fileDir)>
		<cfdirectory action="create" directory="#arguments.fileDir#">
	</cfif>
	
	<cfif NOT fileExists("#arguments.fileDir#/#arguments.fileName#")>
		<cffile action="write" file="#arguments.fileDir#/#arguments.fileName#" nameconflict="overwrite" output="#arguments.contents#">
		<cfreturn true>
	<cfelse>
		<cffile action="write" file="#arguments.fileDir#/#arguments.fileName#" nameconflict="overwrite" output="#arguments.contents#">
		<cfreturn false>
	</cfif>
	
</cffunction>

<cfset application.core.saveFile = saveFile>

<cffunction name="delFile" access="private" returntype="boolean" output="false" hint="Creates a file on the filesystem">
	<cfargument name="fileDir" type="string" required="true" hint="The directory to put this file in">
	<cfargument name="fileName" type="string" required="true" hint="The name of the file">
	
	<cfif fileExists("#arguments.fileDir#/#arguments.fileName#")>
		<cffile action="delete" file="#fileDir#/#arguments.fileName#">
	</cfif>
	
	<cfreturn true>
	
</cffunction>

<cfset application.core.delFile = delFile>

<cffunction name="cleanup" access="private" returntype="string" output="false" hint="Prepare generator output to be written into a real CF file">
	<cfargument name="contents" type="string" required="true" hint="The text to cleanup">
	
	<cfset var output = trim(arguments.contents)>
	<cfset output = replace(output,"<cg","<cf","all")>
	<cfset output = replace(output,"</cg","</cf","all")>
	<cfset output = replace(output,"<!--","<!---","all")>
	<cfset output = replace(output,"-->","--->","all")>
	
	<cfreturn output>
</cffunction>

<cfset application.core.cleanup = cleanup>
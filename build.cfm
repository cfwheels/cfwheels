<!--- 
NOTE: there is a bug with cfzip in Railo
in order to run the build you will need at least version 3.3.0.007

https://issues.jboss.org/browse/RAILO-1223
 --->
<!--- set the release version --->
<cfset release = "1.1.6">

<!--- do not modify anything pass here. you be sorry :) --->
<cfset source = ExpandPath(".")>
<cfset destination = ExpandPath("../wheels-build-temp-dir")>
<cfset ignore = "build.cfm,.project,.gitignore,.git,WEB-INF">
<cfset folders = "files,images,javascripts,lib,plugins,stylesheets,tests">

<!--- copy the current directory to the release directory --->
<cfset directoryCopy(source, destination, ignore)>

<!--- 
create user directories. need to add a .gitignore to get around the fact that
your can't zip empty directories
 --->
<cfloop list="#folders#" index="folder">
	<cfset target = ListAppend(destination, folder, "/")>
	<cfif !DirectoryExists(target)>
		<cfdirectory action="create" directory="#target#">
	</cfif>
	<cfif !FileExists("#target#/.gitignore")>
		<cffile action="write" file="#target#/.gitignore" output="">
	</cfif>
</cfloop>

<cfzip action="zip" file="#source#/cfwheels.#release#.zip" source="#destination#" storePath="false"/>

<!--- need to delete the wheels/tests directory for the release --->
<cfzip action="delete" file="#source#/cfwheels.#release#.zip" entrypath="wheels/tests" recurse="true" />

<!---
Copies a directory.

@param source      Source directory. (Required)
@param destination      Destination directory. (Required)
@param ignore      list of directories and or files to ignore. (Optional)
@param nameConflict      What to do when a conflict occurs (skip, overwrite, makeunique). Defaults to overwrite. (Optional)
@return Returns nothing.
@author Joe Rinehart (joe.rinehart@gmail.com)
@version 2, February 4, 2010
@version 3, March 17, 2011 (Anthony Petruzzi)
--->
<cffunction name="directoryCopy" output="true">
    <cfargument name="source" required="true" type="string">
    <cfargument name="destination" required="true" type="string">
	<cfargument name="ignore" required="false" type="string" default="">
    <cfargument name="nameconflict" required="false" type="string" default="overwrite">

    <cfset var contents = "" />
	<cfset var dirDelim = "/">
    
    <cfif not(directoryExists(arguments.destination))>
        <cfdirectory action="create" directory="#arguments.destination#">
    </cfif>
    
    <cfdirectory action="list" directory="#arguments.source#" name="contents">

	<cfif len(arguments.ignore)>
		<cfquery dbtype="query" name="contents">
		select * from contents where name not in(#ListQualify(arguments.ignore, "'")#)
		</cfquery>
	</cfif>
    
    <cfloop query="contents">
        <cfif contents.type eq "file">
            <cffile action="copy" source="#arguments.source#/#name#" destination="#arguments.destination#/#name#" nameconflict="#arguments.nameConflict#">
        <cfelseif contents.type eq "dir">
            <cfset directoryCopy(arguments.source & dirDelim & name, arguments.destination & dirDelim & name) />
        </cfif>
    </cfloop>
</cffunction>
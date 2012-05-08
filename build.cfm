<!--- 
NOTE: there is a bug with cfzip in Railo
in order to run the build you will need at least version 3.3.0.007

https://issues.jboss.org/browse/RAILO-1223
 --->

<!--- 

Before building:

1) Make sure to update the version in wheels/events/onapplicationstart.cfm
2) Update the wheels/CHANGELOG to reflect version and build date

 --->

<!--- 
is this a public build for release? (removes the tests directory)
 --->
<cfparam name="url.public" type="boolean" default="true">

<!--- set the release version --->

<cfset release = "1.1.8">

<!--- do not modify anything pass here. you be sorry :) --->
<cfset source = ExpandPath(".")>
<cfset destination = ExpandPath("../wheels-build-temp-dir")>
<cfset ignore = "build.cfm,.project,.gitignore,.git,WEB-INF,aspnet_client">
<cfset folders = "files,images,javascripts,lib,plugins,stylesheets,tests">

<!--- previous build --->
<cfif DirectoryExists(destination)>
	<cfdirectory action="delete" directory="#destination#" recurse="true">
</cfif>

<h1>Begin build of: <cfoutput>#release#</cfoutput></h1>
<p>Make the following has been done:</p>
<ol type="1">
	<li>Make sure to update the version in wheels/events/onapplicationstart.cfm</li>
	<li>Update the wheels/CHANGELOG to reflect version and build date</li>
</ol>

<!--- copy the current directory to the release directory --->
<h4>Copying build files and directories:</h4>
<p>
<cfset directoryCopy(source, destination, ignore)>
<strong>Done!</strong>
</p>

<!--- 
create user directories. need to add a .gitignore to get around the fact that
your can't zip empty directories
 --->
<h4>Creating user application directories:</h4>
<p>
<cfloop list="#folders#" index="folder">
	<cfset target = ListAppend(destination, folder, "/")>
	<cfoutput>#target#<br/></cfoutput>
	<cfif !DirectoryExists(target)>
		<cfdirectory action="create" directory="#target#">
	</cfif>
	<cfif !FileExists("#target#/.gitignore")>
		<cffile action="write" file="#target#/.gitignore" output="">
	</cfif>
</cfloop>
<strong>Done!</strong>
</p>

<h4>Packaging build:</h4>

<p>
Creating ZIP file:
<!--- zip build --->
<cfzip action="zip" file="#source#/cfwheels.#release#.zip" source="#destination#" storePath="false"/>
&nbsp;<strong>Done!</strong>
</p>

<cfif url.public>
	<p>Removing framework tests from ZIP:
	<!--- need to delete the wheels/tests directory for the release --->
	<cfzip action="delete" file="#source#/cfwheels.#release#.zip" entrypath="wheels/tests" recurse="true" />
	&nbsp;<strong>Done!</strong>
	</p>
</cfif>

<h4>Build Finished!</h4>
<p>Package location: <cfoutput>#source#/cfwheels.#release#.zip</cfoutput></p>

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
			<cfoutput>#arguments.source#/#name# -> #arguments.destination#/#name#</cfoutput><br/>
            <cffile action="copy" source="#arguments.source#/#name#" destination="#arguments.destination#/#name#" nameconflict="#arguments.nameConflict#">
        <cfelseif contents.type eq "dir">
            <cfset directoryCopy(arguments.source & dirDelim & name, arguments.destination & dirDelim & name) />
        </cfif>
    </cfloop>
</cffunction>
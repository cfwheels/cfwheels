<cfcomponent output="false">

	<!--- 
	NOTE: there is a bug with cfzip in Railo
	in order to run the build you will need at least version 3.3.0.007
	
	https://issues.jboss.org/browse/RAILO-1223
	 --->
	
	<cffunction name="init">
		<cfargument name="version" type="string" required="true">
		
		<!--- 
		see if this is a final release. Final release don't have contain a '-' which is used for labeling
		preview/beta releases
		--->
		<cfset variables.version = arguments.version>
		
		<!--- zip name --->
		<cfset variables.zipName = "cfwheels.#variables.version#.zip">
		
		<cfset variables.source = ExpandPath(".")>
		<cfset variables.buildtmp = ExpandPath("builders/output/release/wheels-build-temp-dir")>
		<cfset variables.ignore = "builders,.project,.gitignore,.git,WEB-INF,aspnet_client,wheels-build-temp-dir,#variables.zipName#">
		<cfset variables.folders = "files,images,javascripts,lib,plugins,stylesheets,tests">
		<cfset variables.remove = "builders">
		<cfset variables.release_zip = "builders/output/release/#variables.zipName#">
		<cfset variables.zipfile = "#ExpandPath(variables.release_zip)#">
		
		<!--- for final release we remove the tests and docs --->
		<cfif !FindNoCase("-", variables.version)>
			<cfset variables.remove = ListAppend(variables.remove, "wheels/tests", ",")>
			<cfset variables.remove = ListAppend(variables.remove, "wheels/docs", ",")>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="build" access="public" returntype="void" output="false">
		<cfset $cleanUp()>
		<cfset $prepare()>
		<cfset $createRelease()>
		<cfset $cleanUp()>
	</cffunction>
	
	<cffunction name="$cleanUp" access="private" returntype="void" output="false">
		<cfif DirectoryExists(variables.buildtmp)>
			<cfdirectory action="delete" directory="#variables.buildtmp#" recurse="true">
		</cfif>
	</cffunction>
	
	<cffunction name="$prepare" access="private" returntype="void" output="false">
		<cfset $directoryCopy(variables.source, variables.buildtmp, variables.ignore)>
		
		<cfloop list="#variables.folders#" index="loc.folder">
			<cfset loc.target = ListAppend(variables.buildtmp, loc.folder, "/")>
			<cfif !DirectoryExists(loc.target)>
				<cfdirectory action="create" directory="#loc.target#">
			</cfif>
			<cfif !FileExists("#loc.target#/.gitignore")>
				<cffile action="write" file="#loc.target#/.gitignore" output="">
			</cfif>
			<cffile action="write" file="#variables.buildtmp#/.gitignore" output="#trim($writeGitIgnore())#">
		</cfloop>
		
	</cffunction>
	
	<cffunction name="$createRelease" access="private" returntype="void" output="false">
		<cfset var loc = {}>
		<cfzip action="zip" file="#variables.zipfile#" source="#variables.buildtmp#" storePath="false"/>
		<cfloop list="#variables.remove#" index="loc.dir" delimiters=",">
			<cfzip action="delete" file="#variables.zipfile#" entrypath="#loc.dir#" recurse="true" />
		</cfloop>
	</cffunction>

	<cffunction name="$directoryCopy" access="private" returntype="void" output="false" hint="
		Copies a directory.
		
		@param source      Source directory. (Required)
		@param destination      Destination directory. (Required)
		@param ignore      list of directories and or files to ignore. (Optional)
		@param nameConflict      What to do when a conflict occurs (skip, overwrite, makeunique). Defaults to overwrite. (Optional)
		@return Returns nothing.
		@author Joe Rinehart (joe.rinehart@gmail.com)
		@version 2, February 4, 2010
		@version 3, March 17, 2011 (Anthony Petruzzi)
	">
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
	            <cfset $directoryCopy(arguments.source & dirDelim & name, arguments.destination & dirDelim & name) />
	        </cfif>
	    </cfloop>
	</cffunction>
	
	<cffunction name="getReleaseZipPath">
		<cfreturn variables.release_zip>
	</cffunction>
	
	<cffunction name="$writeGitIgnore" access="private" returntype="string" output="false">
		<cfset var content = "">
		<cfsavecontent variable="loc.content">
# CFEclipse specific
.project

# Railo
WEB-INF
		
# unpacked plugin folders
plugins/**/*

# files directory where uploads go
files

# DBMigrate plugin: generated SQL
db/sql

# AssetBundler plugin: generated bundles
javascripts/bundles
stylesheets/bundles
		</cfsavecontent>
		
		<cfreturn loc.content>
	</cffunction>
	
</cfcomponent>
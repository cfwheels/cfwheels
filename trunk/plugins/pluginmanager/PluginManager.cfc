<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "0.9.1">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="$installPlugin">
		<cfargument name="pluginURL" type="string" required="true" />
		
		<cfset loc = {}>
		<cfset loc.pluginFile = $downloadPlugin(arguments.pluginURL)>
		<cfset loc.pluginFileName = Replace(arguments.pluginURL, "http://cfwheels.googlecode.com/files/", "")>
		<cfset loc.pluginDirectory = "plugins/">
		
		<cffile action="write" file="#ExpandPath(loc.pluginDirectory)&loc.pluginFileName#" output="#loc.pluginFile#" mode="777" />
		
		<cfset $reloadApp()>
		
	</cffunction>
	
	
	<cffunction name="$downloadPlugin" returnType="any">
		<cfargument name="fileURL" type="string" required="true" />
		
		<cfset var loc = {}>
		
		<cfhttp url="#arguments.fileURL#" result="loc.fileData" method="GET" getAsBinary="yes" />
		
		<cfset loc.fileData = loc.fileData.FileContent>
		
		<cfreturn loc.fileData>
	</cffunction>
	
	<cffunction name="$reloadApp">
		<cflocation url="?reload=true" addToken="no" />
	</cffunction>
	
</cfcomponent>
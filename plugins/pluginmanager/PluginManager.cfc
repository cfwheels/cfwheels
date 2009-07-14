<cfcomponent output="false" mixin="none">

	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="installPlugin" returntype="void">
		<cfargument name="pluginFile" type="string" required="true">
		<cfset var loc = StructNew()>
		<cfset loc.pluginURL = "http://cfwheels.googlecode.com/files/" & arguments.pluginFile & ".zip">
		<cfhttp url="#loc.pluginURL#" result="loc.fileData" method="GET" getAsBinary="yes">
		<cfset loc.pluginFile = loc.fileData.FileContent>
		<cfset loc.pluginDirectory = "plugins/">
		<cffile action="write" file="#ExpandPath(loc.pluginDirectory)&arguments.pluginFile#.zip" output="#loc.pluginFile#" mode="777">
		<cflocation url="?reload=true" addToken="false">
	</cffunction>
	
	<cffunction name="getAvailablePlugins" returntype="array">
		<cfset var loc = StructNew()>
		
		<!--- store all plugins in an array --->
		<cfset loc.plugins = ArrayNew(1)>
		
		<!--- get html that lists all files with label "plugin" on google code --->
		<cfhttp url="http://code.google.com/p/cfwheels/downloads/list?can=2&q=label:plugin&colspec=Filename%20Summary%20Uploaded%20Size%20DownloadCount" result="loc.file"></cfhttp>
		<cfset loc.content = loc.file.FileContent>

		<!--- remove some chars for easier parsing --->
		<cfset loc.content = Replace(loc.content, Chr(10), "", "all")>
		<cfset loc.content = Replace(loc.content, Chr(13), "", "all")>
		<cfset loc.content = Replace(loc.content, Chr(9), "", "all")>
		<cfset loc.content = Replace(loc.content, "  ", " ", "all")>

		<!--- count the number of plugins available so we know how long to loop for --->
		<cfset loc.startStr = "http://cfwheels.googlecode.com/files/">
		<cfset loc.endStr = """">
		<cfset loc.pluginCount = ArrayLen(REMatchNoCase(loc.startStr, loc.content))>

		<cfset loc.pos = 1>
		<cfloop from="1" to="#loc.pluginCount#" index="loc.i">
			
			<!--- parse out plugin name and version from the .zip file name --->
			<cfset loc.startStr = "http://cfwheels.googlecode.com/files/">
			<cfset loc.startPos = FindNoCase(loc.startStr, loc.content, loc.pos)>
			<cfset loc.endPos = FindNoCase(loc.endStr, loc.content, loc.startPos)>
			<cfset loc.str = Mid(loc.content, loc.startPos, loc.endPos-loc.startPos)>
			<cfset loc.name = SpanExcluding(Replace(loc.str, loc.startStr, ""), "-")>
			<cfset loc.version = Replace(Replace(Replace(Replace(loc.str, ".zip", ""), "-", ""), loc.name, ""), loc.startStr, "")>
		
			<!--- parse out description --->
			<cfset loc.startStr = ".zip&amp;can=2&amp;q=label%3Aplugin"">">
			<cfset loc.startPos = FindNoCase(loc.startStr, loc.content, loc.pos)>
			<cfset loc.endPos = FindNoCase("</a>", loc.content, loc.startPos)>
			<cfset loc.description = Trim(Replace(Mid(loc.content, loc.startPos, loc.endPos-loc.startPos), loc.startStr, ""))>
		
			<!--- parse out if it's compatible from the label --->
			<cfset loc.startStr = "</a><a onclick=""cancelBubble=true;"" class=""label"" href=""list?q=label:">
			<cfset loc.startPos = FindNoCase(loc.startStr, loc.content, loc.pos)>
			<cfset loc.endPos = FindNoCase(""" >", loc.content, loc.startPos)>
			<cfset loc.compatible = Replace(Mid(loc.content, loc.startPos, loc.endPos-loc.startPos), loc.startStr, "")>
		
			<cfset loc.pos = loc.endPos>

			<cfif SpanExcluding(application.wheels.version, " ") GTE loc.compatible>
				<!--- add plugin info to array if it's compatible with the installed wheels version --->
				<cfset loc.plugin = StructNew()>
				<cfset loc.plugin.name = loc.name>
				<cfset loc.plugin.version = loc.version>
				<cfset loc.plugin.description = loc.description>
				<cfset ArrayAppend(loc.plugins, loc.plugin)>
			</cfif>

		</cfloop>
		<cfreturn loc.plugins>
	</cffunction>
		
</cfcomponent>
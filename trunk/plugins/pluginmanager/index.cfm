<cfif StructKeyExists(URL, "pluginURL")>
	<cfset $installPlugin("http://cfwheels.googlecode.com/files/#URL.pluginURL#.zip")>
</cfif>

<cfhttp url="http://code.google.com/p/cfwheels/downloads/list?can=2&q=label:plugin&colspec=Filename%20Summary%20Uploaded%20Size%20DownloadCount"></cfhttp>
<cfset content = cfhttp.FileContent>
<cfset content = Replace(content, Chr(10), "", "all")>
<cfset content = Replace(content, Chr(13), "", "all")>
<cfset content = Replace(content, Chr(9), "", "all")>
<cfset content = Replace(content, "  ", " ", "all")>

<h1>Plugin Manager</h1>
<p>This plugin is the plugin of plugins, with it you will be able to extend ColdFusion on Wheels with every authorized plugin out there. Click on the installation links for any of the plugins listed below and the manager will download the desired plugin and reload the application for you, no extra steps are needed.</p>

<cfset startStr = "http://cfwheels.googlecode.com/files/">
<cfset endStr = """">
<cfset pluginCount = ArrayLen(REMatchNoCase(startStr, content))>
<cfset pos = 1>
<cfloop from="1" to="#pluginCount#" index="i">
	<cfset startStr = "http://cfwheels.googlecode.com/files/">
	<cfset startPos = FindNoCase(startStr, content, pos)>
	<cfset endPos = FindNoCase(endStr, content, startPos)>
	<cfset str = Mid(content, startPos, endPos-startPos)>
	<cfset name = SpanExcluding(Replace(str, startStr, ""), "-")>
	<cfset version = Replace(Replace(Replace(Replace(str, ".zip", ""), "-", ""), name, ""), startStr, "")>

	<cfset startStr = "</a><a onclick=""cancelBubble=true;"" class=""label"" href=""list?q=label:">
	<cfset startPos = FindNoCase(startStr, content, pos)>
	<cfset endPos = FindNoCase(""" >", content, startPos)>
	<cfset compatible = Replace(Mid(content, startPos, endPos-startPos), startStr, "")>

	<cfset startStr = ".zip&amp;can=2&amp;q=label%3Aplugin"">">
	<cfset startPos = FindNoCase(startStr, content, pos)>
	<cfset endPos = FindNoCase("</a>", content, startPos)>
	<cfset description = Trim(Replace(Mid(content, startPos, endPos-startPos), startStr, ""))>

	<cfset pos = endPos>

	<cfoutput>
	<h2>#name# (#version#<cfif version LT 1> beta</cfif>)</h2>
	<p>#description#</p>
	<ul><li><strong><cfif ListFindNoCase(StructKeyList(application.wheels.plugins), name)><span style="color:green;">This plugin is already installed.</span><cfelse><cfif application.wheels.version IS NOT compatible><span style="color:red;">This plugin is not compatible with your version of Wheels (#compatible# / #application.wheels.version#)</span><cfelse><cfif NOT ListFindNoCase(StructKeyList(application.wheels.plugins), name) AND application.wheels.version IS compatible><a href="#cgi.script_name#?#cgi.query_string#&pluginURL=#name#-#version#">Download and install now</a></cfif></cfif></cfif></strong></li></ul>
	</cfoutput>

</cfloop>

<hr>
<p class="small" style="margin:0; text-align:center;"><em>To uninstall the PluginManager simply delete the <tt>/plugins/PluginManager-0.1.zip</tt> file.</em></p>
<hr style="margin-bottom:15px;">
<p><a href="<cfoutput>#cgi.http_referer#</cfoutput>"><<< Go Back</a></p>
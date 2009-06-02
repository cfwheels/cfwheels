<cfif StructKeyExists(URL, "plugin")>
	<cfset $installPlugin(URL.plugin)>
</cfif>

<h1>Plugin Manager</h1>
<p>With the Plugin Manager you can download and install all authorized plugins available for the version of Wheels you have installed. Click on the installation links for any of the plugins listed below and the Plugin Manager will download the desired plugin and reload the application for you, no extra steps are needed.</p>

<cfoutput>
	<cfloop array="#$getAvailablePlugins()#" index="plugin">
		<h2>#plugin.name# (#plugin.version#<cfif Left(plugin.version, 1) IS 0> beta</cfif>)</h2>
		<p>#plugin.description#</p>
		<ul><li><strong><cfif ListFindNoCase(pluginNames(), plugin.name)><span style="color:green;">This plugin is installed.</span><cfelse><a href="#cgi.script_name#?#cgi.query_string#&plugin=#plugin.name#-#plugin.version#">Download and install</a></cfif></strong></li></ul>
	</cfloop>
</cfoutput>
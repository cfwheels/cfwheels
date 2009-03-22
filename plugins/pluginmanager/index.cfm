<cfif StructKeyExists(URL, "pluginURL")>
	<cfset install(URL.pluginURL)>
</cfif>

<h1>Plugin Manager</h1>
<p>This plugin is the plugin of plugins, with it you will be able to extend ColdFusion on Wheels with every authorized plugins out there. To get started, simply follow the instruction below.</p>

<h2>Instructions</h2>
<p>Click on "install" of any of the plugins listed below, the manager will download the desired plugin and reload the application for you, no extra steps are needed.</p>

<h2>Available Plugins</h2>
<cfset plugins = $getPluginListing()>

<cfoutput query="plugins">
	<div class="plugin">
		<h3>#name# <span><a href="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#&pluginURL=#url#">Download</a></span></h3>
		<p>#description#</p>
	</div>
	
</cfoutput>

<h2>Uninstallation</h2>
<p>To uninstall this plugin simply delete the <tt>/plugins/PluginManager-0.0.1.zip</tt> file.</p>

<a href="<cfoutput>#cgi.http_referer#</cfoutput>"><<< Go Back</a>
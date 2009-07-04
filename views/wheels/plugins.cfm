<h1>Plugin Manager</h1>
<p>With the Plugin Manager you can download and install all authorized plugins available for the version of Wheels you have installed. Click on the installation links for any of the plugins listed below and the Plugin Manager will download the desired plugin and reload the application for you, no extra steps are needed.</p>

<cfoutput>
	<cfset repos = pluginsObj.$listRepos()>
	<cfloop list="#repos#" index="repo">
		<cfif listlen(repos) gt 1><h1>#pluginsObj.$selectRepo(repo).name#</h1></cfif>
		<cfset plugins = pluginsObj.$listPlugins(repo)>
		<cfloop list="#plugins#" index="plugin">
			<cfset plugindetails = pluginsObj.$selectPlugin(name=plugin, repo=repo)>
			<h2>#plugindetails.name# (#plugindetails.version#<cfif Left(plugindetails.version, 1) IS 0> beta</cfif>)</h2>
			<p>#plugindetails.description#</p>
			<ul><li><strong><cfif pluginsObj.$isInstalledPlugin(plugindetails.name)><span style="color:green;">This plugin is installed.</span><cfelse><a href="?controller=wheels&action=pluginsDownload&name=#plugindetails.name#&version=#plugindetails.version#&repo=#plugindetails.repo#">Download and install</a></cfif></strong></li></ul>
		</cfloop>
	</cfloop>
</cfoutput>
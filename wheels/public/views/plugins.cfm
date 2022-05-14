<cfscript>
if(!application.wheels.enablePluginsComponent)
	throw(type="wheels.plugins", message="The Wheels Plugin component is disabled...");

loadedPlugins = application.wheels.plugins;

</cfscript>
<cfinclude template="../layout/_header.cfm">
<cfoutput>
<!--- cfformat-ignore-start --->
<div class="ui container">
	#pageHeader("Plugins", "What you've got loaded..")#

		<cfif ($get("showIncompatiblePlugins") AND Len(application.wheels.incompatiblePlugins)) OR Len(application.wheels.dependantPlugins)>
			<div class="ui error message">
				<div class="header">
					Warnings:
				</div>
					<cfif $get("showIncompatiblePlugins") AND Len(application.wheels.incompatiblePlugins)>
							<cfloop list="#application.wheels.incompatiblePlugins#" index="local.i">The #local.i# plugin may be incompatible with this version of Wheels, please look for a compatible version of the plugin<br></cfloop>
						</cfif>
						<cfif Len(application.wheels.dependantPlugins)>
							<cfloop list="#application.wheels.dependantPlugins#" index="local.i"><cfset needs = ListLast(local.i, "|")>The #ListFirst(local.i, "|")# plugin needs the following plugin<cfif ListLen(needs) GT 1>s</cfif> to work properly: #needs#<br></cfloop>
						</cfif>
			</div>
		</cfif>

<cfif StructCount($get("plugins")) IS NOT 0>
	<table class="ui celled striped table">
		<thead>
			<tr>
				<th>Name</th>
				<th>Version</th>
				<th colspan="2">Info</th>
			</tr>
		</thead>
		<tbody>
			<cfloop collection="#$get('plugins')#" item="local.i">
				<tr>
					<td>
						<a href="#urlFor(route="wheelsPluginEntry", name=local.i)#">#local.i#</a>
					</td>
					<td>
						<cfif StructCount($get("pluginMeta")) IS NOT 0 && structKeyExists($get("pluginMeta"), local.i) AND len($get("pluginMeta")[local.i]['version'])>
							#$get("pluginMeta")[local.i]['version']#
						<cfelse>
							<em>Unknown</em>
						</cfif>
					</td>
					<td>
						<a class="ui button tiny teal" href="#urlFor(route="wheelsPluginEntry", name=local.i)#"><i class="icon info"></i> More information</a>
					<cfif DirectoryExists("#GetDirectoryFromPath(GetBaseTemplatePath())#plugins/#LCase(local.i)#/tests")>

							<a class="ui button tiny" href="#$get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=packages&type=#LCase(local.i)#">View Tests</a>
						</cfif>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
<cfelse>
	<div class="ui placeholder segment">
		<div class="ui icon header">
			<i class="plug icon"></i>
			No plugins found!
		</div>
		<a href="https://forgebox.io/type/cfwheels-plugins" target="_blank" ref="noopener" class="ui primary button">Browse plugins on Forgebox.io</a>
	</div>
</cfif>

</div>

</cfoutput>
<cfinclude template="../layout/_footer.cfm">
<!--- cfformat-ignore-end --->

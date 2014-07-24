<cfset loc.baseReloadURL = cgi.script_name>
<cfif cgi.path_info IS NOT cgi.script_name>
	<cfset loc.baseReloadURL = loc.baseReloadURL & cgi.path_info>
</cfif>
<cfif Len(cgi.query_string)>
	<cfset loc.baseReloadURL = loc.baseReloadURL & "?" & cgi.query_string>
</cfif>
<cfset loc.baseReloadURL = ReplaceNoCase(loc.baseReloadURL, "/" & application.wheels.rewriteFile, "")>
<cfloop list="design,development,testing,maintenance,production,true" index="loc.i">
	<cfset loc.baseReloadURL = ReplaceNoCase(ReplaceNoCase(loc.baseReloadURL, "?reload=" & loc.i, ""), "&reload=" & loc.i, "")>
</cfloop>
<cfif loc.baseReloadURL Contains "?">
	<cfset loc.baseReloadURL = loc.baseReloadURL & "&">
<cfelse>
	<cfset loc.baseReloadURL = loc.baseReloadURL & "?">
</cfif>
<cfset loc.baseReloadURL = loc.baseReloadURL & "reload=">
<cfset loc.hasFrameworkTests = StructKeyExists(this, "mappings") && StructKeyExists(this.mappings, "/wheelsMapping") && DirectoryExists(expandPath("/wheelsMapping/tests"))>
<cfset loc.appTestDir = get("webPath") & "/tests">
<cfset loc.appTestDir = ExpandPath(loc.appTestDir)>
<cfset loc.hasAppTests = DirectoryExists(loc.appTestDir)>
<cfif loc.hasAppTests>
	<cfdirectory action="list" directory="#loc.appTestDir#" name="loc.tests">
	<cfif NOT loc.tests.recordCount>
		<cfset loc.hasAppTests = false>
	</cfif>
</cfif>
<cfset loc.hasBuilders = DirectoryExists(ExpandPath("#get('webPath')#/builders"))>
<cfset loc.version = get("version")>
<cfif NOT Len(loc.version)>
	<cfset loc.file = ExpandPath(get("webPath") & "/wheels/CHANGELOG")>
	<cfloop file="#loc.file#" index="loc.i">
		<cfset loc.version = loc.i>
		<cfbreak>
	</cfloop>
</cfif>
<cfsavecontent variable="loc.css">
	<style>
	#wheels-debug-area
	{
		clear: both;
		margin: 50px 0;
		text-align: left;
		background: #ececec;
		padding: 10px;
		border-top: 3px solid #999;
		border-bottom: 3px solid #999;
	}
	#wheels-debug-area td
	{
		font: 12px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
		line-height: 1.5em;
		color: #333;
		padding-right: 10px;
	}
	#wheels-debug-area a
	{
		color: #333;
		text-decoration: underline;
		padding: 0 1px;
	}
	#wheels-debug-area a:hover
	{
		color: #fff;
		background: #333;
		text-decoration: none;
	}
	</style>	
</cfsavecontent>
<cfset $htmlhead(text=loc.css)>
<cfoutput>

<div id="wheels-debug-area">
	<table cellspacing="0" cellpadding="0">
		<cfif Len(application.wheels.incompatiblePlugins) OR Len(application.wheels.dependantPlugins)>
			<tr>
				<td valign="top"><strong><span style="color:red;">Warnings:</span></strong></td>
				<td>
					<span style="color:red;">
						<cfif Len(application.wheels.incompatiblePlugins)>
							<cfloop list="#application.wheels.incompatiblePlugins#" index="loc.i">The #loc.i# plugin may be incompatible with this version of Wheels, please look for a compatible version of the plugin<br /></cfloop>
						</cfif>
						<cfif Len(application.wheels.dependantPlugins)>
							<cfloop list="#application.wheels.dependantPlugins#" index="loc.i"><cfset needs = ListLast(loc.i, "|")>The #ListFirst(loc.i, "|")# plugin needs the following plugin<cfif ListLen(needs) GT 1>s</cfif> to work properly: #needs#<br /></cfloop>
						</cfif>
					</span>
				</td>
			</tr>
		</cfif>
		<tr>
			<td valign="top"><strong>Application:</strong></td>
			<td>#application.applicationName#<cfif NOT Len(get("reloadPassword")) OR loc.hasAppTests> [<cfif NOT Len(get("reloadPassword"))><a href="#loc.baseReloadURL#true">Reload</a></cfif><cfif NOT Len(get("reloadPassword")) AND loc.hasAppTests>, </cfif><cfif loc.hasAppTests><a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=tests&type=app&reload=true">Run Tests</a>, <a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=packages&type=app&reload=true">View Tests</a></cfif>]</cfif></td>
		</tr>
		<tr>
			<td valign="top"><strong>Framework:</strong></td>
			<td>Wheels #loc.version#
				<cfif loc.hasFrameworkTests> [<a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=tests&type=core&reload=true">Run Tests</a>, <a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=packages&type=core&reload=true">View Tests</a>]</cfif>
				<cfif loc.hasBuilders>
					[<a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=documentation_generator&type=core&reload=true">Generate Documentation</a>]
					[<a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=release_generator&type=core&reload=true">Generate Release</a>]
				</cfif>
			</td>
		</tr>
		<tr>
			<td valign="top"><strong>Host Name:</strong></td>
			<td>#get("hostName")#</td>
		</tr>
		<tr>
			<td valign="top"><strong>CFML Engine:</strong></td>
			<td>#get("serverName")# #get("serverVersion")#</td>
		</tr>
		<tr>
			<td valign="top"><strong>Default Data Source:</strong></td>
			<td>#capitalize(get("dataSourceName"))#</td>
		</tr>
		<tr>
			<td valign="top"><strong>Active Environment:</strong></td>
			<td>#capitalize(get("environment"))#<cfif NOT Len(get("reloadPassword"))><cfset loc.environments = "design,development,testing,maintenance,production"> [<cfset loc.pos = 0><cfloop list="#loc.environments#" index="loc.i"><cfset loc.pos = loc.pos + 1><cfif get("environment") IS NOT loc.i><a href="#loc.baseReloadURL##loc.i#">#capitalize(loc.i)#</a><cfif ListLen(loc.environments) GT loc.pos>, </cfif></cfif></cfloop>]</cfif></td>
		</tr>
		<tr>
			<td valign="top"><strong>URL Rewriting:</strong></td>
			<td>#get("URLRewriting")#</td>
		</tr>
		<tr>
			<td valign="top"><strong>URL Obfuscation:</strong></td>
			<td><cfif get("obfuscateUrls")>On<cfelse>Off</cfif></td>
		</tr>
		<tr>
			<td valign="top"><strong>Plugins:</strong></td>
			<td><cfif StructCount(get("plugins")) IS NOT 0><cfset loc.count = 0><cfloop collection="#get('plugins')#" item="loc.i"><cfset loc.count = loc.count + 1><a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=plugins&name=#loc.i#">#loc.i#</a><cfif DirectoryExists(expandPath("#get('webPath')#/plugins/#LCase(loc.i)#/tests"))> [<a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=tests&type=#LCase(loc.i)#&reload=true">Run Tests</a>, <a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=packages&type=#LCase(loc.i)#&reload=true">View Tests</a>]</cfif><cfif StructCount(get("plugins")) GT loc.count><br/></cfif></cfloop><cfelse>None</cfif></td>
		</tr>
		<cfif StructKeyExists(request.wheels.params, "route")>
			<tr>
				<td valign="top"><strong>Route:</strong></td>
				<td>#capitalize(request.wheels.params.route)#</td>
			</tr>
		</cfif>
		<tr>
			<td valign="top"><strong>Controller:</strong></td>
			<td>#capitalize(request.wheels.params.controller)#</td>
		</tr>
		<tr>
			<td valign="top"><strong>Action:</strong></td>
			<td>#capitalize(request.wheels.params.action)#</td>
		</tr>
		<cfif StructKeyExists(request.wheels.params, "key")>
			<tr>
				<td valign="top"><strong>Key(s):</strong></td>
				<td>#request.wheels.params.key#</td>
			</tr>
		</cfif>
		<tr>
			<td valign="top"><strong>Parameters:</strong></td>
			<td>
			<cfset loc.additionalParamsExists = false>
			<cfloop collection="#request.wheels.params#" item="loc.i">
				<cfif loc.i IS NOT "fieldnames" AND loc.i IS NOT "route" AND loc.i IS NOT "controller" AND loc.i IS NOT "action" AND loc.i IS NOT "key">
					<cfset loc.additionalParamsExists = true>
					<cfif isStruct(request.wheels.params[loc.i])>
						#lCase(loc.i)# = #SerializeJSON(request.wheels.params[loc.i])#<br />
					<cfelseif IsArray(request.wheels.params[loc.i])>
						#lCase(loc.i)# = #SerializeJSON(request.wheels.params[loc.i])#<br />
					<cfelseif IsSimpleValue(request.wheels.params[loc.i])>
						#lCase(loc.i)# = #request.wheels.params[loc.i]#<br />
					</cfif>
				</cfif>
			</cfloop>
			<cfif NOT loc.additionalParamsExists>
				None
			</cfif>
			</td>
		</tr>
		<tr>
			<td valign="top"><strong>Execution Time:</strong></td>
			<td>#request.wheels.execution.total#ms<cfif request.wheels.execution.total GT 0> (<cfset loc.keys = StructSort(request.wheels.execution, "numeric", "desc")><cfset loc.firstDone = false><cfloop from="1" to="#arrayLen(loc.keys)#" index="loc.i"><cfset loc.key = loc.keys[loc.i]><cfif loc.key IS NOT "total" AND request.wheels.execution[loc.key] GT 0><cfif loc.firstDone>, </cfif>#LCase(loc.key)# ~#request.wheels.execution[loc.key]#ms<cfset loc.firstDone = true></cfif></cfloop>)</cfif></td>
		</tr>
		<tr>
			<td valign="top"><strong>Help Links:</strong></td>
			<td><a href="http://cfwheels.org/docs/#Replace(Left(get("version"), 3), ".", "-")#" target="_blank">Documentation</a>, <a href="http://groups.google.com/group/cfwheels" target="_blank">Google Group</a>, <a href="https://github.com/cfwheels/cfwheels/issues" target="_blank">Issue Tracker</a></td>
		</tr>
	</table>
</div>

</cfoutput>
<cfset loc.baseReloadURL = cgi.script_name>
<cfif IsDefined("request.cgi.path_info")>
	<cfif request.cgi.path_info IS NOT cgi.script_name>
		<cfset loc.baseReloadURL &= request.cgi.path_info>
	</cfif>
<cfelse>
	<cfif cgi.path_info IS NOT cgi.script_name>
		<cfset loc.baseReloadURL &= cgi.path_info>
	</cfif>
</cfif>
<cfif Len(cgi.query_string)>
	<cfset loc.baseReloadURL &= "?" & cgi.query_string>
</cfif>
<cfset loc.baseReloadURL = ReplaceNoCase(loc.baseReloadURL, "/" & application.wheels.rewriteFile, "")>
<cfloop list="design,development,testing,maintenance,production,true" index="loc.i">
	<cfset loc.baseReloadURL = ReplaceNoCase(ReplaceNoCase(loc.baseReloadURL, "?reload=" & loc.i, ""), "&reload=" & loc.i, "")>
</cfloop>
<cfif loc.baseReloadURL Contains "?">
	<cfset loc.baseReloadURL &= "&">
<cfelse>
	<cfset loc.baseReloadURL &= "?">
</cfif>
<cfset loc.baseReloadURL &= "reload=">
<cfset loc.frameworkTestDir = GetDirectoryFromPath(GetBaseTemplatePath()) & "wheels/tests">
<cfset loc.hasFrameworkTests = DirectoryExists(loc.frameworkTestDir)>
<cfset loc.hasFrameworkBuildFile = FileExists(GetDirectoryFromPath(GetBaseTemplatePath()) & "wheels/public/build.cfm")>
<cfset loc.appTestDir = GetDirectoryFromPath(GetBaseTemplatePath()) & "tests">
<cfset loc.hasAppTests = DirectoryExists(loc.appTestDir)>
<cfif loc.hasAppTests>
	<cfdirectory action="list" directory="#loc.appTestDir#" name="loc.tests">
	<cfif NOT loc.tests.recordCount>
		<cfset loc.hasAppTests = false>
	</cfif>
</cfif>
<cfsavecontent variable="loc.css">
	<style>
		#wheels-debug-area
		{
			background: #ececec;
			border-bottom: 3px solid #999;
			border-top: 3px solid #999;
			clear: both;
			margin: 50px 0;
			padding: 10px;
			text-align: left;
		}
		#wheels-debug-area table
		{
			border-collapse: collapse;
			border-spacing: 0;
		}
		#wheels-debug-area td
		{
			color: #333;
			font-family: Arial, Helvetica, sans-serif;
			font-size: 12px;
			line-height: 1.5em;
			padding: 0 10px 0 0;
			vertical-align: top;
			border-bottom: none;
		}
		#wheels-debug-area th {
			border-bottom: none;
		}
		#wheels-debug-area a
		{
			color: #333;
			padding: 0 1px;
			text-decoration: underline;
		}
		#wheels-debug-area a:hover
		{
			background: #333;
			color: #fff;
			text-decoration: none;
		}
	</style>
</cfsavecontent>
<cfset $htmlhead(text=loc.css)>
<cfoutput>

<div id="wheels-debug-area">
	<table>
		<cfif (get("showIncompatiblePlugins") AND Len(application.wheels.incompatiblePlugins)) OR Len(application.wheels.dependantPlugins)>
			<tr>
				<td><strong><span style="color:red;">Warnings:</span></strong></td>
				<td>
					<span style="color:red;">
						<cfif get("showIncompatiblePlugins") AND Len(application.wheels.incompatiblePlugins)>
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
			<td><strong>Application:</strong></td>
			<td>#application.applicationName# [<cfif NOT Len(get("reloadPassword"))><a href="#loc.baseReloadURL#true">Reload</a></cfif><cfif NOT Len(get("reloadPassword"))>,</cfif><a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=routes&type=app">View Routes</a><cfif loc.hasAppTests>,</cfif><cfif loc.hasAppTests><a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=tests&type=app">Run Tests</a>, <a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=packages&type=app&reload=true">View Tests</a></cfif>]</td>
		</tr>
		<tr>
			<td><strong>Framework:</strong></td>
			<td>CFWheels #get("version")#
				<cfif loc.hasFrameworkTests or loc.hasFrameworkBuildFile>
					<cfsavecontent variable="coreLinks">
						<cfif loc.hasFrameworkTests><a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=tests&type=core">Run Tests</a>, <a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=packages&type=core&reload=true">View Tests</a>,</cfif>
						<cfif loc.hasFrameworkBuildFile><a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=build">Build</a></cfif>
					</cfsavecontent>
					[#Trim(coreLinks)#]
				</cfif>
			</td>
		</tr>
		<tr>
			<td><strong>Active Environment:</strong></td>
			<td>#capitalize(get("environment"))#<cfif NOT Len(get("reloadPassword"))><cfset loc.environments = "design,development,testing,maintenance,production"> [<cfset loc.pos = 0><cfloop list="#loc.environments#" index="loc.i"><cfset loc.pos = loc.pos + 1><cfif get("environment") IS NOT loc.i><a href="#loc.baseReloadURL##loc.i#">#capitalize(loc.i)#</a><cfif ListLen(loc.environments) GT loc.pos>, </cfif></cfif></cfloop>]</cfif></td>
		</tr>
		<cfif StructKeyExists(application.wheels, "hostName")>
			<tr>
				<td><strong>Host Name:</strong></td>
				<td>#get("hostName")#</td>
			</tr>
		</cfif>
		<tr>
			<td><strong>CFML Engine:</strong></td>
			<td>#get("serverName")# #get("serverVersion")#</td>
		</tr>
		<tr>
			<td><strong>Default Data Source:</strong></td>
			<td>#capitalize(get("dataSourceName"))#</td>
		</tr>
		<cfif StructKeyExists(application.wheels, "adapterName")>
			<tr>
				<td><strong>Database Adapter:</strong></td>
				<td>#get("adapterName")#</td>
			</tr>
		</cfif>
		<tr>
			<td><strong>URL Rewriting:</strong></td>
			<td>#get("URLRewriting")#</td>
		</tr>
		<tr>
			<td><strong>URL Obfuscation:</strong></td>
			<td><cfif get("obfuscateUrls")>On<cfelse>Off</cfif></td>
		</tr>
		<tr>
			<td><strong>Plugins:</strong></td>
			<td><cfif StructCount(get("plugins")) IS NOT 0><cfset loc.count = 0><cfloop collection="#get('plugins')#" item="loc.i"><cfset loc.count = loc.count + 1><a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=plugins&name=#loc.i#">#loc.i#</a><cfif DirectoryExists("#GetDirectoryFromPath(GetBaseTemplatePath())#plugins/#LCase(loc.i)#/tests")> [<a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=tests&type=#LCase(loc.i)#">Run Tests</a>, <a href="#get('webPath')##ListLast(request.cgi.script_name, '/')#?controller=wheels&action=wheels&view=packages&type=#LCase(loc.i)#&reload=true">View Tests</a>]</cfif><cfif StructCount(get("plugins")) GT loc.count><br/></cfif></cfloop><cfelse>None</cfif></td>
		</tr>
		<cfif StructKeyExists(request.wheels.params, "route")>
			<tr>
				<td><strong>Route:</strong></td>
				<td>#capitalize(request.wheels.params.route)#</td>
			</tr>
		</cfif>
		<tr>
			<td><strong>Controller:</strong></td>
			<td>#capitalize(request.wheels.params.controller)#</td>
		</tr>
		<tr>
			<td><strong>Action:</strong></td>
			<td>#capitalize(request.wheels.params.action)#</td>
		</tr>
		<cfif StructKeyExists(request.wheels.params, "key")>
			<tr>
				<td><strong>Key(s):</strong></td>
				<td>#request.wheels.params.key#</td>
			</tr>
		</cfif>
		<tr>
			<td><strong>Parameters:</strong></td>
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
			<td><strong>Execution Time:</strong></td>
			<td>#request.wheels.execution.total#ms<cfif request.wheels.execution.total GT 0> (<cfset loc.keys = StructSort(request.wheels.execution, "numeric", "desc")><cfset loc.firstDone = false><cfloop from="1" to="#arrayLen(loc.keys)#" index="loc.i"><cfset loc.key = loc.keys[loc.i]><cfif loc.key IS NOT "total" AND request.wheels.execution[loc.key] GT 0><cfif loc.firstDone>, </cfif>#LCase(loc.key)# ~#request.wheels.execution[loc.key]#ms<cfset loc.firstDone = true></cfif></cfloop>)</cfif></td>
		</tr>
		<tr>
			<td><strong>Help Links:</strong></td>
			<td><a href="http://docs.cfwheels.org/docs" target="_blank">Documentation</a>, <a href="http://groups.google.com/group/cfwheels" target="_blank">Mailing List</a>, <a href="https://github.com/cfwheels/cfwheels/issues" target="_blank">Issue Tracker</a></td>
		</tr>
	</table>
</div>

</cfoutput>

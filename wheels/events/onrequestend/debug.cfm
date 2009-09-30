<cfoutput>
<div style="clear:both;margin-top:100px;text-align:left;background:##ececec;padding:10px;border-top:2px solid ##808080;border-bottom:2px solid ##808080;">
<table cellspacing="0">
<cfif Len(application.wheels.incompatiblePlugins) OR Len(application.wheels.dependantPlugins) OR NOT ArrayIsEmpty(request.wheels.deprecation)>
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
				<cfif NOT ArrayIsEmpty(request.wheels.deprecation)>
					<cfloop array="#request.wheels.deprecation#" index="i">#i.message# (line #i.line# in #i.template#)<br /></cfloop>
				</cfif>
			</span>
		</td>
	</tr>
</cfif>
<tr>
	<td valign="top"><strong>Application Name:</strong></td>
	<td>#application.applicationName# [<a href="#get('webPath')##ListLast(cgi.script_name, '/')#?controller=wheels&action=tests&type=app&reload=true">Run Tests</a>]</td>
</tr>
<tr>
	<td valign="top"><strong>Framework:</strong></td>
	<td>Wheels #get("version")# (#get("environment")# mode) [<a href="#get('webPath')##ListLast(cgi.script_name, '/')#?controller=wheels&action=tests&type=core&reload=true">Run Tests</a>]</td>
</tr>
<tr>
	<td valign="top"><strong>CFML Engine:</strong></td>
	<td>#get("serverName")# #get("serverVersion")#</td>
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
	<td><cfif StructCount(get("plugins")) IS NOT 0><cfset loc.count = 0><cfloop collection="#get('plugins')#" item="loc.i"><cfset loc.count = loc.count + 1><a href="#get('webPath')##ListLast(cgi.script_name, '/')#?controller=wheels&action=plugins&name=#LCase(loc.i)#">#loc.i#</a><cfif StructCount(get("plugins")) GT loc.count><br /></cfif></cfloop><cfelse>None</cfif></td>
</tr>
<cfif StructKeyExists(request.wheels.params, "route")>
	<tr>
		<td valign="top"><strong>Route:</strong></td>
		<td>#request.wheels.params.route#</td>
	</tr>
</cfif>
<tr>
	<td valign="top"><strong>Controller:</strong></td>
	<td>#request.wheels.params.controller#</td>
</tr>
<tr>
	<td valign="top"><strong>Action:</strong></td>
	<td>#request.wheels.params.action#</td>
</tr>
<cfif StructKeyExists(request.wheels.params, "key")>
	<tr>
		<td valign="top"><strong>Key(s):</strong></td>
		<td>#request.wheels.params.key#</td>
	</tr>
</cfif>
<tr>
	<td valign="top"><strong>Additional Params:</strong></td>
	<td>
	<cfset loc.additionalParamsExists = false>
	<cfloop collection="#request.wheels.params#" item="loc.i">
		<cfif loc.i IS NOT "fieldnames" AND loc.i IS NOT "route" AND loc.i IS NOT "controller" AND loc.i IS NOT "action" AND loc.i IS NOT "key">
			<cfset loc.additionalParamsExists = true>
			<cfif isStruct(request.wheels.params[loc.i])>
				<cfloop collection="#request.wheels.params[loc.i]#" item="loc.j">
					#lCase(loc.i)#.#lCase(loc.j)# = #request.wheels.params[loc.i][loc.j]#<br />
				</cfloop>
			<cfelse>
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
	<td>#request.wheels.execution.total#ms</td>
</tr>
<tr>
	<td valign="top"><strong>Execution Time Details:</strong></td>
	<td>
	<cfset loc.keys = StructSort(request.wheels.execution, "numeric", "desc")>
	<cfloop from="1" to="#arrayLen(loc.keys)#" index="loc.i">
		<cfset loc.key = loc.keys[loc.i]>
		<cfif loc.key IS NOT "total">
			~#request.wheels.execution[loc.key]#ms - #lCase(loc.key)#<br />
		</cfif>
	</cfloop>
</td>
</tr>
</table>
</div>
</cfoutput>

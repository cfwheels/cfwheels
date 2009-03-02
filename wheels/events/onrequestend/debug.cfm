<cfoutput>
<div style="clear:both;margin-top:100px;text-align:left;background:##ececec;padding:10px;border-top:2px solid ##808080;border-bottom:2px solid ##808080;">
<table cellspacing="0">
<tr>
	<td valign="top"><strong>Application Name:</strong></td>
	<td>#application.applicationName#</td>
</tr>
<tr>
	<td valign="top"><strong>Framework:</strong></td>
	<td>Wheels #application.wheels.version# (#application.settings.environment# mode)</td>
</tr>
<tr>
	<td valign="top"><strong>CFML Engine:</strong></td>
	<td>#application.wheels.serverName# #application.wheels.serverVersion#</td>
</tr>
<tr>
	<td valign="top"><strong>Database:</strong></td>
	<td><cfif StructKeyExists(application.wheels, "databaseName")>#application.wheels.databaseName#<cfelse>None</cfif></td>
</tr>
<tr>
	<td valign="top"><strong>URL Rewriting:</strong></td>
	<td>#application.settings.URLRewriting#</td>
</tr>
<tr>
	<td valign="top"><strong>URL Obfuscation:</strong></td>
	<td><cfif application.settings.obfuscateURLs>On<cfelse>Off</cfif></td>
</tr>
<tr>
	<td valign="top"><strong>Plugins:</strong></td>
	<td><cfif StructCount(application.wheels.plugins) IS NOT 0><cfset loc.count = 0><cfloop collection="#application.wheels.plugins#" item="loc.i"><cfset loc.count = loc.count + 1><a href="<cfif application.settings.URLRewriting IS 'On'>/wheels/plugins?<cfelseif application.settings.URLRewriting IS 'Partial'>/index.cfm/wheels/plugins?<cfelse>/index.cfm?controller=wheels&action=plugins&</cfif>name=#LCase(loc.i)#">#loc.i#</a><cfif StructCount(application.wheels.plugins) GT loc.count><br /></cfif></cfloop><cfelse>None</cfif></td>
</tr>
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
<cfif StructCount(request.wheels.params) GT 3 OR (StructCount(request.wheels.params) GT 2 AND NOT StructKeyExists(request.wheels.params, "key"))>
	<tr>
		<td valign="top"><strong>Additional Params:</strong></td>
		<td>
		<cfloop collection="#request.wheels.params#" item="loc.i">
			<cfif loc.i IS NOT "fieldnames" AND loc.i IS NOT "controller" AND loc.i IS NOT "action" AND loc.i IS NOT "key">
				<cfif isStruct(request.wheels.params[loc.i])>
					<cfloop collection="#request.wheels.params[loc.i]#" item="loc.j">
						#lCase(loc.i)#.#lCase(loc.j)# = #request.wheels.params[loc.i][loc.j]#<br />
					</cfloop>
				<cfelse>
					#lCase(loc.i)# = #request.wheels.params[loc.i]#<br />
				</cfif>
			</cfif>
		</cfloop>
		</td>
	</tr>
</cfif>
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
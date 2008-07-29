<cfoutput>
<cfif application.settings.showDebugInformation AND isDefined("request.wheels.showDebugInformation") AND request.wheels.showDebugInformation>
	<cfset request.wheels.execution.componentTotal = getTickCount() - request.wheels.execution.componentTotal>
	<div style="clear:both;margin-top:100px;text-align:left;background:##ececec;padding:10px;border-top:2px solid ##808080;border-bottom:2px solid ##808080;">
	<table cellspacing="0">
	<tr>
		<td valign="top"><strong>Framework:</strong></td>
		<td>Wheels #application.wheels.version#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Environment:</strong></td>
		<td>#UCase(Left(application.settings.environment, 1))##LCase(Right(application.settings.environment, Len(application.settings.environment)-1))#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Engine:</strong></td>
		<td><cfif IsDefined("server.coldfusion.productname") AND server.coldfusion.productname IS "ColdFusion Server">ColdFusion Server #server.coldfusion.productversion#<cfelse>Railo</cfif></td>
	</tr>
	<tr>
		<td valign="top"><strong>Database:</strong></td>
		<td>#application.wheels.databaseProductName# #application.wheels.databaseVersion#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Data Source:</strong></td>
		<td>#application.settings.database.datasource#</td>
	</tr>
	<tr>
		<td valign="top"><strong>URL Rewriting:</strong></td>
		<td><cfif cgi.script_name Contains "rewrite.cfm">On<cfelse>Off</cfif></td>
	</tr>
	<tr>
		<td valign="top"><strong>URL Obfuscation:</strong></td>
		<td><cfif application.settings.obfuscateURLs>On<cfelse>Off</cfif></td>
	</tr>
	<tr>
		<td valign="top"><strong>Controller:</strong></td>
		<td>#request.wheels.params.controller#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Action:</strong></td>
		<td>#request.wheels.params.action#</td>
	</tr>
	<cfif StructKeyExists(request.wheels.params, "id")>
		<tr>
			<td valign="top"><strong>Id:</strong></td>
			<td>#request.wheels.params.id#</td>
		</tr>
	</cfif>
	<cfif StructCount(request.wheels.params) GT 3 OR (StructCount(request.wheels.params) GT 2 AND NOT StructKeyExists(request.wheels.params, "id"))>
		<tr>
			<td valign="top"><strong>Additional Params:</strong></td>
			<td>
			<cfloop collection="#request.wheels.params#" item="loc.i">
				<cfif loc.i IS NOT "fieldnames" AND loc.i IS NOT "controller" AND loc.i IS NOT "action" AND loc.i IS NOT "id">
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
		<td>#request.wheels.execution.componentTotal#ms</td>
	</tr>
	<tr>
		<td valign="top"><strong>Execution Time Details:</strong></td>
		<td>
		<cfset loc.keys = structSort(request.wheels.execution.components, "numeric", "desc")>
		<cfloop from="1" to="#arrayLen(loc.keys)#" index="loc.i">
			~#request.wheels.execution.components[loc.keys[loc.i]]#ms - #lCase(loc.keys[loc.i])#<br />
		</cfloop>
	</td>
	</tr>
	</table>
	</div>
</cfif>
</cfoutput>
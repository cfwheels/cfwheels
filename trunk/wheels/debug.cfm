<cfoutput>
<cfif application.settings.showDebugInformation AND isDefined("request.wheels.showDebugInformation") AND request.wheels.showDebugInformation>
	<cfset request.wheels.execution.componentTotal = getTickCount() - request.wheels.execution.componentTotal>
	<div style="clear:both;margin-top:100px;text-align:left;background:##ececec;padding:10px;border-top:2px solid ##808080;border-bottom:2px solid ##808080;">
	<table cellspacing="0">
	<tr>
		<td valign="top"><strong>Version:</strong></td>
		<td>#application.wheels.version#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Environment:</strong></td>
		<td>#application.settings.environment#</td>
	</tr>

	<tr>
		<td valign="top"><strong>Params:</strong></td>
		<td>
		<ul style="list-style: none;">
		<cfloop collection="#request.wheels.params#" item="locals.i">
			<cfif locals.i IS NOT "fieldnames">
				<cfif isStruct(request.wheels.params[locals.i])>
					<cfloop collection="#request.wheels.params[locals.i]#" item="locals.j">
						<li>#lCase(locals.i)#.#lCase(locals.j)# = #request.wheels.params[locals.i][locals.j]#</li>
					</cfloop>
				<cfelse>
					<li>#lCase(locals.i)# = #request.wheels.params[locals.i]#</li>
				</cfif>
			</cfif>
		</cfloop>
		</ul>
		</td>
	</tr>

	<tr>
		<td valign="top"><strong>Execution Time:</strong></td>
		<td>#request.wheels.execution.componentTotal#ms</td>
	</tr>
	<tr>
		<td valign="top"><strong>Execution Time Details:</strong></td>
		<td>
		<cfset locals.keys = structSort(request.wheels.execution.components, "numeric", "desc")>
		<ul style="list-style: none;">
		<cfloop from="1" to="#arrayLen(locals.keys)#" index="locals.i">
			<li>~#request.wheels.execution.components[locals.keys[locals.i]]#ms - #lCase(locals.keys[locals.i])#</li>
		</cfloop>
		</ul>
	</td>
	</tr>
	</table>
	</div>
</cfif>
</cfoutput>

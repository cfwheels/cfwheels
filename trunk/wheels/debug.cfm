<cfoutput>
<cfif application.settings.show_debug_information AND isDefined("request.wheels.show_debug_information") AND request.wheels.show_debug_information>
	<cfset request.wheels.execution.component_total = getTickCount() - request.wheels.execution.component_total>
	<div style="clear:both;margin-top:100px;text-align:left;background:##ececec;padding:10px;border-top:2px solid ##808080;border-bottom:2px solid ##808080;">
	<table cellspacing="0">
	<tr>
		<td valign="top"><strong>Version:</strong></td>
		<td>Wheels #application.wheels.version#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Environment:</strong></td>
		<td>#humanize(application.settings.environment)#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Controller:</strong></td>
		<td>#humanize(URL.controller)#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Action:</strong></td>
		<td>#humanize(URL.action)#</td>
	</tr>
	<cfif structKeyExists(URL, "id")>
		<tr>
			<td valign="top"><strong>ID:</strong></td>
			<td>#URL.id#</td>
		</tr>
	</cfif>
	<tr>
		<td valign="top"><strong>Total Execution Time:</strong></td>
		<td>#request.wheels.execution.component_total#ms</td>
	</tr>
	<tr>
		<td valign="top"><strong>Total Execution Time Breakdown:</strong></td>
		<td>
		<cfset keys = structSort(request.wheels.execution.components, "numeric", "desc")>
		<ul style="list-style: none;">
		<cfloop from="1" to="#arrayLen(keys)#" index="i">
			<li>~#request.wheels.execution.components[keys[i]]#ms - #humanize(keys[i])#</li>
		</cfloop>
		</ul>
	</td>
	</tr>
	<tr>
		<td valign="top"><strong>Query Execution Time:</strong></td>
		<td>~#request.wheels.execution.query_total#ms</td>
	</tr>
	<tr>
		<td valign="top"><strong>Query Execution Time Breakdown:</strong></td>
		<td>
		<cfset keys = structSort(request.wheels.execution.queries, "numeric", "desc")>
		<ul style="list-style: none;">
		<cfloop from="1" to="#arrayLen(keys)#" index="i">
			<li>~#request.wheels.execution.queries[keys[i]]#ms - #humanize(keys[i])#</li>
		</cfloop>
		</ul>
	</td>
	</tr>
	<tr>
		<td valign="top"><strong>Partial Execution Time:</strong></td>
		<td>~#request.wheels.execution.partial_total#ms</td>
	</tr>
	<tr>
		<td valign="top"><strong>Partial Execution Time Breakdown:</strong></td>
		<td>
		<cfset keys = structSort(request.wheels.execution.partials, "numeric", "desc")>
		<ul style="list-style: none;">
		<cfloop from="1" to="#arrayLen(keys)#" index="i">
			<li>~#request.wheels.execution.partials[keys[i]]#ms - #humanize(keys[i])#</li>
		</cfloop>
		</ul>
	</td>
	</tr>
	</table>
	</div>
</cfif>
</cfoutput>

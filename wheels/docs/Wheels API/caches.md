# caches()

## Description
Tells Wheels to cache one or more actions.

## Function Syntax
	caches( [ action, time, static ] )


## Parameters
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		
		<tr>
			<td>action</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Action(s) to cache. This argument is also aliased as `actions`.</td>
		</tr>
		
		<tr>
			<td>time</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Minutes to cache the action(s) for.</td>
		</tr>
		
		<tr>
			<td>static</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to tell Wheels that this is a static page and that it can skip running the controller filters (before and after filters set on actions) and application events (onSessionStart, onRequestStart etc).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<cfset caches(actions="browseByUser,browseByTitle", time=30)>

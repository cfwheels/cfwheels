# renderPartial()

## Description
Instructs the controller to render a partial when it's finished processing the action.

## Function Syntax
	renderPartial( partial, [ cache, layout, returnAs, dataFunction ] )


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
			<td>partial</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The name of the partial file to be used. Prefix with a leading slash `/` if you need to build a path from the root `views` folder. Do not include the partial filename's underscore and file extension.</td>
		</tr>
		
		<tr>
			<td>cache</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Number of minutes to cache the content for.</td>
		</tr>
		
		<tr>
			<td>layout</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The layout to wrap the content in. Prefix with a leading slash `/` if you need to build a path from the root `views` folder. Pass `false` to not load a layout at all.</td>
		</tr>
		
		<tr>
			<td>returnAs</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set to `string` to return the result instead of automatically sending it to the client.</td>
		</tr>
		
		<tr>
			<td>dataFunction</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Name of a controller function to load data from.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Render the partial `_comment.cfm` located in the current controller's view folder --->
		<cfset renderPartial("comment")>
		
		<!--- Render the partial at `views/shared/_comment.cfm` --->
		<cfset renderPartial("/shared/comment")>

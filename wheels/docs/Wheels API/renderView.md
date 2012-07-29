# renderView()

## Description
Instructs the controller which view template and layout to render when it's finished processing the action. Note that when passing values for `controller` and/or `action`, this function does not load the actual action but rather just loads the corresponding view template.

## Function Syntax
	renderView( [ controller, action, template, layout, cache, returnAs, hideDebugInformation ] )


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
			<td>controller</td>
			<td>string</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>Controller to include the view page for.</td>
		</tr>
		
		<tr>
			<td>action</td>
			<td>string</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>Action to include the view page for.</td>
		</tr>
		
		<tr>
			<td>template</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>A specific template to render. Prefix with a leading slash `/` if you need to build a path from the root `views` folder.</td>
		</tr>
		
		<tr>
			<td>layout</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>The layout to wrap the content in. Prefix with a leading slash `/` if you need to build a path from the root `views` folder. Pass `false` to not load a layout at all.</td>
		</tr>
		
		<tr>
			<td>cache</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Number of minutes to cache the content for.</td>
		</tr>
		
		<tr>
			<td>returnAs</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set to `string` to return the result instead of automatically sending it to the client.</td>
		</tr>
		
		<tr>
			<td>hideDebugInformation</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>Set to `true` to hide the debug information at the end of the output. This is useful when you're testing XML output in an environment where the global setting for `showDebugInformation` is `true`.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Render a view page for a different action within the same controller --->
		<cfset renderView(action="edit")>
		
		<!--- Render a view page for a different action within a different controller --->
		<cfset renderView(controller="blog", action="new")>
		
		<!--- Another way to render the blog/new template from within a different controller --->
		<cfset renderView(template="/blog/new")>

		<!--- Render the view page for the current action but without a layout and cache it for 60 minutes --->
		<cfset renderView(layout=false, cache=60)>
		
		<!--- Load a layout from a different folder within `views` --->
		<cfset renderView(layout="/layouts/blog")>
		
		<!--- Don't render the view immediately but rather return and store in a variable for further processing --->
		<cfset myView = renderView(returnAs="string")>

# renderWith()

## Description
Instructs the controller to render the data passed in to the format that is requested. If the format requested is `json` or `xml`, Wheels will transform the data into that format automatically. For other formats (or to override the automatic formatting), you can also create a view template in this format: `nameofaction.xml.cfm`, `nameofaction.json.cfm`, `nameofaction.pdf.cfm`, etc.

## Function Syntax
	renderWith( data, [ controller, action, template, layout, cache, returnAs, hideDebugInformation ] )


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
			<td>data</td>
			<td>any</td>
			<td>true</td>
			<td></td>
			<td>Data to format and render.</td>
		</tr>
		
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
	
		<!--- In your controller --->
		<cffunction name="init">
			<cfset provides("html,xml,json")>
		</cffunction>
		
		<!--- This action will provide the formats defined in `init()` above --->
		<cffunction name="list">
			<cfset products = model("product").findAll()>
			<cfset renderWith(products)>
		</cffunction>
		
		<!--- This action will only provide the `html` type and will ignore what was defined in the call to `provides()` in the `init()` method above --->
		<cffunction name="new">
			<cfset onlyProvides("html")>
			<cfset model("product").new()>
		</cffunction>

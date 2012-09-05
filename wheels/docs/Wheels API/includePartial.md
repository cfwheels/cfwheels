# includePartial()

## Description
Includes the specified partial file in the view. Similar to using `cfinclude` but with the ability to cache the result and use Wheels-specific file look-up. By default, Wheels will look for the file in the current controller's view folder. To include a file relative from the base `views` folder, you can start the path supplied to `name` with a forward slash.

## Function Syntax
	includePartial( partial, [ group, cache, layout, spacer, dataFunction ] )


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
			<td>any</td>
			<td>true</td>
			<td></td>
			<td>The name of the partial file to be used. Prefix with a leading slash `/` if you need to build a path from the root `views` folder. Do not include the partial filename's underscore and file extension.</td>
		</tr>
		
		<tr>
			<td>group</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>If passing a query result set for the `partial` argument, use this to specify the field to group the query by. A new query will be passed into the partial template for you to iterate over.</td>
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
			<td>spacer</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>HTML or string to place between partials when called using a query.</td>
		</tr>
		
		<tr>
			<td>dataFunction</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Name of controller function to load data from.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<cfoutput>#includePartial("login")#</cfoutput>
		-> If we're in the "admin" controller, Wheels will include the file "views/admin/_login.cfm".

		<cfoutput>#includePartial(partial="misc/doc", cache=30)#</cfoutput>
		-> If we're in the "admin" controller, Wheels will include the file "views/admin/misc/_doc.cfm" and cache it for 30 minutes.

		<cfoutput>#includePartial(partial="/shared/button")#</cfoutput>
		-> Wheels will include the file "views/shared/_button.cfm".

# hyphenize()

## Description
Converts camelCase strings to lowercase strings with hyphens as word delimiters instead. Example: `myVariable` becomes `my-variable`.

## Function Syntax
	hyphenize( string )


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
			<td>string</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The string to hyphenize.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Outputs "my-blog-post" --->
		<cfoutput>
			#hyphenize("myBlogPost")#
		</cfoutput>

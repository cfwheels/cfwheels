# mimeTypes()

## Description
Returns an associated MIME type based on a file extension.

## Function Syntax
	mimeTypes( extension, [ fallback ] )


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
			<td>extension</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The extension to get the MIME type for.</td>
		</tr>
		
		<tr>
			<td>fallback</td>
			<td>string</td>
			<td>false</td>
			<td>application/octet-stream</td>
			<td>the fallback MIME type to return.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get the internally-stored MIME type for `xls` --->
		<cfset mimeType = mimeTypes("xls")>

		<!--- Get the internally-stored MIME type for a dynamic value. Fall back to a MIME type of `text/plain` if it's not found --->
		<cfset mimeType = mimeTypes(extension=params.type, fallback="text/plain")>

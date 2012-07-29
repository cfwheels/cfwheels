# addFormat()

## Description
Adds a new MIME format to your Wheels application for use with responding to multiple formats.

## Function Syntax
	addFormat( extension, mimeType )


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
			<td>File extension to add.</td>
		</tr>
		
		<tr>
			<td>mimeType</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Matching MIME type to associate with the file extension.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Add the `js` format --->
		<cfset addFormat(extension="js", mimeType="text/javascript")>

		<!--- Add the `ppt` and `pptx` formats --->
		<cfset addFormat(extension="ppt", mimeType="application/vnd.ms-powerpoint")>
		<cfset addFormat(extension="pptx", mimeType="application/vnd.ms-powerpoint")>

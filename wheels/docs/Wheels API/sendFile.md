# sendFile()

## Description
Sends a file to the user (from the `files` folder or a path relative to it by default).

## Function Syntax
	sendFile( file, [ name, type, disposition, directory, deleteFile ] )


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
			<td>file</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The file to send to the user.</td>
		</tr>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The file name to show in the browser download dialog box.</td>
		</tr>
		
		<tr>
			<td>type</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The HTTP content type to deliver the file as.</td>
		</tr>
		
		<tr>
			<td>disposition</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set to `inline` to have the browser handle the opening of the file (possibly inline in the browser) or set to `attachment` to force a download dialog box.</td>
		</tr>
		
		<tr>
			<td>directory</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Directory outside of the webroot where the file exists. Must be a full path.</td>
		</tr>
		
		<tr>
			<td>deleteFile</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>Pass in `true` to delete the file on the server after sending it.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Send a PDF file to the user --->
		<cfset sendFile(file="wheels_tutorial_20081028_J657D6HX.pdf")>

		<!--- Send the same file but give the user a different name in the browser dialog window --->
		<cfset sendFile(file="wheels_tutorial_20081028_J657D6HX.pdf", name="Tutorial.pdf")>

		<!--- Send a file that is located outside of the web root --->
		<cfset sendFile(file="../../tutorials/wheels_tutorial_20081028_J657D6HX.pdf")>

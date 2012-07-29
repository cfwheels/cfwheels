# contentFor()

## Description
Used to store a section's output for rendering within a layout. This content store acts as a stack, so you can store multiple pieces of content for a given section.

## Function Syntax
	contentFor( [ position, overwrite ] )


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
			<td>position</td>
			<td>any</td>
			<td>false</td>
			<td>last</td>
			<td>The position in the section's stack where you want the content placed. Valid values are `first`, `last`, or the numeric position.</td>
		</tr>
		
		<tr>
			<td>overwrite</td>
			<td>any</td>
			<td>false</td>
			<td>false</td>
			<td>Whether or not to overwrite any of the content. Valid values are `false`, `true`, or `all`.</td>
		</tr>
		
	</tbody>
</table>


## Examples
		
		<!--- In your view --->
		<cfsavecontent variable="mySidebar">
		<h1>My Sidebar Text</h1>
		</cfsavecontent>
		<cfset contentFor(sidebar=mySidebar)>
		
		<!--- In your layout --->
		<html>
		<head>
		    <title>My Site</title>
		</head>
		<body>
		
		<cfoutput>
		#includeContent("sidebar")#
		
		#includeContent()#
		</cfoutput>

		</body>
		</html>

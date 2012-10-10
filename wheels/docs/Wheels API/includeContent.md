# includeContent()

## Description
Used to output the content for a particular section in a layout.

## Function Syntax
	includeContent( [ name, defaultValue ] )


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
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td>body</td>
			<td>Name of layout section to return content for.</td>
		</tr>
		
		<tr>
			<td>defaultValue</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>What to display as a default if the section is not defined.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In your view template, let's say `views/blog/post.cfm --->
		<cfset contentFor(head='<meta name="robots" content="noindex,nofollow" />"')>
		<cfset contentFor(head='<meta name="author" content="wheelsdude@wheelsify.com"')>
		
		<!--- In `views/layout.cfm` --->
		<html>
		<head>
		    <title>My Site</title>
		    #includeContent("head")#
		</head>
		<body>

		<cfoutput>
		#includeContent()#
		</cfoutput>

		</body>
		</html>

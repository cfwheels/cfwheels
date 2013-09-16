# styleSheetLinkTag()

## Description
Returns a `link` tag for a stylesheet (or several) based on the supplied arguments.

## Function Syntax
	styleSheetLinkTag( [ sources, type, media, head, delim ] )


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
			<td>sources</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The name of one or many CSS files in the `stylesheets` folder, minus the `.css` extension. (Can also be called with the `source` argument.) Pass a full URL to generate a tag for an external style sheet.</td>
		</tr>
		
		<tr>
			<td>type</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The `type` attribute for the `link` tag.</td>
		</tr>
		
		<tr>
			<td>media</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The `media` attribute for the `link` tag.</td>
		</tr>
		
		<tr>
			<td>head</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to place the output in the `head` area of the HTML page instead of the default behavior, which is to place the output where the function is called from.</td>
		</tr>
		
		<tr>
			<td>delim</td>
			<td>string</td>
			<td>false</td>
			<td>,</td>
			<td>the delimiter to use for the list of stylesheets</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- view code --->
		<head>
			<cfoutput>
			<!--- Includes `stylesheets/styles.css` --->
		    #styleSheetLinkTag("styles")#
			<!--- Includes `stylesheets/blog.css` and `stylesheets/comments.css` --->
			#styleSheetLinkTag("blog,comments")#
			<!--- Includes printer style sheet --->
			#styleSheetLinkTag(source="print", media="print")#
			<!--- Includes external style sheet --->
			#styleSheetLinkTag("http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.0/themes/cupertino/jquery-ui.css")#
			</cfoutput>
		</head>
		
		<body>
			<cfoutput>
			<!--- This will still appear in the `head` --->
			#styleSheetLinkTag(source="tabs", head=true)#
			</cfoutput>
		</body>

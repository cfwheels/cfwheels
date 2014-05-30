# javaScriptIncludeTag()

## Description
Returns a `script` tag for a JavaScript file (or several) based on the supplied arguments.

## Function Syntax
	javaScriptIncludeTag( [ sources, type, head, delim ] )


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
			<td>The name of one or many JavaScript files in the `javascripts` folder, minus the `.js` extension. (Can also be called with the `source` argument.) Pass a full URL to access an external JavaScript file.</td>
		</tr>
		
		<tr>
			<td>type</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The `type` attribute for the `script` tag.</td>
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
			<!--- Includes `javascripts/main.js` --->
		    #javaScriptIncludeTag("main")#
			<!--- Includes `javascripts/blog.js` and `javascripts/accordion.js` --->
			#javaScriptIncludeTag("blog,accordion")#
			<!--- Includes external JavaScript file --->
			#javaScriptIncludeTag("https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js")#
			</cfoutput>
		</head>
		
		<body>
			<cfoutput>
			<!--- Will still appear in the `head` --->
			#javaScriptIncludeTag(source="tabs", head=true)#
			</cfoutput>
		</body>

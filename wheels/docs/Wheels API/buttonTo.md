# buttonTo()

## Description
Creates a form containing a single button that submits to the URL. The URL is built the same way as the @linkTo function.

## Function Syntax
	buttonTo( [ text, confirm, image, disable, route, controller, action, key, params, anchor, onlyPath, host, protocol, port, remote ] )


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
			<td>text</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The text content of the button.</td>
		</tr>
		
		<tr>
			<td>confirm</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Pass a message here to cause a JavaScript confirmation dialog box to pop up containing the message.</td>
		</tr>
		
		<tr>
			<td>image</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>If you want to use an image for the button pass in the link to it here (relative from the `images` folder).</td>
		</tr>
		
		<tr>
			<td>disable</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Pass in `true` if you want the button to be disabled when clicked (can help prevent multiple clicks), or pass in a string if you want the button disabled and the text on the button updated (to "please wait...", for example).</td>
		</tr>
		
		<tr>
			<td>route</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name of a route that you have configured in `config/routes.cfm`.</td>
		</tr>
		
		<tr>
			<td>controller</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name of the controller to include in the URL.</td>
		</tr>
		
		<tr>
			<td>action</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name of the action to include in the URL.</td>
		</tr>
		
		<tr>
			<td>key</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Key(s) to include in the URL.</td>
		</tr>
		
		<tr>
			<td>params</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Any additional params to be set in the query string.</td>
		</tr>
		
		<tr>
			<td>anchor</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Sets an anchor name to be appended to the path.</td>
		</tr>
		
		<tr>
			<td>onlyPath</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>If `true`, returns only the relative URL (no protocol, host name or port).</td>
		</tr>
		
		<tr>
			<td>host</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set this to override the current host.</td>
		</tr>
		
		<tr>
			<td>protocol</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set this to override the current protocol.</td>
		</tr>
		
		<tr>
			<td>port</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Set this to override the current port number.</td>
		</tr>
		
		<tr>
			<td>remote</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Pass true if you wish to make this an asynchronous request</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		#buttonTo(text="Delete Account", action="perFormDelete", disable="Wait...")#

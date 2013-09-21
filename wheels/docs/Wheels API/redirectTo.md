# redirectTo()

## Description
Redirects the browser to the supplied `controller`/`action`/`key`, `route` or back to the referring page. Internally, this function uses the @URLFor function to build the link and the `cflocation` tag to perform the redirect. Additional arguments will be converted into flash messages.

## Function Syntax
	redirectTo( [ back, addToken, statusCode, route, controller, action, key, params, anchor, onlyPath, host, protocol, port, delay, url ] )


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
			<td>back</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>Set to `true` to redirect back to the referring page.</td>
		</tr>
		
		<tr>
			<td>addToken</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>See documentation for your CFML engine's implementation of `cflocation`.</td>
		</tr>
		
		<tr>
			<td>statusCode</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>See documentation for your CFML engine's implementation of `cflocation`.</td>
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
			<td>delay</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to delay the redirection until after the rest of your action code has executed.</td>
		</tr>
		
		<tr>
			<td>url</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>An external address to redirect to. Must be a complete address, ie: http://www.cfwheels.org</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Redirect to an action after successfully saving a user and create a flash message with the key "success" --->
		<cfif user.save()>
		    <cfset redirectTo(action="saveSuccessful", success="User saved successfully.")>
		</cfif>

		<!--- Redirect to a specific page on a secure server --->
		<cfset redirectTo(controller="checkout", action="start", params="type=express", protocol="https")>

		<!--- Redirect to a route specified in `config/routes.cfm` and pass in the screen name that the route takes --->
		<cfset redirectTo(route="profile", screenName="Joe")>

		<!--- Redirect back to the page the user came from --->
		<cfset redirectTo(back=true)>

		<!--- Redirect to a specific URL --->
		<cfset redirectTo(url="http://www.cfwheels.org")>

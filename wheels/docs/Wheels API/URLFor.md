# URLFor()

## Description
Creates an internal URL based on supplied arguments.

## Function Syntax
	URLFor( [ route, controller, action, key, params, anchor, onlyPath, host, protocol, port ] )


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
		
	</tbody>
</table>


## Examples
	
		<!--- Create the URL for the `logOut` action on the `account` controller, typically resulting in `/account/log-out` --->
		#URLFor(controller="account", action="logOut")#

		<!--- Create a URL with an anchor set on it --->
		#URLFor(action="comments", anchor="comment10")#

		<!--- Create a URL based on a route called `products`, which expects params for `categorySlug` and `productSlug` --->
		#URLFor(route="product", categorySlug="accessories", productSlug="battery-charger")#

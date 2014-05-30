# startFormTag()

## Description
Builds and returns a string containing the opening form tag. The form's action will be built according to the same rules as `URLFor`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	startFormTag( [ method, multipart, spamProtection, route, controller, action, key, params, anchor, onlyPath, host, protocol, port, remote ] )


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
			<td>method</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The type of method to use in the form tag. `get` and `post` are the options.</td>
		</tr>
		
		<tr>
			<td>multipart</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` if the form should be able to upload files.</td>
		</tr>
		
		<tr>
			<td>spamProtection</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to protect the form against spammers (done with JavaScript).</td>
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
	
		<!--- view code --->
		<cfoutput>
		    #startFormTag(action="create", spamProtection=true)#
		        <!--- your form controls --->
		    #endFormTag()#
		</cfoutput>

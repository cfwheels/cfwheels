# flashKeep()

## Description
Make the entire Flash or specific key in it stick around for one more request.

## Function Syntax
	flashKeep( [ key ] )


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
			<td>key</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>A key or list of keys to flag for keeping. This argument is also aliased as `keys`.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Keep the entire Flash for the next request --->
		<cfset flashKeep()>

		<!--- Keep the "error" key in the Flash for the next request --->
		<cfset flashKeep("error")>

		<!--- Keep both the "error" and "success" keys in the Flash for the next request --->
		<cfset flashKeep("error,success")>

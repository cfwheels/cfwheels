# filterChain()

## Description
Returns an array of all the filters set on this controller in the order in which they will be executed.

## Function Syntax
	filterChain( [ type ] )


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
			<td>type</td>
			<td>string</td>
			<td>false</td>
			<td>all</td>
			<td>Use this argument to return only `before` or `after` filters.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get filter chain, remove the first item, and set it back --->
		<cfset myFilterChain = filterChain()>
		<cfset ArrayDeleteAt(myFilterChain, 1)>
		<cfset setFilterChain(myFilterChain)>

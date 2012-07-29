# setFilterChain()

## Description
Use this function if you need a more low level way of setting the entire filter chain for a controller.

## Function Syntax
	setFilterChain( chain )


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
			<td>chain</td>
			<td>array</td>
			<td>true</td>
			<td></td>
			<td>An array of structs, each of which represent an `argumentCollection` that get passed to the `filters` function. This should represent the entire filter chain that you want to use for this controller.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Set filter chain directly in an array --->
		<cfset setFilterChain([
			{through="restrictAccess"},
			{through="isLoggedIn,checkIPAddress", except="home,login"},
			{type="after", through="logConversion", only="thankYou"}
		])>

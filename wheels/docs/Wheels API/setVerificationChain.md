# setVerificationChain()

## Description
Use this function if you need a more low level way of setting the entire verification chain for a controller.

## Function Syntax
	setVerificationChain( chain )


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
			<td>An array of structs, each of which represent an `argumentCollection` that get passed to the `verifies` function. This should represent the entire verification chain that you want to use for this controller.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Set verification chain directly in an array --->
		<cfset setVerificationChain([
			{only="handleForm", post=true},
			{only="edit", get=true, params="userId", paramsTypes="integer"},
			{only="edit", get=true, params="userId", paramsTypes="integer", handler="index", error="Invalid userId"}
		])>

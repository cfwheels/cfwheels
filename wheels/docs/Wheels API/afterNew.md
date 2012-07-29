# afterNew()

## Description
Registers method(s) that should be called after a new object has been initialized (which is usually done with the @new method).

## Function Syntax
	afterNew( [ methods ] )


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
			<td>methods</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Method name or list of method names that should be called when this callback event occurs in an object's life cycle (can also be called with the `method` argument).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Instruct Wheels to call the `fixObj` method --->
		<cfset afterNew("fixObj")>

# model()

## Description
Returns a reference to the requested model so that class level methods can be called on it.

## Function Syntax
	model( name )


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
			<td>name</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name of the model to get a reference to.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- The `model("author")` part of the code below gets a reference to the model from the application scope, and then the `findByKey` class level method is called on it --->
		<cfset authorObject = model("author").findByKey(1)>

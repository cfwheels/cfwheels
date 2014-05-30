# properties()

## Description
Returns a structure of all the properties with their names as keys and the values of the property as values.

## Function Syntax
	properties( [ simpleValues ] )


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
			<td>simpleValues</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>Returns only simple values of this and nested object/s</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get a structure of all the properties for an object --->
		<cfset user = model("User").findByKey(1)>
		<cfset props = user.properties()>

		<!--- Get a structure of all the simple properties for an object and any nested objects --->
		<cfset user = model("User").findByKey(key=1, include="Galleries")>
		<cfset props = user.properties(simpleValues=true)>

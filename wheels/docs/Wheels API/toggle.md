# toggle()

## Description
Assigns to the property specified the opposite of the property's current boolean value. Throws an error if the property cannot be converted to a boolean value. Returns this object if save called internally is `false`.

## Function Syntax
	toggle( property, [ save ] )


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
			<td>property</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td></td>
		</tr>
		
		<tr>
			<td>save</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Argument to decide whether save the property after it has been toggled. Defaults to true.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get an object, and toggle a boolean property --->
		<cfset user = model("user").findByKey(58)>
		<cfset isSuccess = user.toggle("isActive")><!--- returns whether the object was saved properly --->
		<!--- You can also use a dynamic helper for this --->
		<cfset isSuccess = user.toggleIsActive()>

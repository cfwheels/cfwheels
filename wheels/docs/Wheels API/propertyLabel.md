# propertyLabel()

## Description
Return the label for the property

## Function Syntax
	propertyLabel( property )


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
		
	</tbody>
</table>


## Examples
	
		<!--- Setup a label for the firstname property in a User model's init method --->
		<cffunction name="init">
			<cfset property(name="firstName", label="First name(s)")>
		</cffunction>
		
		<!--- Create a user object --->
		<cfset user = model("User").findOne()>
		<!--- Get the label for the firstname property --->
		<cfset myLabel = user.propertyLabel("firstname")>

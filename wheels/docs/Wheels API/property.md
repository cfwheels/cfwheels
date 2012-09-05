# property()

## Description
Use this method to map an object property to either a table column with a different name than the property or to a SQL expression. You only need to use this method when you want to override the default object relational mapping that Wheels performs.

## Function Syntax
	property( name, [ column, sql, label, defaultValue ] )


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
			<td>The name that you want to use for the column or SQL function result in the CFML code.</td>
		</tr>
		
		<tr>
			<td>column</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The name of the column in the database table to map the property to.</td>
		</tr>
		
		<tr>
			<td>sql</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>A SQL expression to use to calculate the property value.</td>
		</tr>
		
		<tr>
			<td>label</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>A custom label for this property to be referenced in the interface and error messages.</td>
		</tr>
		
		<tr>
			<td>defaultValue</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>A default value for this property.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Tell Wheels that when we are referring to `firstName` in the CFML code, it should translate to the `STR_USERS_FNAME` column when interacting with the database instead of the default (which would be the `firstname` column) --->
		<cfset property(name="firstName", column="STR_USERS_FNAME")>

		<!--- Tell Wheels that when we are referring to `fullName` in the CFML code, it should concatenate the `STR_USERS_FNAME` and `STR_USERS_LNAME` columns --->
		<cfset property(name="fullName", sql="STR_USERS_FNAME + ' ' + STR_USERS_LNAME")>

		<!--- Tell Wheels that when displaying error messages or labels for form fields, we want to use `First name(s)` as the label for the `STR_USERS_FNAME` column --->
		<cfset property(name="firstName", label="First name(s)")>

		<!--- Tell Wheels that when creating new objects, we want them to be auto-populated with a `firstName` property of value `Dave` --->
		<cfset property(name="firstName", defaultValue="Dave")>

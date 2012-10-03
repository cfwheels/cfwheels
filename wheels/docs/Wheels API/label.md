# label()

## Description
Builds and returns a string containing a label. Note: Pass any additional arguments like `class` and `rel`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	label( objectName, property, [ association ] )


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
			<td>objectName</td>
			<td>any</td>
			<td>true</td>
			<td></td>
			<td>The variable name of the object to build the form control for.</td>
		</tr>
		
		<tr>
			<td>property</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The name of the property to use in the form control.</td>
		</tr>
		
		<tr>
			<td>association</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The name of the association that the property is located on. Used for building nested forms that work with nested properties. If you are building a form with deep nesting, simply pass in a list to the nested object, and Wheels will figure it out.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Display a `label` for the required `objectName` and `property` --->
		<cfoutput>
		    #label(objectName="user", property="password")#
		</cfoutput>

		<!--- Display a label for passwords provided by the `passwords` association and nested properties --->
		<fieldset>
			<legend>Passwords</legend>
			<cfloop from="1" to="#ArrayLen(user.passwords)#" index="i">
				#label(objectName="user", association="passwords", position=i, property="password")#
			</cfloop>
		</fieldset>

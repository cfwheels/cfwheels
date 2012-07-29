# hasManyRadioButton()

## Description
Used as a shortcut to output the proper form elements for an association. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	hasManyRadioButton( objectName, association, property, keys, tagValue, [ checkIfBlank, label ] )


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
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name of the variable containing the parent object to represent with this form field.</td>
		</tr>
		
		<tr>
			<td>association</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name of the association set in the parent object to represent with this form field.</td>
		</tr>
		
		<tr>
			<td>property</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name of the property in the child object to represent with this form field.</td>
		</tr>
		
		<tr>
			<td>keys</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Primary keys associated with this form field. Note that these keys should be listed in the order that they appear in the database table.</td>
		</tr>
		
		<tr>
			<td>tagValue</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The value of the radio button when `selected`.</td>
		</tr>
		
		<tr>
			<td>checkIfBlank</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>Whether or not to check this form field as a default if there is a blank value set for the property.</td>
		</tr>
		
		<tr>
			<td>label</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The label text to use in the form control.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Show radio buttons for associating a default address with the current author --->
		<cfloop query="addresses">
			#hasManyRadioButton(
				label=addresses.title,
				objectName="author",
				association="authorsDefaultAddresses",
				keys="#author.key()#,#addresses.id#"
			)#
		</cfloop>

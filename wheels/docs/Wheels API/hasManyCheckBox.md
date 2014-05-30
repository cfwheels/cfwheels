# hasManyCheckBox()

## Description
Used as a shortcut to output the proper form elements for an association. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	hasManyCheckBox( objectName, association, keys, [ label, labelPlacement, prepend, append, prependToLabel, appendToLabel, errorElement, errorClass ] )


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
			<td>keys</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Primary keys associated with this form field. Note that these keys should be listed in the order that they appear in the database table.</td>
		</tr>
		
		<tr>
			<td>label</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The label text to use in the form control.</td>
		</tr>
		
		<tr>
			<td>labelPlacement</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Whether to place the label `before`, `after`, or wrapped `around` the form control. Label text placement can be controled using `aroundLeft` or `aroundRight`</td>
		</tr>
		
		<tr>
			<td>prepend</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to prepend to the form control. Useful to wrap the form control with HTML tags.</td>
		</tr>
		
		<tr>
			<td>append</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to append to the form control. Useful to wrap the form control with HTML tags.</td>
		</tr>
		
		<tr>
			<td>prependToLabel</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to prepend to the form control's `label`. Useful to wrap the form control with HTML tags.</td>
		</tr>
		
		<tr>
			<td>appendToLabel</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to append to the form control's `label`. Useful to wrap the form control with HTML tags.</td>
		</tr>
		
		<tr>
			<td>errorElement</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>HTML tag to wrap the form control with when the object contains errors.</td>
		</tr>
		
		<tr>
			<td>errorClass</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The class name of the HTML tag that wraps the form control when there are errors.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Show check boxes for associating authors with the current book --->
		<cfloop query="authors">
			#hasManyCheckBox(
				label=authors.fullName,
				objectName="book",
				association="bookAuthors",
				keys="#book.key()#,#authors.id#"
			)#
		</cfloop>

# selectTag()

## Description
Builds and returns a string containing a select form control based on the supplied `name` and `options`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	selectTag( name, options, [ selected, includeBlank, multiple, valueField, textField, label, labelPlacement, prepend, append, prependToLabel, appendToLabel ] )


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
			<td>Name to populate in tag's `name` attribute.</td>
		</tr>
		
		<tr>
			<td>options</td>
			<td>any</td>
			<td>true</td>
			<td></td>
			<td>A collection to populate the select form control with. Can be a query recordset or an array of objects.</td>
		</tr>
		
		<tr>
			<td>selected</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Value of option that should be selected by default.</td>
		</tr>
		
		<tr>
			<td>includeBlank</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Whether to include a blank option in the select form control. Pass `true` to include a blank line or a string that should represent what display text should appear for the empty value (for example, "- Select One -").</td>
		</tr>
		
		<tr>
			<td>multiple</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether to allow multiple selection of options in the select form control.</td>
		</tr>
		
		<tr>
			<td>valueField</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The column or property to use for the value of each list element. Used only when a query or array of objects has been supplied in the `options` argument.</td>
		</tr>
		
		<tr>
			<td>textField</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The column or property to use for the value of each list element that the end user will see. Used only when a query or array of objects has been supplied in the `options` argument.</td>
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
		
	</tbody>
</table>


## Examples
	
		<!--- Controller code --->
		<cfset cities = model("city").findAll()>

		<!--- View code --->
		<cfoutput>
		    #selectTag(name="cityId", options=cities)#
		</cfoutput>
		
		<!--- Do this when Wheels isn't grabbing the correct values for the `option`s' values and display texts --->
		<cfoutput>
			#selectTag(name="cityId", options=cities, valueField="id", textField="name")#
		</cfoutput>

# dateSelect()

## Description
Builds and returns a string containing three select form controls for month, day, and year based on the supplied `objectName` and `property`.

## Function Syntax
	dateSelect( [ objectName, property, association, position, order, separator, startYear, endYear, monthDisplay, includeBlank, label, labelPlacement, prepend, append, prependToLabel, appendToLabel, errorElement, errorClass, combine ] )


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
			<td>false</td>
			<td></td>
			<td>The variable name of the object to build the form control for.</td>
		</tr>
		
		<tr>
			<td>property</td>
			<td>string</td>
			<td>false</td>
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
		
		<tr>
			<td>position</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The position used when referencing a `hasMany` relationship in the `association` argument. Used for building nested forms that work with nested properties. If you are building a form with deep nestings, simply pass in a list of positions, and Wheels will figure it out.</td>
		</tr>
		
		<tr>
			<td>order</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Use to change the order of or exclude date select tags.</td>
		</tr>
		
		<tr>
			<td>separator</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Use to change the character that is displayed between the date select tags.</td>
		</tr>
		
		<tr>
			<td>startYear</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>First year in select list.</td>
		</tr>
		
		<tr>
			<td>endYear</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Last year in select list.</td>
		</tr>
		
		<tr>
			<td>monthDisplay</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Pass in `names`, `numbers`, or `abbreviations` to control display.</td>
		</tr>
		
		<tr>
			<td>includeBlank</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Whether to include a blank option in the select form control. Pass `true` to include a blank line or a string that should represent what display text should appear for the empty value (for example, "- Select One -").</td>
		</tr>
		
		<tr>
			<td>label</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The label text to use in the form control. The label will be applied to all `select` tags, but you can pass in a list to cutomize each one individually.</td>
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
		
		<tr>
			<td>combine</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `false` to not combine the select parts into a single `DateTime` object.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- View code --->
		<cfoutput>
			#dateSelect(objectName="user", property="dateOfBirth")#
		</cfoutput>
		
		<!--- Show fields to select month and year --->
		<cfoutput>
			#dateSelect(objectName="order", property="expirationDate", order="month,year")#
		</cfoutput>

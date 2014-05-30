# dateSelectTags()

## Description
Builds and returns a string containing three select form controls (month, day, and year) based on a `name` and `value`.

## Function Syntax
	dateSelectTags( name, [ selected, order, separator, startYear, endYear, monthDisplay, includeBlank, label, labelPlacement, prepend, append, prependToLabel, appendToLabel, combine ] )


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
			<td>selected</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Value of option that should be selected by default.</td>
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
			<td>combine</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `false` to not combine the select parts into a single `DateTime` object.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- This "Tag" version of function accepts `name` and `selected` instead of binding to a model object --->
		<cfoutput>
			#dateSelectTags(name="dateStart", selected=params.dateStart)#
		</cfoutput>
		
		<!--- Show fields for month and year only --->
		<cfoutput>
			#dateSelectTags(name="expiration", selected=params.expiration, order="month,year")#
		</cfoutput>

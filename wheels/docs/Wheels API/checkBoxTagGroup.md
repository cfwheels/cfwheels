# checkBoxTagGroup()

## Description
Builds and returns a string for a group of check boxes and labels. If you pass in [value] to any of the arguments that get appplied to each individual check boxes (`append` for example), it will be replaced by the real value in the current iteration. You can pass in different `prepend`, `append` etc arguments by using a list.

## Function Syntax
	checkBoxTagGroup( name, values, [ checkedValues, order, prependToGroup, appendToGroup, label, labelPlacement, prepend, append, prependToLabel, appendToLabel ] )


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
			<td>values</td>
			<td>struct</td>
			<td>true</td>
			<td></td>
			<td>Values to populate</td>
		</tr>
		
		<tr>
			<td>checkedValues</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The values of the check boxes that should be checked.</td>
		</tr>
		
		<tr>
			<td>order</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>List of struct keys in the order you want them displayed (to override the alphabetical default).</td>
		</tr>
		
		<tr>
			<td>prependToGroup</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to prepend to the entire group of radio buttons.</td>
		</tr>
		
		<tr>
			<td>appendToGroup</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to append to the entire group of radio buttons.</td>
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
	
		<cfset languages = StructNew()>
		<cfset languages.js = "JavaScript">
		<cfset languages.cfml = "ColdFusion">
		<cfset languages.css = "CSS">
		<cfset languages.html = "HTML">
		<cfoutput>
			#checkBoxTagGroup(name="lang", values=languages, checkedValues="cfml,css")#
		</cfoutput>

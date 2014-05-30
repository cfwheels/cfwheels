# submitTag()

## Description
Builds and returns a string containing a submit button `form` control. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	submitTag( [ value, image, disable, prepend, append ] )


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
			<td>value</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Message to display in the button form control.</td>
		</tr>
		
		<tr>
			<td>image</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>File name of the image file to use in the button form control.</td>
		</tr>
		
		<tr>
			<td>disable</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Whether or not to disable the button upon clicking. (prevents double-clicking.)</td>
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
		
	</tbody>
</table>


## Examples
	
		!--- view code --->
		<cfoutput>
		    #startFormTag(action="something")#
		        <!--- form controls go here --->
		        #submitTag()#
		    #endFormTag()#
		</cfoutput>

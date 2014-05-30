# buttonTag()

## Description
Builds and returns a string containing a button `form` control.

## Function Syntax
	buttonTag( [ content, type, value, image, disable, prepend, append ] )


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
			<td>content</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Content to display inside the button.</td>
		</tr>
		
		<tr>
			<td>type</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The type for the button: `button`, `reset`, or `submit`.</td>
		</tr>
		
		<tr>
			<td>value</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The value of the button when submitted.</td>
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
			<td>Whether or not to disable the button upon clicking. (Prevents double-clicking.)</td>
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
	
		<!--- view code --->
		<cfoutput>
		    #startFormTag(action="something")#
		        <!--- form controls go here --->
		        #buttonTag(content="Submit this form", value="save")#
		    #endFormTag()#
		</cfoutput>

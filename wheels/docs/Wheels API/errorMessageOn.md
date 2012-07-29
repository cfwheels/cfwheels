# errorMessageOn()

## Description
Returns the error message, if one exists, on the object's property. If multiple error messages exist, the first one is returned.

## Function Syntax
	errorMessageOn( objectName, property, [ prependText, appendText, wrapperElement, class ] )


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
			<td>The variable name of the object to display the error message for.</td>
		</tr>
		
		<tr>
			<td>property</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The name of the property to display the error message for.</td>
		</tr>
		
		<tr>
			<td>prependText</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to prepend to the error message.</td>
		</tr>
		
		<tr>
			<td>appendText</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to append to the error message.</td>
		</tr>
		
		<tr>
			<td>wrapperElement</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>HTML element to wrap the error message in.</td>
		</tr>
		
		<tr>
			<td>class</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>CSS class to set on the wrapper element.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
	<!--- view code --->
	<cfoutput>
	    #errorMessageOn(objectName="user", property="email")#
	</cfoutput>

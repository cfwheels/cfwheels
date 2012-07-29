# renderText()

## Description
Instructs the controller to render specified text when it's finished processing the action.

## Function Syntax
	renderText( text )


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
			<td>text</td>
			<td>any</td>
			<td>true</td>
			<td></td>
			<td>The text to be rendered.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Render just the text "Done!" to the client --->
		<cfset renderText("Done!")>
		
		<!--- Render serialized product data to the client --->
		<cfset products = model("product").findAll()>
		<cfset renderText(SerializeJson(products))>

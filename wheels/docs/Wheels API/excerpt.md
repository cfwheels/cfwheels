# excerpt()

## Description
Extracts an excerpt from text that matches the first instance of a given phrase.

## Function Syntax
	excerpt( text, phrase, [ radius, excerptString, stripTags, wholeWords ] )


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
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The text to extract an excerpt from.</td>
		</tr>
		
		<tr>
			<td>phrase</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The phrase to extract.</td>
		</tr>
		
		<tr>
			<td>radius</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Number of characters to extract surrounding the phrase.</td>
		</tr>
		
		<tr>
			<td>excerptString</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to replace first and/or last characters with.</td>
		</tr>
		
		<tr>
			<td>stripTags</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Should we remove all html tags before extracting the except</td>
		</tr>
		
		<tr>
			<td>wholeWords</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>when extracting the excerpt, span to to grab whole words.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		#excerpt(text="ColdFusion Wheels is a Rails-like MVC framework for Adobe ColdFusion and Railo", phrase="framework", radius=5)#
		-> ... MVC framework for ...

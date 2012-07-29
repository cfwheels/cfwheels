# highlight()

## Description
Highlights the phrase(s) everywhere in the text if found by wrapping it in a `span` tag.

## Function Syntax
	highlight( text, phrases, [ delimiter, tag, class ] )


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
			<td>Text to search.</td>
		</tr>
		
		<tr>
			<td>phrases</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>List of phrases to highlight.</td>
		</tr>
		
		<tr>
			<td>delimiter</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Delimiter to use in `phrases` argument.</td>
		</tr>
		
		<tr>
			<td>tag</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>HTML tag to use to wrap the highlighted phrase(s).</td>
		</tr>
		
		<tr>
			<td>class</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Class to use in the tags wrapping highlighted phrase(s).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		#highlight(text="You searched for: Wheels", phrases="Wheels")#
		-> You searched for: <span class="highlight">Wheels</span>

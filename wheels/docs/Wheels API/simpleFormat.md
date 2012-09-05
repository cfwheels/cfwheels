# simpleFormat()

## Description
Replaces single newline characters with HTML break tags and double newline characters with HTML paragraph tags (properly closed to comply with XHTML standards).

## Function Syntax
	simpleFormat( text, [ wrap, escapeHtml ] )


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
			<td>The text to format.</td>
		</tr>
		
		<tr>
			<td>wrap</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to wrap the result in a paragraph.</td>
		</tr>
		
		<tr>
			<td>escapeHtml</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not to escape HTML characters before applying the line break formatting.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- How most of your calls will look --->
		#simpleFormat(post.comments)#

		<!--- Demonstrates what output looks like with specific data --->
		<cfsavecontent variable="comment">
			I love this post!

			Here's why:
			* Short
			* Succinct
			* Awesome
		</cfsavecontent>
		#simpleFormat(comment)#
		-> <p>I love this post!</p>
		   <p>
		       Here's why:<br />
			   * Short<br />
			   * Succinct<br />
			   * Awesome
		   </p>

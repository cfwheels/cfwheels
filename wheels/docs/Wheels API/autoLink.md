# autoLink()

## Description
Turns all URLs and email addresses into hyperlinks.

## Function Syntax
	autoLink( text, [ link, relative ] )


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
			<td>The text to create links in.</td>
		</tr>
		
		<tr>
			<td>link</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Whether to link URLs, email addresses or both. Possible values are: `all` (default), `URLs` and `emailAddresses`.</td>
		</tr>
		
		<tr>
			<td>relative</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Should we autolink relative urls</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		#autoLink("Download Wheels from http://cfwheels.org/download")#
		-> Download Wheels from <a href="http://cfwheels.org/download">http://cfwheels.org/download</a>

		#autoLink("Email us at info@cfwheels.org")#
		-> Email us at <a href="mailto:info@cfwheels.org">info@cfwheels.org</a>

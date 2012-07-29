# mailTo()

## Description
Creates a `mailto` link tag to the specified email address, which is also used as the name of the link unless name is specified.

## Function Syntax
	mailTo( emailAddress, [ name, encode ] )


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
			<td>emailAddress</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The email address to link to.</td>
		</tr>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>A string to use as the link text ("Joe" or "Support Department", for example).</td>
		</tr>
		
		<tr>
			<td>encode</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Pass `true` here to encode the email address, making it harder for bots to harvest it for example.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		#mailTo(emailAddress="webmaster@yourdomain.com", name="Contact our Webmaster")#
		-> <a href="mailto:webmaster@yourdomain.com">Contact our Webmaster</a>

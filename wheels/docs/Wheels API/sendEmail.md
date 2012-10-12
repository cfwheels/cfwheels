# sendEmail()

## Description
Sends an email using a template and an optional layout to wrap it in. Besides the Wheels-specific arguments documented here, you can also pass in any argument that is accepted by the `cfmail` tag as well as your own arguments to be used by the view.

## Function Syntax
	sendEmail( [ template, from, to, subject, layout, file, detectMultipart, mailparams ] )


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
			<td>template</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The path to the email template or two paths if you want to send a multipart email. if the `detectMultipart` argument is `false`, the template for the text version should be the first one in the list. This argument is also aliased as `templates`.</td>
		</tr>
		
		<tr>
			<td>from</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Email address to send from.</td>
		</tr>
		
		<tr>
			<td>to</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>List of email addresses to send the email to.</td>
		</tr>
		
		<tr>
			<td>subject</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The subject line of the email.</td>
		</tr>
		
		<tr>
			<td>layout</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Layout(s) to wrap the email template in. This argument is also aliased as `layouts`.</td>
		</tr>
		
		<tr>
			<td>file</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>A list of the names of the files to attach to the email. This will reference files stored in the `files` folder (or a path relative to it). This argument is also aliased as `files`.</td>
		</tr>
		
		<tr>
			<td>detectMultipart</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>When set to `true` and multiple values are provided for the `template` argument, Wheels will detect which of the templates is text and which one is HTML (by counting the `<` characters).</td>
		</tr>
		
		<tr>
			<td>mailparams</td>
			<td>array</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>any addition mail parameters you would like to pass to the email. each element of the array must be a struct with keys corresponding to the attributes of the cfmailparam tag</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get a member and send a welcome email, passing in a few custom variables to the template --->
		<cfset newMember = model("member").findByKey(params.member.id)>
		<cfset sendEmail(
			to=newMember.email,
			template="myemailtemplate",
			subject="Thank You for Becoming a Member",
			recipientName=newMember.name,
			startDate=newMember.startDate
		)>

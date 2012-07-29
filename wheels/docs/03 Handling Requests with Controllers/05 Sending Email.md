# Sending Email

*Use Wheels to simplify the task of setting up automated emails in your application.*

Sending emails in Wheels is done from your controller files with the `sendEmail()` function. It's
basically a wrapper around `cfmail`, but it has some smart functionality and a more Wheels-like approach
in general.

Getting this to work in Wheels can be broken down in 3 steps. We'll walk you through them.

## Set Defaults for Mail Server Information

We recommend using Wheels ability to set global defaults for `sendEmail()` so that you don't have to
specify more arguments than necessary in your controller files. Because it's likely that you will use
the same mail server across your application, this makes it worthwhile to set a global default for it. 

This setting should be done in the `config/settings.cfm` file and can look something like this:

	<cfset set(functionName="sendEmail", server="yourServer", username="yourUsername", password="yourPassword")>

By specifying these values here, these arguments can be omitted from all `sendEmail()` function calls,
thus providing cleaner, less cluttered code.

But you are not limited to setting only these 3 variables. In fact, you can set a global default for any
optional argument to `sendEmail()` and because it accepts the same arguments that `cfmail` does. That's
quite a few.

## Create an Email Template

An email template is required for `sendEmail()` to work and forms the basis for the mail message
content. Think of an email template as the content of your email.

Templates may be stored anywhere within the `/views/` folder, but we recommend a structured, logical
approach. If different controllers utilize `sendEmail()` and each require a unique template, place each
email template within the `views/controllername` folder structure.

Consider this example scenario:

<table>
	<tbody>
		<tr>
			<th scope="row">Controller:</th>
			<td>`Membership`</td>
		</tr>
		<tr>
			<th scope="row">Email Template:</th>
			<td>`/views/membership/myemailtemplate.cfm`</td>
		</tr>
	</tbody>
</table>

Multiple templates may be stored within this directory should there be a need.

The content of the template is simple: simply output the content and any expected variables.

Here's an example for `myemailtemplate.cfm`, which will contain HTML content.

	<cfoutput>
	<p>Hi #recipientName#,</p>
	<p>We wanted to take a moment to thank you for joining our service and to confirm your start date.</p>
	<p>Our records indicate that your membership will begin on <strong>#DateFormat(startDate, "dddd, mmmm, d, yyyy")#</strong>.</p>
	</cfoutput>

## Sending the Email

As we've said before, `sendEmail()` accepts all attribute of CFML's `<cfmail>` tag as arguments. But it
also accepts any variables that you need to pass to the email template itself.

Consider the following example:

	<cfset member = model("member").findByKey(newMember.id)>
	<cfset sendEmail(
		from="service@yourwebsite.com",
		to=member.email,
		template="myemailtemplate",
		subject="Thank You for Becoming a Member",
		recipientName=member.name,
		startDate=member.startDate
	)>

Here we are sending an email by including the `myemailtemplate` template and passing values for
`recipientName` and `startDate` to it.

Note that the `template` argument should be the path to the view's folder name and template file name
without the extension. If the template is in the current controller, then you don't need to specify a
folder path to the template file. In that case, just be sure to store the template file in the folder
with the rest of the views for that controller.

The logic for which template to include follows the same logic as the `template` argument to
`renderView()`.

Did you notice that we did not have to specify the `type` attribute of `cfmail`? Wheels is smart enough
to figure out that you want to send as HTML since you have tags in the email body. (You can override
this behavior if necessary though by passing in the `type` argument.)

### Multipart Emails

The intelligence doesn't end there though. You can have Wheels send a multipart email by passing in a
list of templates to the `templates` argument (notice the plural), and Wheels will automatically figure
out which one is text and which one is HTML.

Like the `template` argument, the logic for which file to include follows the same logic as the
`template` argument to `renderView()`.

### Attaching Files

You can attach files to your emails as well by using the `file` argument (or `files` argument if you
want multiple attachments). Simply pass in the name of a file that exists in the `files` folder (or a
subfolder of it) of your application. 

## Using Email Layouts

Much like the layouts outlined in the [Using Layouts][1] chapter, you can also create layouts for your
emails.

A layout should be used just as the name implies: for layout and stylistic aspects of the email body.
Based on the example given above, let's assume that the same email content needs to be sent twice:

  1. Message is sent to a new member with a stylized header and footer.
  2. A copy of message is sent to an admin at your company with a generic header and footer.

Best practice is that variables (such as `recipientName` and `startDate`, in the example above) be
placed as outputs in the template file.

In this case, the 2 calls to `sendEmail()` would be nearly identical, with the exception of the `layout`
attribute.

	<!--- Get new member --->
	<cfset member = model("member").findByKey(params.key)>
	
	<!--- Customer email with customized header/footer --->
	<cfset sendEmail(
		from="service@yourwebsite.com",
		template="myemailtemplate",
		layout="customer",
		to=member.email,
		subject="Thank You for Becoming a Member",
		recipientName=member.name,
		startDate=member.startDate
	)>
	
	<!--- Plain text message with "admin" layout --->
	<cfset sendEmail(
		from="service@yourwebsite.com",
		template="myemailtemplate",
		layout="admin",
		to="admin@domain.com",
		subject="Membership Verification: #member.name#",
		recipientName=member.name,
		startDate=member.startDate
	)>

### Multipart Email Layouts

Wheels also lets you set up layouts for the HTML and plain text parts in a multipart email.

If we set up generic email layouts at `views/plainemaillayout.cfm` and `views/htmlemaillayout.cfm`, we
would call `sendEmail()` like so:

	<!---Multipart customer email --->
	<cfset sendEmail(
		from="service@yourwebsite.com",
		templates="/myemailtemplateplain,/myemailtemplatehtml",
		layouts="customerPlain,customerHtml",
		to=member.email,
		subject="Thank You for Becoming a Member",
		recipientName=member.name,
		startDate=member.startDate
	)>

For both the `templates` and `layouts` arguments (again, notice the plurals), we provide a list of view
files to use. Wheels will figure out which of the templates and layouts are the HTML versions and
separate out the MIME parts for you automatically.

## Go Send Some Emails

Now you're all set to send emails the Wheels way. Just don't be a spammer, please!

[1]: ../05%20Displaying%20Views%20to%20Users/04%20Using%20Layouts.md
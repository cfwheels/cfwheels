<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="test", action="test"}>
	<cfset loc.controller = controller("dummy", params)>

	<cffunction name="setup">
		<cfset args = StructNew()>
		<cfset args.subject = "dummy subject">
		<cfset args.to = "to-dummy@dummy.com">
		<cfset args.from = "from-dummy@dummy.com">
		<cfset args.deliver = false>
		<cfset oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
		<cfset oldFilePath = application.wheels.filePath>
		<cfset application.wheels.filePath = "wheels/tests/_assets/files">
		<cfset oldArgs = application.wheels.functions.sendEmail>
		<cfset textBody = "dummy plain email body">
		<cfset HTMLBody = "<p>dummy html email body</p>">
		<cfset filePath = ExpandPath(application.wheels.filePath) & "/" & "emailcontent.txt">
	</cffunction>

 	<cffunction name="test_allow_default_for_from_to_and_subject">
		<cfset application.wheels.functions.sendEmail.from = "sender@example.com">
		<cfset application.wheels.functions.sendEmail.to = "recipient@example.com">
		<cfset application.wheels.functions.sendEmail.subject = "test email">
		<cfset loc.r = default_args(template="")>
		<cfset assert('loc.r.from eq "sender@example.com"')>
		<cfset assert('loc.r.to eq "recipient@example.com"')>
		<cfset assert('loc.r.subject eq "test email"')>
		<cfset loc.r = default_args(template="", from="custom_sender@example.com", to="custom_recipient@example.com", subject="custom suject")>
		<cfset assert('loc.r.from eq "custom_sender@example.com"')>
		<cfset assert('loc.r.to eq "custom_recipient@example.com"')>
		<cfset assert('loc.r.subject eq "custom suject"')>
	</cffunction>

	<cffunction name="test_sendemail_plain">
		<cfset args.template = "plainEmailTemplate">
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("ListLen(StructKeyList(result)) IS 6")>
		<cfset assert("StructKeyExists(result, 'to')")>
		<cfset assert("StructKeyExists(result, 'from')")>
		<cfset assert("StructKeyExists(result, 'subject')")>
		<cfset assert("result.type IS 'text'")>
		<cfset assert("result.text IS textBody")>
		<cfset assert("result.html IS ''")>
	</cffunction>

	<cffunction name="test_sendemail_html">
		<cfset args.template = "HTMLEmailTemplate">
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.type IS 'html'")>
		<cfset assert("result.text IS ''")>
		<cfset assert("result.html IS HTMLBody")>
	</cffunction>

	<cffunction name="test_sendemail_detectmultipart_with_html">
		<cfset args.template = "HTMLEmailTemplate">
		<cfset args.detectMultipart = true>
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.type IS 'html'")>
	</cffunction>

	<cffunction name="test_sendemail_detectmultipart_with_plain">
		<cfset args.template = "plainEmailTemplate">
		<cfset args.detectMultipart = true>
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.type IS 'text'")>
	</cffunction>

	<cffunction name="test_sendemail_type_argument_without_detectmultipart">
		<cfset args.template = "plainEmailTemplate">
		<cfset args.type = "html">
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.type IS 'html'")>
	</cffunction>

	<cffunction name="test_sendemail_combined_in_correct_order">
		<cfset args.templates = "HTMLEmailTemplate,plainEmailTemplate">
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.mailparts[1].type IS 'text' AND result.mailparts[2].tagContent IS HTMLBody")>
	</cffunction>

	<cffunction name="test_sendemail_with_layout">
		<cfset args.template = "HTMLEmailTemplate">
		<cfset args.layout = "emailLayout">
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.html Contains '<div>'")>
	</cffunction>

	<cffunction name="test_sendemail_with_attachment">
		<cfset args.template = "plainEmailTemplate">
		<cfset args.file = "cfwheels-logo.png">
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.mailparams[1].file Contains '_assets' AND result.mailparams[1].file Contains 'cfwheels-logo.png'")>
	</cffunction>

	<cffunction name="test_sendemail_with_attachments_external">
		<cfset args.template = "plainEmailTemplate">
		<cfset args.file = "cfwheels-logo.png,http://www.example.com/test.txt,c:\inetpub\wwwroot\cfwheels\something.pdf">
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.mailparams[1].file Contains '_assets' AND result.mailparams[1].file Contains 'cfwheels-logo.png'")>
		<cfset assert("result.mailparams[2].file eq 'http://www.example.com/test.txt'")>
		<cfset assert("result.mailparams[3].file eq 'c:\inetpub\wwwroot\cfwheels\something.pdf'")>
	</cffunction>

	<cffunction name="test_sendemail_with_custom_argument">
		<cfset args.template = "plainEmailTemplate">
		<cfset args.customArgument = "IPassedInThisAsACustomArgument">
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.text Contains 'IPassedInThisAsACustomArgument'")>
	</cffunction>

	<cffunction name="test_sendemail_from_different_path">
		<cfset args.template = "/shared/anotherPlainEmailTemplate">
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.text IS 'another dummy plain email body'")>
	</cffunction>

	<cffunction name="test_sendemail_from_sub_folder">
		<cfset args.template = "sub/anotherHTMLEmailTemplate">
		<cfset result = loc.controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.html IS '<p>another dummy html email body</p>'")>
	</cffunction>

	<cffunction name="test_sendemail_with_writetofile">
		<cfset args.templates = "HTMLEmailTemplate,plainEmailTemplate">
		<cfset args.writeToFile = filePath>
		<cfif FileExists(filePath)>
			<cffile action="delete" file="#filePath#">
		</cfif>
		<cfset loc.controller.sendEmail(argumentCollection=args)>
		<cffile action="read" file="#filePath#" variable="fileContent">
		<cffile action="delete" file="#filePath#">
		<cfset assert("fileContent contains HTMLBody")>
		<cfset assert("fileContent contains textBody")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.viewPath = oldViewPath>
		<cfset application.wheels.filePath = oldFilePath>
		<cfset application.wheels.functions.sendEmail = oldArgs>
	</cffunction>

	<cffunction name="default_args">
		<cfset $args(args=arguments, name="sendEmail", required="template,from,to,subject")>
		<cfreturn arguments>
	</cffunction>

</cfcomponent>

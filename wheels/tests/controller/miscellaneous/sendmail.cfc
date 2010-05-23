<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="test", action="test"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset args = StructNew()>
		<cfset args.subject = "dummy subject">
		<cfset args.to = "to-dummy@dummy.com">
		<cfset args.from = "from-dummy@dummy.com">
		<cfset args.$deliver = false>
		<cfset oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
		<cfset oldFilePath = application.wheels.filePath>
		<cfset application.wheels.filePath = "wheels/tests/_assets/files">
	</cffunction>

	<cffunction name="test_send_plain">
		<cfset args.template = "plainEmailTemplate">
		<cfset result = controller.sendEmail(argumentCollection=args)>
		<cfset assert("ListLen(StructKeyList(result)) IS 5 AND StructKeyExists(result, 'to') AND StructKeyExists(result, 'from') AND StructKeyExists(result, 'subject') AND result.type IS 'text' AND result.tagContent IS 'dummy plain email body'")>
	</cffunction>

	<cffunction name="test_send_html">
		<cfset args.template = "HTMLEmailTemplate">
		<cfset result = controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.type IS 'html' AND result.tagContent IS '<p>dummy html email body</p>'")>
	</cffunction>

	<cffunction name="test_send_combined_in_correct_order">
		<cfset args.templates = "HTMLEmailTemplate,plainEmailTemplate">
		<cfset result = controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.mailparts[1].type IS 'text' AND result.mailparts[2].tagContent IS '<p>dummy html email body</p>'")>
	</cffunction>

	<cffunction name="test_send_with_layout">
		<cfset args.template = "HTMLEmailTemplate">
		<cfset args.layout = "emailLayout">
		<cfset result = controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.tagContent Contains '<div>'")>
	</cffunction>

	<cffunction name="test_send_with_attachment">
		<cfset args.template = "plainEmailTemplate">
		<cfset args.file = "wheelslogo.jpg">
		<cfset result = controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.mailparams[1].file Contains '_assets' AND result.mailparams[1].file Contains 'wheelslogo.jpg'")>
	</cffunction>

	<cffunction name="test_send_with_custom_argument">
		<cfset args.template = "plainEmailTemplate">
		<cfset args.customArgument = "IPassedInThisAsACustomArgument">
		<cfset result = controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.tagContent Contains 'IPassedInThisAsACustomArgument'")>
	</cffunction>

	<cffunction name="test_send_from_different_path">
		<cfset args.template = "/shared/anotherPlainEmailTemplate">
		<cfset result = controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.tagContent IS 'another dummy plain email body'")>
	</cffunction>

	<cffunction name="test_send_from_sub_folder">
		<cfset args.template = "sub/anotherHTMLEmailTemplate">
		<cfset result = controller.sendEmail(argumentCollection=args)>
		<cfset assert("result.tagContent IS '<p>another dummy html email body</p>'")>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.viewPath = oldViewPath>
		<cfset application.wheels.filePath = oldFilePath>
	</cffunction>

</cfcomponent>
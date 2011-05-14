<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset $ENV = duplicate(application)>
		<cfset params = {controller="test", action="test"}>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
	</cffunction>

	<cffunction name="teardown">
		<cfset application = $ENV>
		<cfset $header(name="content-type", value="text/html" , charset="utf-8") />
	</cffunction>


	<cffunction name="test_throws_error_without_data_argument">
		<cfset loc.controller = controller("test", params)>
		<cftry>
			<cfset result = loc.controller.renderWith()>
			<cfcatch type="any">
				<cfset assert('true eq true') />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="test_renderingError_raised_when_template_is_not_found_for_format">
		<cfset params.format = "xls">
		<cfset params.action = "notfound">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("xml") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset loc.r = raised('loc.controller.renderWith(data=user, layout=false, returnAs="string")')>
		<cfset loc.e = "Wheels.renderingError">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_current_action_as_xml_with_template_returning_string_to_controller">
		<cfset params.format = "xml">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("xml") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset loc.data = loc.controller.renderWith(data=user, layout=false, returnAs="string")>
		<cfset assert("loc.data Contains 'xml template content'")>
	</cffunction>

	<cffunction name="test_current_action_as_xml_with_template">
		<cfset params.format = "xml">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("xml") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset loc.controller.renderWith(data=user, layout=false)>
		<cfset assert("loc.controller.response() Contains 'xml template content'")>
	</cffunction>

	<cffunction name="test_current_action_as_xml_without_template">
		<cfset params.action = "test2">
		<cfset params.format = "xml">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("xml") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset loc.controller.renderWith(data=user)>
		<cfset assert("IsXml(loc.controller.response()) eq true")>
	</cffunction>

	<cffunction name="test_current_action_as_xml_without_template_returning_string_to_controller">
		<cfset params.action = "test2">
		<cfset params.format = "xml">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("xml") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset loc.data = loc.controller.renderWith(data=user, returnAs="string")>
		<cfset assert("IsXml(loc.data) eq true")>
	</cffunction>

	<cffunction name="test_current_action_as_json_with_template">
		<cfset params.format = "json">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset loc.controller.renderWith(data=user, layout=false)>
		<cfset assert("loc.controller.response() Contains 'json template content'")>
	</cffunction>

	<cffunction name="test_current_action_as_json_without_template">
		<cfset params.action = "test2">
		<cfset params.format = "json">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset loc.controller.renderWith(data=user)>
		<cfset assert("IsJSON(loc.controller.response()) eq true")>
	</cffunction>

	<cffunction name="test_current_action_as_json_without_template_returning_string_to_controller">
		<cfset params.action = "test2">
		<cfset params.format = "json">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset loc.data = loc.controller.renderWith(data=user, returnAs="string")>
		<cfset assert("IsJSON(loc.data) eq true")>
	</cffunction>

	<cffunction name="test_current_action_as_pdf_with_template_throws_error">
		<cfset params.format = "pdf">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("pdf") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cftry>
			<cfset loc.controller.renderWith(data=user, layout=false)>
			<cfset fail(message="Error did not occur.")>
			<cfcatch type="any">
				<cfset assert("true eq true")>
			</cfcatch>
		</cftry>
	</cffunction>

 	<cffunction name="test_current_action_as_json_with_template_in_production">
		<cfset application.wheels.cacheFileChecking = true>
		<cfset params.format = "json">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset loc.controller.renderWith(data=user, layout=false)>
		<cfset assert("loc.controller.response() Contains 'json template content'")>
	</cffunction>

</cfcomponent>
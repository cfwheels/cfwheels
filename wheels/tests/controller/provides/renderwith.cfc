<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset params = {controller="test", action="test"}>
		<cfset $$oldViewPath = application.wheels.viewPath>
		<cfset application.wheels.viewPath = "wheels/tests/_assets/views">
	</cffunction>
	
	<cffunction name="teardown">
		<cfset params = {controller="test", action="test"}>
		<cfset application.wheels.viewPath = $$oldViewPath>
		<cfset $header(name="content-type", value="text/html" , charset="utf-8") />
	</cffunction>

	
	<cffunction name="test_throws_error_without_data_argument">
		<cfset controller = $controller(name="test").$createControllerObject(params)>
		<cftry>
			<cfset result = controller.renderWith()>
			<cfcatch type="any">
				<cfset assert('true eq true') />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="test_current_action_as_xml_with_template">
		<cfset params.format = "xml">
		<cfset controller = $controller(name="test").$createControllerObject(params)>
		<cfset controller.provides("xml") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset controller.renderWith(data=user, layout=false)>
		<cfset assert("controller.response() Contains 'xml template content'")>
	</cffunction>

	<cffunction name="test_current_action_as_xml_without_template">
		<cfset params.action = "test2">
		<cfset params.format = "xml">
		<cfset controller = $controller(name="test").$createControllerObject(params)>
		<cfset controller.provides("xml") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset controller.renderWith(data=user)>
		<cfset assert("IsXml(controller.response()) eq true")>
	</cffunction>

	<cffunction name="test_current_action_as_json_with_template">
		<cfset params.format = "json">
		<cfset controller = $controller(name="test").$createControllerObject(params)>
		<cfset controller.provides("json") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset controller.renderWith(data=user, layout=false)>
		<cfset assert("controller.response() Contains 'json template content'")>
	</cffunction>

	<cffunction name="test_current_action_as_json_without_template">
		<cfset params.action = "test2">
		<cfset params.format = "json">
		<cfset controller = $controller(name="test").$createControllerObject(params)>
		<cfset controller.provides("json") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cfset controller.renderWith(data=user)>
		<cfset assert("IsJSON(controller.response()) eq true")>
	</cffunction>

	<cffunction name="test_current_action_as_pdf_with_template_throws_error">
		<cfset params.format = "pdf">
		<cfset controller = $controller(name="test").$createControllerObject(params)>
		<cfset controller.provides("pdf") />
		<cfset user = model("user").findOne(where="username = 'tonyp'") />
		<cftry>
			<cfset controller.renderWith(data=user, layout=false)>
			<cfset fail(message="Error did not occur.")>
			<cfcatch type="any">
				<cfset assert("true eq true")>
			</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>
<cfcomponent extends="wheelsMapping.Test">

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

	<!--- Helper function for getting correct HTTP statusCode --->
	<cffunction name="responseCode" output="false">
	  <cfif StructKeyExists(server, "lucee")>   
	    <cfreturn getPageContext().getResponse().getStatus()>    
	  <cfelse>
	    <cfreturn getPageContext().getFusionContext().getResponse().getStatus()> 
	  </cfif> 
	</cffunction>

	<!--- <cffunction name="test_json_integer">
		<cfset params = {controller="dummy", action="dummy", format = "json"}>
		<cfset loc.controller = controller("dummy", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findAll(where="username = 'tonyp'", returnAs="structs")>
		<cfset loc.result = loc.controller.renderWith(data=user, zipCode="integer", returnAs="string")>
		<cfset assert("loc.result Contains ':11111,'")>
	</cffunction> --->
	
	<!--- <cffunction name="test_json_string">
		<cfset params = {controller="dummy", action="dummy", format = "json"}>
		<cfset loc.controller = controller("dummy", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findAll(where="username = 'tonyp'", returnAs="structs")>
		<cfset loc.result = loc.controller.renderWith(data=user, phone="string", returnAs="string")>
		<cfset assert("loc.result Contains '1235551212'")>
	</cffunction> --->

	<cffunction name="test_throws_error_without_data_argument">
		<cfset loc.controller = controller("test", params)>
		<cftry>
			<cfset result = loc.controller.renderWith()>
			<cfcatch type="any">
				<cfset assert('true eq true') />
			</cfcatch>
		</cftry>
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

	<!--- Custom Status Codes; probably no need to test all 75 odd ---> 
	<cffunction name="test_custom_status_codes_no_argument_passed">
		<cfset params.format = "json">
		<cfset params.action = "test2">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.r = loc.controller.renderWith(data=user, layout=false, returnAs="string")> 
		<cfset assert("responseCode() EQ 200")>  
	</cffunction>

	<cffunction name="test_custom_status_codes_204">
		<cfset params.format = "json">
		<cfset params.action = "test2">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.r = loc.controller.renderWith(data=user, layout=false, returnAs="string", status=204)>  
		<cfset assert("responseCode() EQ 204")>   
	</cffunction>

	<cffunction name="test_custom_status_codes_403">
		<cfset params.format = "json">
		<cfset params.action = "test2">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.r = loc.controller.renderWith(data=user, layout=false, returnAs="string", status=403)>  
		<cfset assert("responseCode() EQ 403")>   
	</cffunction>

	<cffunction name="test_custom_status_codes_404">
		<cfset params.format = "json">
		<cfset params.action = "test2">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.r = loc.controller.renderWith(data=user, layout=false, returnAs="string", status=404)>  
		<cfset assert("responseCode() EQ 404")> 
	</cffunction>

	<cffunction name="test_custom_status_codes_OK">
		<cfset params.format = "json">
		<cfset params.action = "test2">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.r = loc.controller.renderWith(data=user, layout=false, returnAs="string", status="OK")> 
		<cfset assert("responseCode() EQ 200")>   
	</cffunction> 
	<cffunction name="test_custom_status_codes_Not_Found">
		<cfset getPageContext().getResponse().setStatus("100")>
		<cfset params.format = "json">
		<cfset params.action = "test2">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.r = loc.controller.renderWith(data=user, layout=false, returnAs="string", status="Not Found")>
		<cfset assert("responseCode() EQ 404")>  
	</cffunction>
	<cffunction name="test_custom_status_codes_Method_Not_Allowed">
		<cfset getPageContext().getResponse().setStatus("100")>
		<cfset params.format = "json">
		<cfset params.action = "test2">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.r = loc.controller.renderWith(data=user, layout=false, returnAs="string", status="Method Not Allowed")> 
		<cfset assert("responseCode() EQ 405")> 
	</cffunction>

	<cffunction name="test_custom_status_codes_Method_Not_Allowed_case">
		<cfset getPageContext().getResponse().setStatus("100")>
		<cfset params.format = "json">
		<cfset params.action = "test2">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.r = loc.controller.renderWith(data=user, layout=false, returnAs="string", status="method not allowed")> 
		<cfset assert("responseCode() EQ 405")>   
	</cffunction>  

	<cffunction name="test_custom_status_codes_bad_numeric">
		<cfset params.format = "json">
		<cfset params.action = "test2">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.r = raised('loc.controller.renderWith(data=user, layout=false, returnAs="string", status=987654321)')> 
		<cfset loc.e = "Wheels.renderingError"> 
		<cfset assert("loc.e EQ loc.r")> 
	</cffunction>

	<cffunction name="test_custom_status_codes_bad_text">
		<cfset params.format = "json">
		<cfset params.action = "test2">
		<cfset loc.controller = controller("test", params)>
		<cfset loc.controller.provides("json")>
		<cfset user = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.r = raised('loc.controller.renderWith(data=user, layout=false, returnAs="string", status="THECAKEISALIE")')>
		<cfset loc.e = "Wheels.renderingError">  
		<cfset assert("loc.e EQ loc.r")> 
	</cffunction>

</cfcomponent>
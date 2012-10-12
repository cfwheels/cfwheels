<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset params.controller = "Blog">
		<cfset params.action = "edit">
		<cfset params.key = "1">

		<cfset loc.controller = controller(params.controller, params)>
		<cfset loc.args = {}>
		<cfset loc.args.controller = "Blog">
		<cfset loc.args.action = "edit">
		<cfset loc.args.key = "1">
		<cfset loc.args.params = "param1=foo&param2=bar">
		<cfset loc.args.$URLRewriting = "On">
		<cfset oldScriptName = request.cgi.script_name>
	</cffunction>

	<cffunction name="teardown">
		<cfset request.cgi.script_name = oldScriptName>
	</cffunction>

	<cffunction name="test_all_arguments_with_url_rewriting">
		<cfset request.cgi.script_name = "/rewrite.cfm">
		<cfset loc.e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar">
		<cfset loc.r = loc.controller.urlFor(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_missing_controller_with_url_rewriting">
		<cfset request.cgi.script_name = "/rewrite.cfm">
		<cfset StructDelete(loc.args, "controller")>
		<cfset loc.e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar">
		<cfset loc.r = loc.controller.urlFor(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_missing_action_with_url_rewriting">
		<cfset request.cgi.script_name = "/rewrite.cfm">
		<cfset StructDelete(loc.args, "action")>
		<cfset loc.e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar">
		<cfset loc.r = loc.controller.urlFor(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_missing_controller_and_action_with_url_rewriting">
		<cfset request.cgi.script_name = "/rewrite.cfm">
		<cfset StructDelete(loc.args, "controller")>
		<cfset StructDelete(loc.args, "action")>
		<cfset loc.e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar">
		<cfset loc.r = loc.controller.urlFor(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_all_arguments_without_url_rewriting">
		<cfset request.cgi.script_name = "/index.cfm">
		<cfset loc.args.$URLRewriting = "Off">
		<cfset loc.webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/")>
		<cfset loc.e = "#loc.webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar">
		<cfset loc.r = loc.controller.urlFor(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_missing_controller_without_url_rewriting">
		<cfset request.cgi.script_name = "/index.cfm">
		<cfset loc.args.$URLRewriting = "Off">
		<cfset StructDelete(loc.args, "controller")>
		<cfset loc.webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/")>
		<cfset loc.e = "#loc.webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar">
		<cfset loc.r = loc.controller.urlFor(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_missing_action_without_url_rewriting">
		<cfset request.cgi.script_name = "/index.cfm">
		<cfset loc.args.$URLRewriting = "Off">
		<cfset StructDelete(loc.args, "action")>
		<cfset loc.webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/")>
		<cfset loc.e = "#loc.webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar">
		<cfset loc.r = loc.controller.urlFor(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_missing_controller_and_action_without_url_rewriting">
		<cfset request.cgi.script_name = "/index.cfm">
		<cfset loc.args.$URLRewriting = "Off">
		<cfset StructDelete(loc.args, "controller")>
		<cfset StructDelete(loc.args, "action")>
		<cfset loc.webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/")>
		<cfset loc.e = "#loc.webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar">
		<cfset loc.r = loc.controller.urlFor(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_any_variable_type_can_be_used_as_params">
		<cfset request.cgi.script_name = "/index.cfm">
		<cfset loc.args.$URLRewriting = "Off">
		<cfset loc.args.params = {}>
		<cfset loc.args.params["param1"] = "foo1">
		<cfset loc.args.params["param2"] = "bar2">
		<cfset StructDelete(loc.args, "controller")>
		<cfset StructDelete(loc.args, "action")>
		<cfset loc.webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/")>
		<cfset loc.e = "#loc.webRoot#?controller=blog&action=edit&key=1&param1=foo1&param2=bar2">
		<cfset loc.r = loc.controller.urlFor(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>
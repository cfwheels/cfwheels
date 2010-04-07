<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset params.controller = "Blog">
	<cfset params.action = "edit">
	<cfset params.key = "1">

	<cfset global.controller = $controller(name=params.controller).$createControllerObject(params)>
	<cfset global.args = {}>
	<cfset global.args.controller = "Blog">
	<cfset global.args.action = "edit">
	<cfset global.args.key = "1">
	<cfset global.args.params = "param1=foo&param2=bar">
	<cfset global.args.$URLRewriting = "On">

	<cffunction name="setup">
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

</cfcomponent>
<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset request.cgi.http_x_requested_with = "">
	</cffunction>

	<cffunction name="test_using_method">
		<cfset loc.args = {template="controller_layout_test"}>
		<cfset params = {controller="dummy", action="index"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
		<cfset controller.controller_layout_test = controller_layout_test>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "index_layout">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "show_layout">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset loc.e = "true">
		<cfset loc.r = controller.$useLayout("list")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset loc.args.usedefault = false>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "index_layout">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "show_layout">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset loc.e = "false">
		<cfset loc.r = controller.$useLayout("list")>
		<cfset assert('loc.e eq loc.r')>

		<cfset request.cgi.http_x_requested_with = "XMLHTTPRequest">
	
		<cfset loc.e = "index_layout">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>	
	
	</cffunction>
	
	<cffunction name="test_using_method_ajax">
		<cfset request.cgi.http_x_requested_with = "XMLHTTPRequest">
		<cfset loc.args = {template="controller_layout_test", ajax="controller_layout_test_ajax"}>
		<cfset params = {controller="dummy", action="index"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
		<cfset controller.controller_layout_test = controller_layout_test>
		<cfset controller.controller_layout_test_ajax = controller_layout_test_ajax>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "index_layout_ajax">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "show_layout_ajax">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset loc.e = "true">
		<cfset loc.r = controller.$useLayout("list")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset loc.args.usedefault = false>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "index_layout_ajax">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "show_layout_ajax">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset loc.e = "false">
		<cfset loc.r = controller.$useLayout("list")>
		<cfset assert('loc.e eq loc.r')>

	</cffunction>

	<cffunction name="test_should_respect_exceptions">
		<cfset loc.args = {template="mylayout", except="index"}>
		<cfset params = {controller="dummy", action="index"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "mylayout">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "true">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.args.usedefault = false>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "false">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset request.cgi.http_x_requested_with = "XMLHTTPRequest">
		
		<cfset loc.e = "mylayout">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>
		
	</cffunction>
	
	<cffunction name="test_should_respect_exceptions_ajax">
		<cfset request.cgi.http_x_requested_with = "XMLHTTPRequest">
		<cfset loc.args = {template="mylayout", ajax="mylayout_ajax", except="index"}>
		<cfset params = {controller="dummy", action="index"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "mylayout_ajax">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "true">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.args.usedefault = false>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "false">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_should_respect_only">
		<cfset loc.args = {template="mylayout", only="index"}>
		<cfset params = {controller="dummy", action="index"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "true">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "mylayout">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.args.usedefault = false>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "false">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset request.cgi.http_x_requested_with = "XMLHTTPRequest">
		
		<cfset loc.e = "mylayout">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>		
		
	</cffunction>
	
	<cffunction name="test_should_respect_only_ajax">
		<cfset request.cgi.http_x_requested_with = "XMLHTTPRequest">
		<cfset loc.args = {template="mylayout", ajax="mylayout_ajax", only="index"}>
		<cfset params = {controller="dummy", action="index"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "true">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "mylayout_ajax">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.args.usedefault = false>
		<cfset controller.usesLayout(argumentCollection=loc.args)>
		
		<cfset loc.e = "false">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="controller_layout_test">
		<cfif arguments.action eq "index">
			<cfreturn "index_layout">
		</cfif>
		<cfif arguments.action eq "show">
			<cfreturn "show_layout">
		</cfif>
	</cffunction>
	
	<cffunction name="controller_layout_test_ajax">
		<cfif arguments.action eq "index">
			<cfreturn "index_layout_ajax">
		</cfif>
		<cfif arguments.action eq "show">
			<cfreturn "show_layout_ajax">
		</cfif>
	</cffunction>
	
</cfcomponent>
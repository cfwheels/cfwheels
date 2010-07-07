<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_using_method">
		<cfset params = {controller="dummy", action="index"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
		<cfset controller.controller_layout_test = controller_layout_test>
		<cfset controller.usesLayout(template="controller_layout_test")>
		
		<cfset loc.e = "index_layout">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "show_layout">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset loc.e = "true">
		<cfset loc.r = controller.$useLayout("list")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset controller.usesLayout(template="controller_layout_test", usedefault=false)>
		
		<cfset loc.e = "index_layout">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "show_layout">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset loc.e = "false">
		<cfset loc.r = controller.$useLayout("list")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_should_respect_exceptions">
		<cfset params = {controller="dummy", action="index"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
		<cfset controller.usesLayout(template="mylayout", except="index")>
		
		<cfset loc.e = "mylayout">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "true">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset controller.usesLayout(template="mylayout", except="index", usedefault=false)>
		<cfset loc.e = "false">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_should_respect_only">
		<cfset params = {controller="dummy", action="index"}>
		<cfset controller = $controller(name="dummy").$createControllerObject(params)>
		<cfset controller.usesLayout(template="mylayout", only="index")>
		
		<cfset loc.e = "true">
		<cfset loc.r = controller.$useLayout("show")>
		<cfset assert('loc.e eq loc.r')>

		<cfset loc.e = "mylayout">
		<cfset loc.r = controller.$useLayout("index")>
		<cfset assert('loc.e eq loc.r')>

		<cfset controller.usesLayout(template="mylayout", only="index", usedefault=false)>
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
	
</cfcomponent>
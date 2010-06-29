<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setupAndTeardown.cfm">

	<cffunction name="test_should_use_class_layout">
		<cfset params = {controller="LayoutActionTest", action="noexists"}>
		<cfset controller = $controller(name="LayoutActionTest").$createControllerObject(params)>
		<cfset controller.$processAction()>
		<cfset loc.e = "class_layout">
		<cfset loc.r = controller.$layoutForAction(params.action)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_should_use_instance_layout">
		<cfset params = {controller="LayoutActionTest", action="index"}>
		<cfset controller = $controller(name="LayoutActionTest").$createControllerObject(params)>
		<cfset controller.$processAction()>
		<cfset loc.e = "instance_layout">
		<cfset loc.r = controller.$layoutForAction(params.action)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_should_respect_exceptions">
		<cfset params = {controller="LayoutExceptTest", action="action1"}>
		<cfset controller = $controller(name="LayoutExceptTest").$createControllerObject(params)>
		<cfset controller.$processAction()>
		<cfset loc.e = false>
		<cfset loc.r = controller.$layoutForAction(params.action)>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset params = {controller="LayoutExceptTest", action="action2"}>
		<cfset controller = $controller(name="LayoutExceptTest").$createControllerObject(params)>
		<cfset controller.$processAction()>
		<cfset loc.e = false>
		<cfset loc.r = controller.$layoutForAction(params.action)>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset params = {controller="LayoutExceptTest", action="index"}>
		<cfset controller = $controller(name="LayoutExceptTest").$createControllerObject(params)>
		<cfset controller.$processAction()>
		<cfset loc.e = "class_layout">
		<cfset loc.r = controller.$layoutForAction(params.action)>
		<cfset assert('loc.e eq loc.r')>		
	</cffunction>
	
	<cffunction name="test_should_respect_only">
		<cfset params = {controller="LayoutExceptTest", action="action1"}>
		<cfset controller = $controller(name="LayoutExceptTest").$createControllerObject(params)>
		<cfset controller.$processAction()>
		<cfset loc.e = false>
		<cfset loc.r = controller.$layoutForAction(params.action)>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset params = {controller="LayoutExceptTest", action="action2"}>
		<cfset controller = $controller(name="LayoutExceptTest").$createControllerObject(params)>
		<cfset controller.$processAction()>
		<cfset loc.e = false>
		<cfset loc.r = controller.$layoutForAction(params.action)>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset params = {controller="LayoutExceptTest", action="index"}>
		<cfset controller = $controller(name="LayoutExceptTest").$createControllerObject(params)>
		<cfset controller.$processAction()>
		<cfset loc.e = "class_layout">
		<cfset loc.r = controller.$layoutForAction(params.action)>
		<cfset assert('loc.e eq loc.r')>		
	</cffunction>
	
</cfcomponent>
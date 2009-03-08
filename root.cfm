<cfif arguments.objectType IS "pluginObject">
	<cfset loc.returnValue = CreateObject("component", "#application.wheels.pluginComponentPath#.#arguments.fileName#").init()>
<cfelseif arguments.objectType IS "controllerClass">
	<cfset loc.returnValue = CreateObject("component", "#application.wheels.controllerComponentPath#.#arguments.fileName#").$initControllerClass(argumentCollection=arguments)>
<cfelseif arguments.objectType IS "controllerObject">
	<cfset loc.returnValue = CreateObject("component", "#application.wheels.controllerComponentPath#.#arguments.fileName#").$initControllerObject(argumentCollection=arguments)>
<cfelseif arguments.objectType IS "modelClass">
	<cfset loc.returnValue = CreateObject("component", "#application.wheels.modelComponentPath#.#arguments.fileName#").$initModelClass(argumentCollection=arguments)>
<cfelseif arguments.objectType IS "modelObject">
	<cfset loc.returnValue = CreateObject("component", "#application.wheels.modelComponentPath#.#arguments.fileName#").$initModelObject(argumentCollection=arguments)>
</cfif>
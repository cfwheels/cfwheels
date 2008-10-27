<cfif loc.rootObject IS "controllerClass">
	<cfset loc.rootObject = CreateObject("component", "#application.wheels.controllerComponentPath#.#loc.fileName#").$initControllerClass(arguments.name)>
<cfelseif loc.rootObject IS "controllerObject">
	<cfset loc.rootObject = CreateObject("component", "#application.wheels.controllerComponentPath#.#loc.fileName#").$initControllerObject(variables.wheels.name, arguments.params)>
<cfelseif loc.rootObject IS "modelClass">
	<cfset loc.rootObject = CreateObject("component", "#application.wheels.modelComponentPath#.#loc.fileName#").$initClass(arguments.name)>
<cfelseif loc.rootObject IS "modelObject">
	<cfset loc.rootObject = CreateObject("component", "#application.wheels.modelComponentPath#.#loc.fileName#").$initObject(name=variables.wheels.class.name, properties=arguments.properties, persisted=arguments.persisted, row=arguments.row)>
<cfelseif loc.rootObject IS "pluginObject">
	<cfset loc.rootObject = CreateObject("component", "#application.wheels.pluginComponentPath#.#loc.fileName#").init()>
</cfif>
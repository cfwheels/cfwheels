<cfscript>
// Core API embedded documentation

	param name="request.wheels.params.type" default="core";
	param name="request.wheels.params.format" default="html";

	documentScope=[];

	// Plugins First, as they can potentially hijack an internal function
	if(application.wheels.enablePluginsComponent){
	for(local.plugin in application.wheels.plugins){
		arrayAppend(documentScope, {
			"name": local.plugin,
			"scope":  application.wheels.plugins[local.plugin]
		});
	}}

	arrayAppend(documentScope, {
			"name": "controller",
			"scope": createObject("component", "app.controllers.Controller")
	});
	arrayAppend(documentScope, {
			"name": "model",
			"scope": createObject("component", "app.models.Model")
	});
	arrayAppend(documentScope, {
			"name": "mapper",
			"scope": application.wheels.mapper
	});
	if(application.wheels.enablePluginsComponent){
		arrayAppend(documentScope, {
				"name": "migrator",
				"scope": application.wheels.migrator
		});
		arrayAppend(documentScope, {
				"name": "migration",
				"scope": createObject("component", "app.wheels.migrator.Migration")
		});
		arrayAppend(documentScope, {
				"name": "tabledefinition",
				"scope": createObject("component", "app.wheels.migrator.TableDefinition")
		});
	}
	// Array of functions to ignore
	ignore = ["config","init"];

	// Populate the main documentation
	docs=$returnInternalDocumentation(documentScope,ignore);

	include "layouts/#request.wheels.params.format#.cfm";
</cfscript>

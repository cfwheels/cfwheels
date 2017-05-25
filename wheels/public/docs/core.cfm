<cfscript>
// Core API embedded documentation

	param name="params.type" default="core";
	param name="params.format" default="html";

	documentScope=[];

	// Plugins First, as they can potentially hijack an internal function
	for(local.plugin in application.wheels.plugins){
		arrayAppend(documentScope, {
			"name": local.plugin,
			"scope":  application.wheels.plugins[local.plugin]
		});
	}
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
	arrayAppend(documentScope, {
			"name": "migrator",
			"scope": application.wheels.migrator
	});

	// Array of functions to ignore
	ignore = ["config","init"];

	// Populate the main documentation
	docs=$returnInternalDocumentation(documentScope,ignore);

	include "layouts/#params.format#.cfm";
</cfscript>

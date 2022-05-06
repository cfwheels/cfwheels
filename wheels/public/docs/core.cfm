<cfscript>
// Core API embedded documentation

param name="request.wheels.params.type" default="core";
param name="request.wheels.params.format" default="html";

if (StructKeyExists(application.wheels, "docs")) {
	docs = application.wheels.docs;
} else {
	documentScope = [];

	// Plugins First, as they can potentially hijack an internal function
	if (application.wheels.enablePluginsComponent) {
		for (local.plugin in application.wheels.plugins) {
			ArrayAppend(documentScope, {"name" = local.plugin, "scope" = application.wheels.plugins[local.plugin]});
		}
	}

	ArrayAppend(documentScope, {"name" = "controller", "scope" = CreateObject("component", "app.controllers.Controller")});
	ArrayAppend(documentScope, {"name" = "model", "scope" = CreateObject("component", "app.models.Model")});
	ArrayAppend(documentScope, {"name" = "mapper", "scope" = application.wheels.mapper});
	if (application.wheels.enablePluginsComponent) {
		ArrayAppend(documentScope, {"name" = "migrator", "scope" = application.wheels.migrator});
		ArrayAppend(
			documentScope,
			{"name" = "migration", "scope" = CreateObject("component", "app.wheels.migrator.Migration")}
		);
		ArrayAppend(
			documentScope,
			{"name" = "tabledefinition", "scope" = CreateObject("component", "app.wheels.migrator.TableDefinition")}
		);
	}
	// Array of functions to ignore
	ignore = ["config", "init"];

	// Populate the main documentation
	docs = $returnInternalDocumentation(documentScope, ignore);

	application.wheels.docs = docs;
}

include "layouts/#request.wheels.params.format#.cfm";
</cfscript>

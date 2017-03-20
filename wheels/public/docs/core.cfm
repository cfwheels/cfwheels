<cfscript>
// Core API embedded documentation

		/*
		Just here at the moment for reference
		{
			"name" = "Model Initialization",
			"categories" = [
				"Association Functions",
				"Callback Functions",
				"Miscellaneous Functions",
				"Validation Functions"
			]
		},
		{
			"name" = "Model Class",
			"categories" = [
				"Create Functions",
				"Delete Functions",
				"Miscellaneous Functions",
				"Read Functions",
				"Statistics Functions",
				"Update Functions"
			]
		},
		{
			"name" = "Model Object",
			"categories" = [
				"Change Functions",
				"CRUD Functions",
				"Error Functions",
				"Miscellaneous Functions"
			]
		},
		{
			"name" = "View Helpers",
			"categories" = [
				"Asset Functions",
				"Date Functions",
				"Error Functions",
				"Form Association Functions",
				"Form Object Functions",
				"Form Tag Functions",
				"General Form Functions",
				"Link Functions",
				"Miscellaneous Functions",
				"Sanitization Functions",
				"Text Functions"
			]
		},
		{
			"name" = "Controller",
			"categories" = [
				"Initialization Functions",
				"Flash Functions",
				"Rendering Functions",
				"Pagination Functions",
				"Provides Functions",
				"Miscellaneous Functions"
			]
		},
		{
			"name" = "Global Helpers",
			"categories" = [
				"Miscellaneous Functions",
				"String Functions"
			]
		},
		{
			"name" = "Configuration",
			"categories" = []
		}*/
	param name="params.type" default="core";
	param name="params.format" default="html";

	docs={
		"sections"=[],
		"functions"=[]
	};

	temp={
		"controller" = {
			"scope" = "",
			"functions" = ""
		},
		"model" = {
			"scope" = "",
			"functions" = ""
		}
	};

	temp.controller.scope 		= createObject("component", "app.controllers.Controller");
	temp.controller.functions 	= listSort(StructKeyList(temp.controller.scope), "textnocase");
	temp.model.scope 			= createObject("component", "app.models.Model");
	temp.model.functions 		= listSort(StructKeyList(temp.model.scope), "textnocase");

	// Array of functions to ignore
	ignore = ["init"];

	// Merge
	for(doctype in temp){
		// Populate A-Z function List
		for(functionName in listToArray(temp[doctype]['functions']) ){
			// Ignore internal functions
			if(left(functionName, 1) != "$" && !ArrayFindNoCase(ignore, functionName)){
				// Check this isn't a dupe, but record which scope this was from
				if( !ArrayFind(docs.functions, function(struct){
				   return struct.name == functionName;
				})){
					// Set metadata
					meta=$parseMetaData(GetMetaData(temp[doctype]["scope"][functionName]), doctype, functionName);
					arrayAppend(docs.functions, meta);
				} else {
					if(!ArrayFind(meta.availableIn, doctype)){
						arrayAppend(meta.availableIn, doctype);
					}
				}
			}
		}
		docs.functions = $arrayOfStructsSort(docs.functions, "name");
	}

	// Look for custom categories:
	for(doc in docs.functions){
		if(structKeyExists(doc.tags, "section") && len(doc.tags.section)){
			if( !ArrayFind(docs.sections, function(struct){
				   return struct.name == doc.tags.section;
			})){
				arrayAppend(docs.sections, {
					"name": doc.tags.section,
					"categories": []
				});
			}
			for(subsection in docs.sections){
				if(subsection.name == doc.tags.section
					&& len(doc.tags.category)
					&& !arrayFind(subsection.categories, doc.tags.category)){
						arrayAppend(subsection.categories, doc.tags.category);
				}
				arraySort(subsection.categories, "textnocase");
			}
		}
	}
	docs.sections = $arrayOfStructsSort(docs.sections, "name");

	include "layouts/#params.format#.cfm";
</cfscript>

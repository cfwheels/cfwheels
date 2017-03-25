<cfscript>
// Core API embedded documentation

	param name="params.type" default="core";
	param name="params.format" default="html";

	docs={
		"sections"=[],
		"functions"=[]
	};

	temp["mapper"]["scope"]	 			= application.wheels.mapper;
	temp["mapper"]["functions"]	 		= listSort(StructKeyList(temp.mapper.scope), "textnocase");
	temp["migrator"]["scope"]	 		= application.wheels.dbmigrate;
	temp["migrator"]["functions"]	 	= listSort(StructKeyList(temp.migrator.scope), "textnocase");
	temp["controller"]["scope"]	 		= createObject("component", "app.controllers.Controller");
	temp["controller"]["functions"]	 	= listSort(StructKeyList(temp.controller.scope), "textnocase");
	temp["model"]["scope"]	 			= createObject("component", "app.models.Model");
	temp["model"]["functions"]	 		= listSort(StructKeyList(temp.model.scope), "textnocase");

	// Array of functions to ignore
	ignore = ["init"];

	// Merge
	for(doctype in temp){
		// Populate A-Z function List
		for(functionName in listToArray(temp[doctype]['functions']) ){
			// Check this is actually a function: dbmigrate stores a struct for instance
			// Don't display internal functions, duplicates or anything in the ignore list
			if(left(functionName, 1) != "$"
				&& !ArrayFindNoCase(ignore, functionName)
				&& !isStruct(temp[doctype]["scope"][functionName])
			){
				// Get metadata
				meta=$parseMetaData(GetMetaData(temp[doctype]["scope"][functionName]), doctype, functionName);
				// Look for identically named functions
				match=ArrayFind(docs.functions, function(struct){
					return struct.name == functionName;
				});
				// If the duplicate function has an indentical hint, assume it's the same and record the additonal
				// scope it's available to: otherwise assume it's a different function, albeit with the same name
				if(match > 0 && docs.functions[match]["hint"] == meta.hint){
					arrayAppend(docs.functions[match]["availableIn"], doctype);
				} else {
					arrayAppend(docs.functions, meta);
				}
			}
		}
		docs.functions = $arrayOfStructsSort(docs.functions, "name");
	}

	// Look for section & category:
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

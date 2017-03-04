<cfprocessingdirective suppressWhitespace="true">
<cfscript>
	param name="params.type" default="core";
	param name="params.format" default="html";

	sections=[
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
		}
	];

	docs={
		"controller" = {
			"scope" = "",
			"functions" = "",
			"meta" = {},
			"categories" = [],
			"sections" = []
		},
		"model" = {
			"scope" = "",
			"functions" = "",
			"meta" = {},
			"categories" = [],
			"sections" = []
		}
	};
	switch(params.type){
		case "core":
			docs.controller.scope 		= controller("dummy");
			docs.controller.functions 	= listSort(StructKeyList(docs.controller.scope), "textnocase");
			docs.model.scope 			= createObject("component", "wheels.Model");
			docs.model.functions 		= listSort(StructKeyList(docs.model.scope), "textnocase");
		break;
		case "app":
		break;
	}


	for(doc in docs){
		for(func in listToArray(docs[doc]['functions'])){
			meta=GetMetaData(docs[doc]["scope"][func]);
			docs[doc]["meta"][func]=meta;
			if(structKeyExists(meta, "doc.section")
				&& !arrayFind(docs[doc]["sections"], meta["doc.section"])){
					arrayAppend(docs[doc]["sections"], meta["doc.section"]);
			}
			if(structKeyExists(meta, "doc.category")
				&& !arrayFind(docs[doc]["categories"], meta["doc.category"])){
					arrayAppend(docs[doc]["categories"], meta["doc.category"]);
			}
		}
	}


	// Searches for ``` in hint description output
	string function hintOutput(str){
		local.rv=arguments.str;
		// Replace backtick blocks with pre
		local.rv = ReReplaceNoCase(local.rv, '```(.+?)```', '<pre>\1</pre>', "ALL");
		// Replace single backticks with code when NOT in <pre>
		local.rv = ReReplaceNoCase(local.rv, '(?!<pre[^>]*>)(`(\w+)`)(?![^<]*<\/pre>)', '<code>\2</code>', "ALL");
		// Look for comments and add some line breaks back in
		local.rv = ReReplaceNoCase(local.rv, '\/\/ (.*?)\. ', "<br>// \1<br>", "ALL");
		local.rv = ReReplaceNoCase(local.rv, ';', "\1;<br>", "ALL");

		return trim(local.rv);
	}
	// Creates a css class from category
	string function cssClassLink(str){
		local.rv=lcase(arguments.str);
		local.rv=replace(local.rv, " ", "", "all");
		return trim(local.rv);
	}

	include "docs/#params.format#.cfm";
</cfscript>
</cfprocessingdirective>

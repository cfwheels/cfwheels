<cfscript>
	param name="params.type" default="core";
	param name="params.format" default="html";
	docs={
		"controller" = {
			"scope" = "",
			"functions" = "",
			"meta" = {},
			"categories" = []
		},
		"model" = {
			"scope" = "",
			"functions" = "",
			"meta" = {},
			"categories" = []
		}
	};
	switch(params.type){
		case "core":
			docs.controller.scope 		= controller("dummy");
			docs.controller.functions 	= listSort(StructKeyList(docs.controller.scope), "textnocase");
		break;
		case "app":
		break;
	}

	for(doc in docs){
		for(func in listToArray(docs[doc]['functions'])){
			meta=GetMetaData(docs[doc]["scope"][func]);
			docs[doc]["meta"][func]=meta;
			if(structKeyExists(meta, "doc.category")
				&& !arrayFind(docs[doc]["categories"], meta["doc.category"])){
					arrayAppend(docs[doc]["categories"], meta["doc.category"]);
			}
		}
	}

	// Searches for ``` in hint description output
	string function hintOutput(str){
		local.rv=HTMLEditFormat(arguments.str);
		local.rv=replace(local.rv, "```", "<pre>", "one");
		local.rv=replace(local.rv, "```", "</pre>", "one");
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



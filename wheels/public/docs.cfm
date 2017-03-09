<cfscript>
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

	// Merge
	for(doctype in temp){
		// Populate A-Z function List
		for(functionName in listToArray(temp[doctype]['functions']) ){
			// Ignore internal functions
			if(left(functionName, 1) != "$"){
				// Check this isn't a dupe, but record which scope this was from
				if( !ArrayFind(docs.functions, function(struct){
				   return struct.name == functionName;
				})){
					// Set metadata
					meta=parseMetaData(GetMetaData(temp[doctype]["scope"][functionName]), doctype);
					arrayAppend(docs.functions, meta);
				} else {
					if(!ArrayFind(meta.availableIn, doctype)){
						arrayAppend(meta.availableIn, doctype);
					}
				}
			}
		}
		docs.functions = arrayOfStructsSort(docs.functions, "name");
	}

	// Look for custom categories:
	for(doc in docs.functions){
		if(structKeyExists(doc, "section") && len(doc.section)){
			if( !ArrayFind(docs.sections, function(struct){
				   return struct.name == doc.section;
			})){
				arrayAppend(docs.sections, {
					"name": doc.section,
					"categories": []
				});
			}
			for(subsection in docs.sections){
				if(subsection.name == doc.section
					&& len(doc.category)
					&& !arrayFind(subsection.categories, doc.category)){
						arrayAppend(subsection.categories, doc.category);
				}
				arraySort(subsection.categories, "textnocase");
			}
		}
	}
	docs.sections = arrayOfStructsSort(docs.sections, "name");

	// Take a metdata struct and get some additional info
	// Rebuilding the struct to ensure case for serialization
	struct function parseMetaData(meta, doctype){
		local.m=arguments.meta;
		local.rv["name"]=structKeyExists(local.m, "name")?local.m.name:"";
		local.rv["parameters"]=structKeyExists(local.m, "parameters")?local.m.parameters:[];
		local.rv["returntype"]=structKeyExists(local.m, "returntype")?local.m.returntype:"";
		local.rv["hint"]=structKeyExists(local.m, "hint")?local.m.hint:"";
		local.rv["section"]="";
		local.rv["sectionClass"]="";
		local.rv["category"]="";
		local.rv["categoryClass"]="";
		local.rv["availableIn"]=[doctype];
		// Look for [something: Foo] style tags in hint
		if(structKeyExists(local.rv, "hint")){
			local.tags=ReMatchNoCase('\[((.*?):(.*?))\]', local.rv.hint);
			if(arrayLen(local.tags)){
				for(tag in local.tags){
					tagName=replace(listFirst(tag, ":"), "[","","one");
					tagValue=replace(listLast(tag, ":"), "]","","one");
					local.rv[tagName]=tagValue;
					local.rv[tagName & "Class"]=cssClassLink(tagValue);
				}
				local.rv["hint"]=REReplaceNoCase(local.rv["hint"], "\[((.*?):(.*?))\]", "", "ALL");
			}
		}
		// Check for extended documentation
		local.rv["pathToExtended"]=expandPath("wheels/public/docs/reference/" & lcase(functionName) & ".txt");
		local.rv["hasExtended"]=fileExists(local.rv.pathToExtended)?true:false;
		if(local.rv.hasExtended){
			local.rv["extended"]="<pre>" & htmleditformat(fileread(local.rv.pathToExtended)) & "</pre>";
			local.rv["extended"]=trim(local.rv["extended"]);
		}
		return local.rv;
	}

	// Searches for ``` in hint description output
	string function hintOutput(str){
		local.rv=arguments.str;
		local.rv=ReReplaceNoCase(local.rv, '`(\w+)`', '<code>\1</code>', "ALL");
		local.rv=simpleFormat(local.rv);
		return trim(local.rv);
	}


	// Creates a css class from category
	string function cssClassLink(str){
		local.rv=lcase(arguments.str);
		local.rv=replace(local.rv, " ", "", "all");
		return trim(local.rv);
	}

	/**
* Sorts an array of structures based on a key in the structures.
*
* @param aofS      Array of structures.
* @param key      Key to sort by.
* @param sortOrder      Order to sort by, asc or desc.
* @param sortType      Text, textnocase, or numeric.
* @param delim      Delimiter used for temporary data storage. Must not exist in data. Defaults to a period.
* @return Returns a sorted array.
* @author Nathan Dintenfass (nathan@changemedia.com)
* @version 1, December 10, 2001
*/
function arrayOfStructsSort(aOfS,key){
        //by default we'll use an ascending sort
        var sortOrder = "asc";
        //by default, we'll use a textnocase sort
        var sortType = "textnocase";
        //by default, use ascii character 30 as the delim
        var delim = ".";
        //make an array to hold the sort stuff
        var sortArray = arraynew(1);
        //make an array to return
        var returnArray = arraynew(1);
        //grab the number of elements in the array (used in the loops)
        var count = arrayLen(aOfS);
        //make a variable to use in the loop
        var ii = 1;
        //if there is a 3rd argument, set the sortOrder
        if(arraylen(arguments) GT 2)
            sortOrder = arguments[3];
        //if there is a 4th argument, set the sortType
        if(arraylen(arguments) GT 3)
            sortType = arguments[4];
        //if there is a 5th argument, set the delim
        if(arraylen(arguments) GT 4)
            delim = arguments[5];
        //loop over the array of structs, building the sortArray
        for(ii = 1; ii lte count; ii = ii + 1)
            sortArray[ii] = aOfS[ii][key] & delim & ii;
        //now sort the array
        arraySort(sortArray,sortType,sortOrder);
        //now build the return array
        for(ii = 1; ii lte count; ii = ii + 1)
            returnArray[ii] = aOfS[listLast(sortArray[ii],delim)];
        //return the array
        return returnArray;
}


	include "docs/#params.format#.cfm";
</cfscript>


<cfscript>
	param name="params.type" default="core";
	param name="params.format" default="html";

	docs={
		"sections"=[
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
	],
	"functions"=[]
	};

	temp={
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
			temp.controller.scope 		= controller("dummy");
			temp.controller.functions 	= listSort(StructKeyList(temp.controller.scope), "textnocase");
			temp.model.scope 			= createObject("component", "wheels.Model");
			temp.model.functions 		= listSort(StructKeyList(temp.model.scope), "textnocase");
		break;
		case "app":
		break;
	}

	// Merge
	for(doctype in temp){
		// Populate A-Z function List
		for(functionName in listToArray(temp[doctype]['functions']) ){
			// Ignore internal functions
			if(left(functionName, 1) != "$"){
				// Check this isn't a dup
				if( !ArrayFind(docs.functions, function(struct){
				   return struct.name == functionName;
				})){
					// Set metadata
					meta=GetMetaData(temp[doctype]["scope"][functionName]);
					meta["section"]="";
					meta["sectionClass"]="";
					meta["category"]="";
					meta["categoryClass"]="";
					if(structKeyExists(meta, "doc.section")){
						meta["section"]=meta["doc.section"];
						meta["sectionClass"]=cssClassLink(meta["doc.section"]);
						structDelete(meta, "doc.section");
					}
					if(structKeyExists(meta, "doc.category")){
						meta["category"]=meta["doc.category"];
						meta["categoryClass"]=cssClassLink(meta["doc.category"]);
						structDelete(meta, "doc.category");
					}
					meta["pathToExtended"]=expandPath("wheels/public/docs/reference/" & lcase(functionName) & ".md");
					// Check for extended docs
					meta["hasExtended"]=fileExists(meta.pathToExtended)?true:false;
					if(meta.hasExtended){
						meta["extended"]=fileread(meta.pathToExtended);
						//writeDump(meta);
						//abort;
					}
					arrayAppend(docs.functions, meta);
				}
			}
		}
		docs.functions = arrayOfStructsSort(docs.functions, "name");

	}


	// Searches for ``` in hint description output
	string function hintOutput(str){
		local.rv=arguments.str;
		// Try for hint
		local.hint=ReMatch('.+?```', local.rv );
		if(arraylen(local.hint)){
			local.hint=ReReplaceNoCase(local.hint[1], '```', '', 'all');
			local.hint=ReReplaceNoCase(local.hint, '`(\w+)`', '<code>\1</code>', "ALL");
			local.hint=simpleFormat(local.hint);
		} else {
			local.hint="";
		}
		// Try for code example(s?)
		local.code=ReMatch('```(.+?)```', local.rv );
		if(arraylen(local.code)){
			local.code = local.code[1];
			local.code = Trim(local.code);
			local.code = Replace(local.code, Chr(13), "", "all");
			local.code = Replace(local.code, Chr(10) & Chr(9) & Chr(9), Chr(10), "all");
			local.code = HTMLEditFormat(local.code);
			local.code = ReReplaceNoCase(local.code, '```(.+?)```', '<pre>\1</pre>', "ALL");
			local.code = ReReplaceNoCase(local.code, '(?!<pre[^>]*>)(`(\w+)`)(?![^<]*<\/pre>)', '<code>\2</code>', "ALL");
			local.code = ReReplaceNoCase(local.code, '\/\/ (.*?)\. ', "<br>// \1<br>", "ALL");
			//local.code = ReReplaceNoCase(local.code, ';', "\1;<br>", "ALL");
		} else {
			local.code="";
		}

		local.rv=local.hint & local.code;
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

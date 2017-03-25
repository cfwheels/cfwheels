<cfscript>
	param name="params.type" default="core";
	param name="params.format" default="html";
	// Embedded Documentation Helpers

	// Example Expected comment
	/**
	* I am the function hint. Backticks replaced with code; tags below get replaced.
	* Tags must appear before Params
	*
	* [section: Doc Section]
	* [category: Doc Category] (optional)
	*
	* @paramName Hint for Param. Backticks replaced with code; [doc: AFunctionName] replaced with link
	*/

	/**
	* Take a metadata struct as from getMetaData() and get some additional info
	*
	* @meta metadata struct as returned from getMetaData()
	* @doctype ie. Controller || Model
	*/
	struct function $parseMetaData(required struct meta, required string doctype, required string functionName){
		local.m=arguments.meta;
		local.rv["name"]=structKeyExists(local.m, "name")?local.m.name:"";
		local.rv["isPlugin"]=false;
		local.rv["availableIn"]=[doctype];
		// Pluginrunner override: see #735
		if(left(local.rv.name, 1) == "$"){
			local.rv["name"]=lcase(functionName);
			local.rv["isPlugin"]=true;
		}
		local.rv["slug"]=$createFunctionSlug(doctype, local.rv.name);
		local.rv["parameters"]=structKeyExists(local.m, "parameters")?local.m.parameters:[];
		local.rv["returntype"]=structKeyExists(local.m, "returntype")?local.m.returntype:"";
		local.rv["hint"]=structKeyExists(local.m, "hint")?local.m.hint:"";
		local.rv["tags"]={};

		// Look for [something: Foo] style tags in hint
		if(structKeyExists(local.rv, "hint")){
			local.rv.tags["section"]=$getDocTag(local.rv.hint, "section");
			local.rv.tags["sectionClass"]=$cssClassLink(local.rv.tags.section);
			local.rv.tags["category"]=$getDocTag(local.rv.hint, "category");
			local.rv.tags["categoryClass"]=$cssClassLink(local.rv.tags.category);
			local.rv.hint=$replaceDocLink(local.rv.hint);
			local.rv.hint=$stripDocTags(local.rv.hint);
			local.rv.hint=$backTickReplace(local.rv.hint);
		}

		// Check for param defaults within wheels settings
		for(param in local.rv["parameters"]){
			if(structKeyExists(application.wheels.functions, local.rv.name)
				&& structKeyExists(application.wheels.functions[local.rv.name], param.name)){
					param['default']=application.wheels.functions[local.rv.name][param.name];
				}
			if(structKeyExists(param, "hint")){
				param['hint']=$replaceDocLink(param.hint);
			}
		}
		// Check for extended documentation: note this is not looked for by slug, i.e. controller/humanize.txt
		local.rv["extended"]=$getExtendedCodeExamples("wheels/public/docs/reference/", local.rv.slug);
		return local.rv;
	}

	/**
	* Creates a function slug
	*/
	string function $createFunctionSlug(required string doctype, required string functionName){
		return doctype & '.' & functionName;
	}

	/**
	* Retrieve a [tag: foo] style tag
	* Returns a comma delim list of matches
	*
	* @string String to search
	* @tagname Tag to find
	**/
	string function $getDocTag(required string string, required string tagname){
		local.rv="";
		local.string=arguments.string;
		local.tagname=arguments.tagname;
		local.tags=ReMatchNoCase('\[((' & local.tagname & '?):(.*?))\]', local.string);
		if(arrayLen(local.tags)){
			for(local.tag in local.tags){
				local.rv=listAppend(local.rv, trim(replace(listLast(local.tag, ":"), "]","","one")));
			}
		}
		return local.rv;
	}
	/**
	* Directly replace a doc tag i.e format [doc:functionName] to a hashLink
	*
	* @string String to search
	**/
	string function $replaceDocLink(required string string){
		local.rv=arguments.string;
		local.tags=ReMatchNoCase('\[((doc?):(.*?))\]', local.rv);
		if(arrayLen(local.tags)){
			for(local.tag in local.tags){
				local.link=replace(listLast(local.tag, ":"), "]","","one");
				local.rv=replaceNoCase(local.rv, local.tag, "<a href='##" & lcase(local.link) & "'>" & local.link & "</a>");
			}
		}
		return local.rv;
	}
	/**
	* Strip [tag: foo] style tags
	*
	* @string String to search
	**/
	string function $stripDocTags(required string string){
		return REReplaceNoCase(arguments.string, "\[((.*?):(.*?))\]", "", "ALL");
	}


	/**
	* Check for Extended Docs
	*
	* @pathToExtended The Path to the Extended doc txt files
	* @functionName The Function Name
	*/
	struct function $getExtendedCodeExamples(pathToExtended, slug){
		local.rv={};
		local.rv["path"]=expandPath(pathToExtended) & lcase(replace(slug, ".", "/", "one")) & ".txt";
		local.rv["hasExtended"]=fileExists(local.rv.path)?true:false;
		local.rv["docs"]="";
		if(local.rv.hasExtended){
			local.rv["docs"]="<pre>" & htmleditformat(fileread(local.rv.path)) & "</pre>";
			local.rv["docs"]=trim(local.rv["docs"]);
		}
		return local.rv;
	}

	/**
	* Formats the Main Hint
	*
	* @str The Hint String
	*/
	string function $hintOutput(str){
		local.rv=$backTickReplace(arguments.str);
		return simpleFormat(trim(local.rv));
	}

	/**
	* Searches for ``` in hint description output and formats
	*
	* @str The String to search
	*/
	string function $backTickReplace(str){
		return ReReplaceNoCase(arguments.str, '`(.*?)`', '<code>\1</code>', "ALL");
	}
	/**
	* Turns "My Thing" into "mything"
	*
	* @str The String
	*/
	string function $cssClassLink(str){
		return trim(replace(lcase(str), " ", "", "all"));
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
	function $arrayOfStructsSort(aOfS,key){
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

	include "docs/#params.type#.cfm";
</cfscript>

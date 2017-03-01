<cfscript>
	param name="params.type" default="core";
	param name="params.format" default="html";

	switch(params.type){
		case "core":
			controllerScope 	= controller("dummy");
			controllerFunctions = listSort(StructKeyList(controllerScope), "textnocase");
		break;
		case "app":
		break;
	}

	//modelScope = model("dummy");
	//modelFunctions = StructKeyList(modelScope);

	string function hintOutput(str){
		local.rv=HTMLEditFormat(arguments.str);
		local.rv=replace(local.rv, "```", "<pre>", "one");
		local.rv=replace(local.rv, "```", "</pre>", "one");
		return trim(local.rv);
	}

	include "docs/#params.format#.cfm";
</cfscript>



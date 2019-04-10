<cfscript>

type = request.wheels.params.type;

subnavigation = [
	{
		route="wheelsPackages", type="app", text="<i class='tasks icon'></i> App"
	},
	{
		route="wheelsPackages", type="core", text="<i class='tasks icon'></i> Core"
	},
];
pluginList = "";
if(application.wheels.enablePluginsComponent){
	pluginList = structKeyList(application.wheels.plugins);
}


// Get Plugins
for(var p in pluginList){
	arrayAppend(subnavigation, {
		"route"="wheelsPackages", "type"=p, "text"="<i class='plug icon'></i> #p#"
	});
}

</cfscript>
<cfoutput>
<div class="ui pointing stackable menu">


	<cfloop from="1" to="#arrayLen(subnavigation)#" index="i">
		<cfscript>
		navArgs = {
			"class"="item",
			"encode"="attributes",
			"route"=subnavigation[i]['route'],
			"text"=subnavigation[i]['text']
		};
		if(structKeyExists(subnavigation[i], "type"))
			navArgs['type'] = subnavigation[i]['type'];
		</cfscript>
		#linkTo(argumentCollection = navArgs)#
	</cfloop>

<!--- Plugins --->
</div>

<div class="ui segment">
	#linkTo(route="wheelsTests", class="ui button blue", encode="attributes", type = type, text="Run All #UCASE(type)# Tests <i class='right arrow icon'></i> ")#
	#linkTo(route="wheelsTests", class="ui button teal", encode="attributes", type = type, params="reload=true", text="Run All #UCASE(type)# Tests with Reload <i class='right refresh icon'></i> ")# 
</div>
</cfoutput>

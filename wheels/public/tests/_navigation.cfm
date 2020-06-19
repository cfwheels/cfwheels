<cfscript>
formats = DirectoryList(ExpandPath("/wheels/public/tests"), false, "name", "", "name")
	.filter(function(name) {
		return !Find("_", arguments.name);
	}).map(function(name) {
		return ListFirst(arguments.name, ".");
	});

type = request.wheels.params.type;
packageParamKeys = [
	"package",
	"test",
	"reload",
	"db",
	"format",
	"refresh"
];
_params = "";
for (key in packageParamKeys) {
	if (StructKeyExists(url, key)) {
		_params = ListAppend(_params, "#key#=#url[key]#", "&");
	}
}

subnavigation = [{route = "wheelsPackages", type = "app", text = "<i class='tasks icon'></i> App"}];
if (DirectoryExists(ExpandPath("/wheels/tests"))) {
	ArrayAppend(subnavigation, {route = "wheelsPackages", type = "core", text = "<i class='tasks icon'></i> Core"});
}

pluginList = "";
if (application.wheels.enablePluginsComponent) {
	pluginList = StructKeyList(application.wheels.plugins);
}

// Get Plugins
for (p in pluginList) {
	ArrayAppend(subnavigation, {"route" = "wheelsPackages", "type" = p, "text" = "<i class='plug icon'></i> #p#"});
}
</cfscript>
<cfoutput>
	<div class="ui pointing stackable menu">
		<cfloop from="1" to="#ArrayLen(subnavigation)#" index="i">
			<cfscript>
			navArgs = {"route" = subnavigation[i]['route'], "text" = subnavigation[i]['text']};
			if (StructKeyExists(subnavigation[i], "type")) navArgs['type'] = subnavigation[i]['type'];
			</cfscript>
			<a href="#urlFor(argumentCollection = navArgs)#" class="item">#navArgs['text']#</a>
		</cfloop>
		<!--- Plugins --->
	</div>

	<div class="ui segment">
		<div class="ui grid">
			<div class="two column row">
				<div class="four wide column">
					<!--- Route Filter --->
					<div class="ui action input">
						<input
							type="text"
							class="table-searcher"
							name="package-search" id="package-search"
							placeholder="Quick find..."
						>
						<button class="ui icon button matched-count">
							<i class="search icon"></i>
							<span class="matched-count-value"></span>
						</button>
					</div>
				</div>
				<div class="twelve wide column right aligned">
					<cfif StructKeyExists(url, "refresh")>
						<a href="#urlFor(route = "wheelsTests", type = type, params = ReplaceNoCase(_params, "refresh=#url.refresh#", ""))#" class="ui button blue active">
							Stop <i class='right stop icon'></i>
						</a>
					<cfelse>
						<a href="#urlFor(route = "wheelsTests", type = type, params = "#_params#&refresh=true")#" class="ui button basic blue">
							Refresh <i class='right play icon'></i>
						</a>
					</cfif>
					<cfif StructKeyExists(url, "reload")>
						<a href="#urlFor(route = "wheelsTests", params = ReplaceNoCase(_params, "reload=#url.reload#", ""), type = type)#" class="ui button blue">
							Without Reload <i class='right refresh icon'></i>
						</a>
					<cfelse>
						<a href="#urlFor(route = "wheelsTests", params = "#_params#&reload=true", type = type)#" class="ui button basic blue">
							Reload <i class='right refresh icon'></i>
						</a>
					</cfif>
					<a href="#urlFor(route = "wheelsTests", type = type, params = _params)#" class="ui button basic blue">
						Run All Tests <i class='right arrow icon'></i>
					</a>
					<cfloop array="#formats#" index="_format">
						<cfif StructKeyExists(url, "format")>
							<cfset __params = ReplaceNoCase(_params, "format=#url.format#", "format=#_format#")>
						<cfelse>
							<cfset __params = ListAppend(_params, "format=#_format#", "&")>
						</cfif>
						<a href="#urlFor(route = "wheelsTests", type = type, params = __params)#" class="ui button basic<cfif _format == "html"> active</cfif>">
							#_format#
						</a>
					</cfloop>
				</div>
			</div>
		</div>
	</div>
</cfoutput>

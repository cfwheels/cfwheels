<cfscript>
type = request.wheels.params.type;
_params = [];
for (p in ["package", "test", "reload", "db", "format"]) {
	if (StructKeyExists(url, p)) {
		ArrayAppend(_params, "#p#=#url[p]#")
	}
}
_params = ArrayToList(_params, "&");

subnavigation = [{route = "wheelsPackages", type = "app", text = "<i class='tasks icon'></i> App"}];
if (DirectoryExists(ExpandPath("/wheels/tests"))) {
	ArrayAppend(subnavigation, {route = "wheelsPackages", type = "core", text = "<i class='tasks icon'></i> Core"})
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
				<div class="left floated column">
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
				<div class="right floated column">
					<a href="#urlFor(route = "wheelsTests", type = type, params = "#_params#&refresh=true")#" class="ui button blue">
						Refresh <i class='right refresh icon'></i>
					</a>
					<a href="#urlFor(route = "wheelsTests", type = type, params = _params)#" class="ui button blue">
						Run Tests <i class='right arrow icon'></i>
					</a>
					<a href="#urlFor(route = "wheelsTests", params = "#_params#&reload=true", type = type)#" class="ui button teal">
						Run Tests with Reload <i class='right refresh icon'></i>
					</a>
				</div>
			</div>
		</div>
	</div>
</cfoutput>

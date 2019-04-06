<cfinclude template="../layout/_header.cfm">
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

pluginList = structKeyList(application.wheels.plugins);

// Get Plugins
for(var p in pluginList){
	arrayAppend(subnavigation, {
		"route"="wheelsPackages", "type"=p, "text"="<i class='plug icon'></i> #p#"
	});
}


packages = $createObjectFromRoot(path=application.wheels.wheelsComponentPath, fileName="Test", method="$listTestPackages", options=request.wheels.params);
// Change this
linkParams = "?controller=wheels&action=wheels&view=tests&type=#type#";

// ignore packages before the "tests directory"
if (packages.recordCount) {
	allPackages = ListToArray(packages.package, ".");
	preTest = "";
	for (i in allPackages) {
		preTest = ListAppend(preTest, i, ".");
		if (i eq "tests") {
			break;
		}
	}
}

</cfscript>
<cfoutput>


<div class="ui container">
	#pageHeader(capitalize(type) & " Test Suite", "Core &amp; App test suites")#

<!---div class="ui pointing stackable menu">


	<cfloop from="1" to="#arrayLen(subnavigation)#" index="i">
		<cfscript>
		navArgs = {
			"class"=isActiveClass(subnavigation[i]['type'], type),
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
</div--->


<div class="ui segment">

	<p>Below is listing of all the #type# test packages. Click the part of the package to run it individually.</p>

	#startTable("Tests")#

		<cfif packages.recordcount>
			<cfloop query="packages">
				<tr><td>
					<cfset testablePackages = ListToArray(ReplaceNoCase(package, "#preTest#.", "", "one"), ".")>
					<cfset packagesLen = arrayLen(testablePackages)>
					<cfloop from="1" to="#packagesLen#" index="i">
						#linkTo(route="wheelsTests",
								params="package=#ArrayToList(testablePackages.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#&format=html",
								text=testablePackages[i] )#<cfif i neq packagesLen> .</cfif>
					</cfloop>
				</td></tr>
			</cfloop>
		<cfelse>
			<span class="failure-message-item">No Test Packages Found</span>
		</cfif>

	#endTable()#

</div>
</div>

</cfoutput>

<cfinclude template="../layout/_footer.cfm">


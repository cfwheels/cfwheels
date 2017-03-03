<cfscript>
param name="params.type" default="core";
packages = $createObjectFromRoot(path=application.wheels.wheelsComponentPath, fileName="Test", method="$listTestPackages", options=params);
linkParams = "?controller=wheels&action=wheels&view=tests&type=#params.type#";
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
    <div class="row">

      <div class="column">
        <h1>#titleize(params.type)# Test Packages</h1>

<p>Below is listing of all the #params.type# test packages. Click the part of the package to run it individually.</p>
      </div>

      <div class="column">
        <p class="float-right">
         <a class="button button-outline" href="#linkParams#">Run All Tests</a> <a  class="button button-outline" href="#linkParams#&reload=true">Reload Test Data</a>
        <p>
      </div>

    </div>

	<p>
	<cfif packages.recordcount>
		<cfloop query="packages">
				<cfset testablePackages = ListToArray(ReplaceNoCase(package, "#preTest#.", "", "one"), ".")>
				<cfset packagesLen = arrayLen(testablePackages)>
				<cfloop from="1" to="#packagesLen#" index="i">
					<cfset href = "#linkParams#&package=#ArrayToList(testablePackages.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#">
					<a href="#href#">#testablePackages[i]#</a><cfif i neq packagesLen> .</cfif>
				</cfloop><br />
		</cfloop>
	<cfelse>
		<span class="failure-message-item">No Test Packages Found</span>
	</cfif>
	</p>
</cfoutput>

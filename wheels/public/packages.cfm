<cfparam name="params.type" default="core">
<cfset packages = $createObjectFromRoot(path=application.wheels.wheelsComponentPath, fileName="Test", method="$listTestPackages", options=params)>
<cfset linkParams = "?controller=wheels&action=wheels&view=tests&type=#params.type#">
<!--- ignore packages before the "tests directory" --->
<cfif packages.recordCount>
	<cfset allPackages = ListToArray(packages.package, ".")>
	<cfset preTest = "">
	<cfloop from="1" to="#ArrayLen(allPackages)#" index="i">
		<cfset preTest = ListAppend(preTest, allPackages[i], ".")>
		<cfif allPackages[i] IS "tests">
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>
<cfoutput>
<p><a href="#linkParams#" target="_blank">Run All Tests</a> | <a href="#linkParams#&reload=true" target="_blank">Reload Test Data</a></p>
<h1>#titleize(params.type)# Test Packages</h1>
<p>Below is listing of all the #params.type# test packages. Click the part of the package to run it individually.</p>
<cfloop query="packages">
	<p>
		<cfset testablePackages = ListToArray(ReplaceNoCase(package, "#preTest#.", "", "one"), ".")>
		<cfset packagesLen = arrayLen(testablePackages)>
		<cfloop from="1" to="#packagesLen#" index="i">
			<cfset href = "#linkParams#&package=#ArrayToList(testablePackages.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#">
			<a href="#href#" target="_blank">#testablePackages[i]#</a><cfif i neq packagesLen> .</cfif>
		</cfloop>
	</p>
</cfloop>
</cfoutput>

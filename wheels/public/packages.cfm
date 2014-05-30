<cfparam name="params.type" default="core">
<cfset packages = $createObjectFromRoot(path=application.wheels.wheelsComponentPath, fileName="Test", method="$listTestPackages", options=params)>
<cfset linkParams = "?controller=wheels&action=wheels&view=tests&type=#params.type#">
<cfoutput>
<p><a href="#linkParams#" target="_blank">Run All Tests</a> | <a href="#linkParams#&reload=true" target="_blank">Reload Test Data</a></p>
<h1>Core Test Packages</h1>
<p>Since running the core test take so long that they die on some confgurations :P</p>
<p>Below is listing of all the test packages in core. Click the part of the package to run it individually.</p>
<cfloop query="packages">
	<cfset _package = ReplaceNoCase(package, "wheels.tests.", "")>
	<p>
			<cfset a = ListToArray(_package, ".")>
			<cfset b = createObject("java", "java.util.ArrayList").Init(a)>
			<cfset c = arraylen(a)>
			<cfloop from="1" to="#c#" index="i"><a href="#linkParams#&package=#ArrayToList(b.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#" target="_blank">#a[i]#</a><cfif i neq c>.</cfif></cfloop>
	</p>
</cfloop>
</cfoutput>
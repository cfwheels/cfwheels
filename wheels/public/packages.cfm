<cfparam name="params.type" default="core">
<cfset packages = $createObjectFromRoot(path=application.wheels.wheelsComponentPath, fileName="Test", method="$listTestPackages", options=params)>
<cfset linkParams = "?controller=wheels&action=wheels&view=tests&type=#params.type#">
<cfoutput>
<p><a href="#linkParams#" target="_blank">Run All Tests</a> | <a href="#linkParams#&reload=true" target="_blank">Reload Test Data</a></p>
<h1>#titleize(params.type)# Test Packages</h1>
<p>Below is listing of all the #params.type# test packages. Click the part of the package to run it individually.</p>
<cfif params.type is "core">
	<cfset strip = "wheels.tests">
<cfelseif params.type is "app">
	<cfset strip = "tests.">
<cfelse><!--- assumed to be a plugin --->
	<cfset strip = "plugins.#params.type#.tests.">
</cfif>
<cfloop query="packages">
	<p>
		<cfset a = ListToArray(ReplaceNoCase(package, strip, "", "one"), ".")>
		<cfset b = createObject("java", "java.util.ArrayList").Init(a)>
		<cfset c = arraylen(a)>
		<cfloop from="1" to="#c#" index="i">
			<cfset href = "#linkParams#&package=#ArrayToList(b.subList(JavaCast('int', 0), JavaCast('int', i)), '.')#">
			<a href="#href#" target="_blank">#a[i]#</a><cfif i neq c> .</cfif>
		</cfloop>
	</p>
</cfloop>
</cfoutput>
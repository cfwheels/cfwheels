<cfset outputPath = 'builders/output/docs'>

<cfset api = createObject("component", "builders.api.ApiGenerator").init(
	wheelsDirectory = "#ExpandPath('wheels')#"
	,wheelsAPIChapterDirectory = "#ExpandPath('wheels/docs/Wheels API')#"
	,wheelsComponentPath="wheels"
	,outputPath=ExpandPath(outputPath)
)>

<cfinclude template="../../builders/api/overloads.cfm">

<cfset results = api.build()>

<cfif ArrayLen(results.errors)>
<h1>Warning!</h1>
<p>Markers are used to reference documentation from other methods.</p>
<p>The following markers could not be found! You will need to correct these before a you can build the documentation:</p>
<table border="1">
	<tr>
		<th>Class</th>
		<th>Method</th>
		<th>Arguments</th>
	</tr>
	<cfoutput>
	<cfloop array="#results.errors#" index="i">
		<tr>
			<td>#i.class#</td>
			<td>#i.method#</td>
			<td>#i.argument#</td>
		</tr>
	</cfloop>
	</cfoutput>
</table>
<cfabort>
</cfif>

<h1>Api Documentation has been generated!</h1>

<p>The outputted XML file can be found here:</p>
<p><cfoutput>#outputPath#</cfoutput></p>
<p>This can be used to create </p>

<h3>Below is a dump of the documentation structure. Overload any of the documentation in the `overloads.cfm` file.</h3>
<cfflush>
<cfdump var="#results.data#">
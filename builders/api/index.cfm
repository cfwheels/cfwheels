<cfparam name="url.xml" type="boolean" default="false">
<cfinclude template="overloads.cfm">
<cfset api = createObject("component", "ApiGenerator").init(
	wheelsDirectory = "#ExpandPath('../../wheels')#"
	,wheelsAPIChapterDirectory = "#ExpandPath('../../wheels/docs/Wheels API')#"
	,overloads = overloads
)>
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

<cfif url.xml>
	<!--- output the api documentation to xml --->
	<cffile action="write" file="#ExpandPath('../../../cfwheels-api.xml')#" output="#api.toXML()#">
</cfif>

<h1>Api Documentation has been generated!</h1>
<cfif url.xml>
<p>The outputted XML file can be found here:</p>
<p><cfoutput>#ExpandPath('../../../cfwheels-api.xml')#</cfoutput></p>
</cfif>
<h3>Below is a dump of the documentation structure. Overload any of the documentation in the `overloads.cfm` file.</h3>
<cfflush>
<cfdump var="#results.data#">
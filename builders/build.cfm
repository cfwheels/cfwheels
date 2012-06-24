<cfset api = createObject("component", "ApiGenerator").init()>
<cfset errors = api.build()>

<cfif ArrayLen(errors)>
<h1>Warning!</h1>
<p>The following markers could not be replaced! You will need to correct these before a you can build a release:</p>
<table border="1">
	<tr>
		<th>Class</th>
		<th>Method</th>
		<th>Arguments</th>
	</tr>
	<cfoutput>
	<cfloop array="#errors#" index="i">
		<tr>
			<td>#i.class#</td>
			<td>#i.method#</td>
			<td>#i.argument#</td>
		</tr>
	</cfloop>
	</cfoutput>
</table>
<cfelse>
	<cfset release = createObject("component", "ReleaseGenerator").init()>
	<cfset release.build()>
	
	<h1>Build Successful!</h1>
	
</cfif>